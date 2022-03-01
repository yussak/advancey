<template>
  <v-app dark>
    <div>
      <Success />
      <Loading />
    </div>

    <v-navigation-drawer v-model="drawer" app>
      <!-- <v-navigation-drawer v-model="drawer" :clipped="clipped" app> -->
      <v-list>
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
      </v-list>
    </v-navigation-drawer>
    <header>
      <!-- undefined clippedと出てるので後で消す -->
      <v-app-bar fixed app>
        <!-- <v-app-bar :clipped-left="clipped" fixed app> -->
        <!-- スマホ時だけ表示したい -->
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
        <v-toolbar-title>
          <nuxt-link to="/" class="header_logo">Advancey</nuxt-link>
        </v-toolbar-title>
        <!-- ログイン有無で切り替えもしたい -->
        <!-- ドロップダウン追加して、そこにログアウトなど表示したい -->
        <!-- CSSで書いたがVuetifyで整えたいので後で探す -->
        <nuxt-link to="/mypage" class="header_link">マイページ</nuxt-link>
        <nuxt-link to="/about" class="header_link">サービス詳細</nuxt-link>
        <nuxt-link to="/users" class="header_link">ユーザー一覧</nuxt-link>
        <nuxt-link to="/topics" class="header_link">掲示板</nuxt-link>
        <nuxt-link to="/private_posts" class="header_link"
          >非公開の投稿</nuxt-link
        >
        <v-btn>投稿ボタン</v-btn>
        <v-btn>質問ボタン</v-btn>
        <v-btn>目標ボタン</v-btn>
      </v-app-bar>
    </header>

    <v-main>
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
    <v-footer app>
      <!-- フッターにもサービス詳細しっかり目に書きたい -->
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import Loading from "@/components/Loading";
import Success from "@/components/Success";
export default {
  data() {
    return {
      drawer: false,
      title: "Advancey",
    };
  },
  components: {
    Loading,
    Success,
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    items() {
      // 一旦すべてログイン後の方に書いて後で分ける
      if (this.user) {
        return [
          {
            title: "トップページ",
            to: "/",
          },
          {
            title: "マイページ",
            to: "/mypage",
          },
          {
            title: "サービス詳細",
            to: "/about",
          },
          // ユーザー一覧
          // if文の外にかいてもうまく行かないのでif else両方に書いた
          {
            title: "ユーザー一覧",
            to: "/users",
          },
          // 掲示板
          // if文の外にかいてもうまく行かないのでif else両方に書いた
          {
            title: "掲示板",
            to: "/topics",
          },
        ];
      } else {
        return [
          {
            title: "LOGIN",
            to: "/login",
          },
          {
            title: "SIGNUP",
            to: "/signup",
          },
          // if文の外にかいてもうまく行かないのでif else両方に書いた
          {
            title: "ABOUT",
            to: "/about",
          },
          // ユーザー一覧
          // if文の外にかいてもうまく行かないのでif else両方に書いた
          {
            title: "ユーザー一覧",
            to: "/users",
          },
        ];
      }
    },
  },
};
</script>
<style>
.header_logo {
  color: black !important;
  font-size: 30px;
  text-decoration: none !important;
}
.header_link {
  color: black !important;
  margin-left: 20px;
  text-decoration: none;
}
</style>