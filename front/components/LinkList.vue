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
        <v-list-item-action>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title v-text="item.title" />
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
            icon: "mdi-home",
            title: "ホーム",
            to: "/",
          },
          {
            icon: "mdi-account",
            title: "マイページ",
            to: `/users/${this.user.id}`,
          },
          {
            icon: "mdi-chat-question",
            title: "質問する",
            to: "/topics",
          },
          {
            icon: "mdi-forum",
            title: "チャット",
            to: "/communities",
          },
          {
            icon: "mdi-calendar",
            title: "目標一覧",
            to: "/goals",
          },
          {
            icon: "mdi-account-group",
            title: "ユーザー一覧",
            to: "/users",
          },
          {
            icon: "mdi-shield-key",
            title: "非公開メモ",
            to: `/users/${this.user.id}/private_posts`,
          },
          {
            icon: "mdi-shield-key",
            title: "非公開目標",
            to: `/users/${this.user.id}/private_goals`,
          },
        ];
      } else {
        return [
          {
            icon: "mdi-account",
            title: "新規登録",
            to: "/signup",
          },
          {
            icon: "mdi-account",
            title: "ログイン",
            to: "/login",
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

.v-application--is-ltr .v-list-item__action:first-child,
.v-application--is-ltr .v-list-item__icon:first-child {
  margin-right: 5px !important;
}
</style>