<template>
  <div>
    <v-list dense>
      <v-list-item
        v-for="(item, i) in items"
        :key="i"
        :to="item.to"
        router
        exact
      >
        <v-list-item-content>
          <v-list-item-title v-text="item.title" />
        </v-list-item-content>
      </v-list-item>
      <v-list-item v-if="!user">
        <v-list-item-content>
          <GuestLoginButton />
        </v-list-item-content>
      </v-list-item>
      <v-list-item>
        <v-btn :to="`/`" v-if="user">投稿する</v-btn>
      </v-list-item>
      <v-list-item>
        <v-btn :to="`/topics`" v-if="user">質問する</v-btn>
      </v-list-item>
      <v-list-item v-if="user">
        <DeleteUserDialog />
      </v-list-item>
      <v-list-item v-if="user">
        <ChangeAdminDialog />
      </v-list-item>
      <v-list-item v-if="user">
        <v-btn @click="logOut">ログアウト</v-btn>
      </v-list-item>
    </v-list>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";

export default {
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    items() {
      if (this.user) {
        return [
          {
            title: "ホーム",
            to: "/",
          },
          {
            title: "マイページ",
            to: `/users/${this.user.id}`,
          },
          {
            title: "掲示板",
            to: "/topics",
          },
          {
            title: "コミュニティ",
            to: "/communities",
          },
          {
            title: "サービス詳細",
            to: "/about",
          },
          {
            title: "ユーザー一覧",
            to: "/users",
          },
          {
            title: "非公開メモ",
            to: "/private_posts",
          },
          {
            title: "目標一覧",
            to: "/goals",
          },
        ];
      } else {
        return [
          {
            title: "ログイン",
            to: "/login",
          },
          {
            title: "新規登録",
            to: "/signup",
          },
        ];
      }
    },
  },
  methods: {
    async logOut() {
      await firebase
        .auth()
        .signOut()
        .catch((err) => {
          console.log(err);
        });
      this.$store.dispatch("auth/setUser", null);
      this.$router.push("/login");
    },
  },
};
</script>