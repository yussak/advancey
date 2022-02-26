<template>
  <v-app dark>
    <div>
      <Success />
      <Loading />
    </div>

    <v-navigation-drawer v-model="drawer" :clipped="clipped" app>
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
    <v-app-bar :clipped-left="clipped" fixed app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <!-- 後でまとめて下線と色調整 -->
      <nuxt-link to="/">
        <h2>Advancey</h2>
      </nuxt-link>
      <nuxt-link to="/mypage">マイページ</nuxt-link>
      <nuxt-link to="/about">サービス詳細</nuxt-link>
      <nuxt-link to="/users">ユーザー一覧</nuxt-link>
      <nuxt-link to="/topics">掲示板</nuxt-link>
    </v-app-bar>
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
