<template>
  <div>
    <div v-if="user">
      <h2 class="text-center">
        <span style="color: red; font-weight: normal; font-size: 20px"
          >ここにアイコン画像</span
        >{{ user.name }}さん
      </h2>
      <p>フォロー中：</p>
      <p>フォロワー：</p>
      <!-- 編集画面で表示させる・マイページには出さない -->
      <!-- <p>email: {{ user.email }}</p> -->
    </div>
    <!-- 編集画面で表示させる・マイページには出さない -->
    <!-- <v-btn @click="logOut">ログアウト</v-btn> -->
    <!-- <v-btn @click="deleteUser">退会する</v-btn> -->
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
export default {
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async logOut() {
      await firebase
        .auth()
        .signOut()
        .catch((error) => {
          console.log(error);
        });

      this.$store.dispatch("auth/setUser", null);
      this.$router.push("/login");
    },

    deleteUser() {
      const user = firebase.auth().currentUser;
      user
        .delete()
        .then(() => {
          alert("User deleted.");
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
  fetch({ store, redirect }) {
    store.watch(
      (state) => state.auth.currentUser,
      (newUser, oldUser) => {
        if (!newUser) {
          return redirect("/login");
        }
      }
    );
  },
};
</script>

<style>
</style>
