<template>
  <div>
    <h2>新規登録</h2>
    <ValidationObserver v-slot="{ invalid }" ref="signupObserver">
      <v-form>
        <v-container>
          <ValidationProvider
            rules="required|max:30"
            name="ユーザー名"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="name"
              :counter="30"
              label="ユーザー名"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:100|email"
            name="メールアドレス"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="email"
              :counter="100"
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
              :type="show1 ? 'text' : 'password'"
              :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
              @click:append="show1 = !show1"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|min:6|confirmed:パスワード"
            name="パスワード（確認用）"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="password_confirmation"
              label="パスワード（確認用）"
              :type="show2 ? 'text' : 'password'"
              :append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
              @click:append="show2 = !show2"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-btn :disabled="invalid" @click="signup">新規登録</v-btn>
          <p v-if="error" class="error-message">{{ error }}</p>
        </v-container>
      </v-form>
    </ValidationObserver>
    <p><GuestLoginButton /></p>
    <p>1クリックでログインできます</p>
    <nuxt-link :to="`/login`">ログインはこちら</nuxt-link>
  </div>
</template>
<script>
import axios from "@/plugins/axios";
import firebase from "@/plugins/firebase";
import GuestLoginButton from "@/components/GuestLoginButton";

export default {
  head() {
    return {
      title: "新規登録",
    };
  },
  components: {
    GuestLoginButton,
  },
  data() {
    return {
      email: "",
      name: "",
      password: "",
      password_confirmation: "",
      show1: false,
      show2: false,
      error: "",
    };
  },
  methods: {
    async signup() {
      if (this.password !== this.password_confirmation) {
        this.error = "※パスワードとパスワード確認が一致していません";
      }
      const res = await firebase
        .auth()
        .createUserWithEmailAndPassword(this.email, this.password)
        .catch((error) => {
          this.error = ((code) => {
            switch (code) {
              case "auth/email-already-in-use":
                return "既にそのメールアドレスは使われています";
              case "auth/wrong-password":
                return "※パスワードが正しくありません";
              case "auth/weak-password":
                return "※パスワードは最低6文字以上にしてください";
              default:
                return "※メールアドレスとパスワードをご確認ください";
            }
          })(error.code);
        });

      const user = {
        email: res.user.email,
        name: this.name,
        uid: res.user.uid,
        // 初期値
        profile: "よろしくおねがいします！",
      };
      this.$store.dispatch("loading/setLoading", true);
      const { data } = await axios
        .post("/v1/users", {
          user,
        })
        .catch((err) => {
          console.log({
            err,
          });
        });
      setTimeout(() => {
        this.$store.dispatch("loading/setLoading", false);
      }, 3000);
      this.$store.dispatch("auth/setUser", data);
      this.$router.push("/");
      this.$refs.signupObserver.reset();

      // ロードの画面出したあとにフラッシュ出すようにしたい
      // が、フラッシュのコード書くと投稿が追加できなくなった
    },
  },
};
</script>
