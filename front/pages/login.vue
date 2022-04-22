<template>
  <div>
    <h2>ログイン</h2>
    <v-form>
      <v-container>
        <v-text-field
          v-model="email"
          :counter="20"
          label="メールアドレス"
          required
        ></v-text-field>
        <v-text-field
          v-model="password"
          label="パスワード"
          required
          :type="show1 ? 'text' : 'password'"
          :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
          @click:append="show1 = !show1"
        ></v-text-field>
        <v-btn class="mr-4" @click="login">ログイン</v-btn>
        <p v-if="error" class="error-message">{{ error }}</p>
      </v-container>
    </v-form>
    <p><GuestLoginButton /></p>
    <p>1クリックでログインできます</p>
    <nuxt-link :to="`/signup`">新規登録はこちら</nuxt-link>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import GuestLoginButton from "@/components/GuestLoginButton";

export default {
  head() {
    return {
      title: "ログイン",
    };
  },
  data() {
    return {
      email: "",
      password: "",
      show1: false,
      error: null,
    };
  },
  components: {
    GuestLoginButton,
  },
  methods: {
    async login() {
      this.error = null;
      await firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .catch((error) => {
          switch (error.code) {
            case "auth/user-not-found":
              this.error = "メールアドレスが見つかりません";
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
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "ログインしました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 2000);

        this.$router.push("/");
      }
    },
  },
};
</script>

