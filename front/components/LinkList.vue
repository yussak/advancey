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
import GuestLoginButton from "@/components/GuestLoginButton";
import DeleteUserDialog from "@/components/DeleteUserDialog";
import ChangeAdminDialog from "@/components/ChangeAdminDialog";

export default {
  components: {
    GuestLoginButton,
    DeleteUserDialog,
    ChangeAdminDialog,
  },
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
            title: "質問掲示板",
            to: "/topics",
          },
          {
            title: "コミュニティ一覧",
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
            // middlewareで直接アクセス出来ないよう制限した
            // が、自分のページでもリロードすると見れないので要修正
            to: `/users/${this.user.id}/private_posts`,
          },
          {
            title: "目標一覧",
            to: "/goals",
          },
          {
            title: "運営からのお知らせ",
            to: "/news",
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

<style>
/* カレントページでも色を変えない */
.theme--light.v-btn--active:hover::before,
.theme--light.v-btn--active::before {
  background: none !important;
}
.theme--light.v-list-item--active:hover::before,
.theme--light.v-list-item--active::before {
  background: none !important;
}
</style>