<template>
  <v-app dark>
    <div>
      <Success />
      <Loading />
    </div>

    <!-- <v-navigation-drawer v-model="drawer" app>
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
    </v-navigation-drawer> -->

    <!-- 左 -->
    <div>
      <v-card>
        <v-navigation-drawer fixed left permanent class="sidebar">
          <template v-slot:prepend>
            <!-- 現在このリンク先にいる時背景青くなるの直したい -->
            <!-- style="background: white !important"はきかず -->
            <!-- style="background: transparent !important"もきかず -->
            <v-list-item two-line :to="`/`">
              <v-list-item-content>
                <v-list-item-title class="logo">Advancey</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <!-- data()の方に書ければシンプルになるかも -->
            <!-- ログイン有無で切り替えたい -->
            <v-list-item :to="`/`">
              <v-list-item-content>
                <v-list-item-title>ホーム</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/users/${this.user.id}`">
              <v-list-item-content>
                <v-list-item-title>マイページ</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/topics`">
              <v-list-item-content>
                <v-list-item-title>掲示板</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/about`">
              <v-list-item-content>
                <v-list-item-title>サービス詳細</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/users`">
              <v-list-item-content>
                <v-list-item-title>ユーザー一覧</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/private_posts`">
              <v-list-item-content>
                <v-list-item-title>非公開メモ一覧</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-btn @click="logOut">ログアウト</v-btn>
            </v-list-item>
            <v-list-item :to="`/signup`">
              <v-list-item-content>
                <v-list-item-title>新規登録</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
      </v-card>
    </div>

    <!-- 右 -->
    <div>
      <v-card>
        <v-navigation-drawer fixed right permanent class="sidebar">
          <template v-slot:prepend>
            <!-- 現在このリンク先にいる時背景青くなるの直したい（この場合ユーザー詳細） -->
            <!-- style="background: white !important"はきかず -->
            <!-- style="background: transparent !important"もきかず -->
            <v-list-item two-line :to="`/users/${user.id}`">
              <v-list-item-avatar>
                <!-- アイコン設定がないとき→条件は後で追加 -->
                <img src="~assets/default-user-icon.png" />
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title>{{ user.name }}さん</v-list-item-title>
                <v-list-item-subtitle>としてログイン中</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <v-list-item v-for="item in items" :key="item.title">
              <v-list-item-content>
                <v-list-item-title>サイドバー</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-btn>投稿する</v-btn>
            </v-list-item>
            <v-list-item>
              <v-btn>質問する</v-btn>
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
      </v-card>
    </div>

    <div class="main">
      <!-- スマホ時だけドロワーメニュー追加したい -->
      <v-main>
        <v-container>
          <Nuxt />
        </v-container>
      </v-main>
      <v-footer app>
        <!-- フッターにもサービス詳細しっかり目に書きたい -->
        <!-- フッター表示されてない気がする -->
        <span>&copy; {{ new Date().getFullYear() }}</span>
      </v-footer>
    </div>
  </v-app>
</template>

<script>
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import firebase from "@/plugins/firebase";

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
            to: `/users/${this.user.id}`,
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
  methods: {
    async logOut() {
      await firebase
        .auth()
        .signOut()
        .catch((error) => {
          // errに書き換えたい
          console.log(error);
        });

      this.$store.dispatch("auth/setUser", null);
      this.$router.push("/login");
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
.main {
  width: 70%;
  max-width: 1200px;
  margin: 0 auto;
}
.sidebar {
  width: 15% !important;
}
header {
  width: 70%;
  margin: 0 auto;
}
</style>