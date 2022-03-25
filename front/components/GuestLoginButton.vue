<template>
  <div>
    <v-btn color="blue" @click="guestSignIn">ゲストログイン</v-btn>
  </div>
</template>
<script>
import firebase from "@/plugins/firebase";

export default {
  data() {
    return {
      guestUser: { email: "guest@guest.com", password: "guestuser" },
    };
  },
  methods: {
    // あらかじめ作成したユーザーにログイン
    async guestSignIn() {
      await firebase
        .auth()
        .signInWithEmailAndPassword(
          this.guestUser.email,
          this.guestUser.password
        )
        .then(() => {
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "ゲストユーザーとしてログインしました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
          this.$router.push("/");
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>