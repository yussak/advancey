<template>
  <div>
    <v-dialog v-model="deleteUserDialog">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="red"
          v-if="user.email === 'guest@guest.com'"
          onclick="return confirm('ゲストユーザーは退会できません');"
          >退会する</v-btn
        >
        <v-btn
          v-else
          color="red"
          dark
          v-bind="attrs"
          v-on="on"
          @click="ReLoginDialog = true"
        >
          退会する
        </v-btn>
      </template>
      <v-card>
        <v-card-title>再認証</v-card-title>
        <v-card-text
          >退会するためには、まずメールアドレス・パスワードを入力して再認証してください</v-card-text
        >
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="deleteUserDialog = false">
            キャンセル
          </v-btn>
        </v-card-actions>
        <v-card-text style="height: 300px">
          <ValidationObserver v-slot="{ invalid }" ref="deleteUserObserver">
            <v-form>
              <ValidationProvider
                rules="required|max:100|email"
                name="メールアドレス"
                v-slot="{ errors }"
              >
                <v-text-field
                  v-model="email"
                  label="メールアドレス"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <ValidationProvider
                rules="required|min:6"
                name="パスワード"
                v-slot="{ errors }"
              >
                <v-text-field
                  v-model="password"
                  label="パスワード"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <p v-if="error" class="error-message">{{ error }}</p>
              <v-btn
                :disabled="invalid"
                color="blue darken-1"
                text
                @click="reLogin"
              >
                再認証する
              </v-btn>
            </v-form>
          </ValidationObserver>
        </v-card-text>
        <v-card-actions>
          <v-btn disabled v-if="!reAuthStatus">退会する</v-btn>
          <v-btn color="blue darken-1" text @click="deleteUser" v-else>
            退会する
          </v-btn>
          <v-btn color="blue darken-1" text @click="deleteUserDialog = false">
            キャンセル
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      deleteUserDialog: false,
      reAuthStatus: false,
      email: "",
      password: "",
      error: null,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async reLogin() {
      await firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .catch((error) => {
          switch (error.code) {
            case "auth/user-not-found":
              this.error = "メールアドレスが間違っています";
              return;
            case "auth/wrong-password":
              this.error = "※パスワードが正しくありません";
              return;
            default:
              this.error = "※メールアドレスとパスワードをご確認ください";
              return;
          }
        });
      if (this.error === null) {
        alert("再認証に成功しました。退会ボタンをクリックしてください");
        this.reAuthStatus = true;
      }
    },
    async deleteUser() {
      const res = confirm("削除すると戻せません。よろしいですか？");
      const user = await firebase.auth().currentUser;
      if (res) {
        user.delete();
        axios.delete(`/v1/users/${this.user.id}`).then(() => {
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "アカウントを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
        this.email = "";
        this.password = "";
        this.deleteUserDialog = false;
        this.$refs.deleteUserObserver.reset();
      }
    },
  },
};
</script>