<template>
  <v-app>
    <div>
      <Success />
      <Loading />
    </div>

    <!-- バーガー中身 -->
    <v-navigation-drawer
      v-model="drawer"
      :clipped="clipped"
      fixed
      app
      disable-resize-watcher
    >
      <LinkList />
    </v-navigation-drawer>

    <v-app-bar :clipped-left="clipped" fixed app>
      <!-- ヘッダー コンポ化したい-->
      <div class="header_wrapper">
        <div class="header_left">
          <!-- バーガーアイコン -->
          <v-app-bar-nav-icon
            @click.stop="drawer = !drawer"
            class="d-md-none"
          />
          <!-- sm以下で非表示（vuetifyのクラス） -->
          <nuxt-link :to="`/`" class="logo hidden-sm-and-down" v-if="user">
            Advancey
          </nuxt-link>
          <div class="logo hidden-sm-and-down" v-else>Advancey</div>
        </div>
        <div class="header_right">
          <UserCard v-if="user" :user="user" />
        </div>
      </div>
    </v-app-bar>
    <v-main>
      <v-container class="main">
        <v-row>
          <!-- サイドバー -->
          <v-col class="hidden-sm-and-down" cols="2">
            <LinkList />
          </v-col>
          <!-- メイン -->
          <v-col cols="10">
            <Nuxt />
          </v-col>
        </v-row>
      </v-container>
    </v-main>
    <v-footer app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import LinkList from "@/components/LinkList";
import UserCard from "@/components/UserCard";

export default {
  components: {
    Loading,
    Success,
    LinkList,
    UserCard,
  },
  data() {
    return {
      drawer: false,
      title: "Advancey",
      clipped: false,
    };
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
};
</script>

<style>
.logo {
  color: black !important;
  font-size: 30px !important;
  text-decoration: none !important;
}
.errors {
  color: red;
  margin-top: 20px;
}
/* カレントページでも色を変えない */
.theme--light.v-btn--active:hover::before,
.theme--light.v-btn--active::before {
  background: none !important;
}
.theme--light.v-list-item--active:hover::before,
.theme--light.v-list-item--active::before {
  background: none !important;
}
.main {
  /* 幅は仮 */
  max-width: 1200px !important;
}
.header_wrapper {
  display: flex;
  justify-content: space-between;
  max-width: 1500px;
  width: 90%;
  margin: 0 auto;
}
.bold-text {
  font-weight: bold;
}
</style>