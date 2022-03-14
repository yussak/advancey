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

    <div>
      <v-card>
        <v-navigation-drawer fixed left permanent class="sidebar">
          <template v-slot:prepend>
            <v-list-item two-line>
              <v-list-item-avatar>
                <img src="https://randomuser.me/api/portraits/women/81.jpg" />
              </v-list-item-avatar>

              <v-list-item-content>
                <v-list-item-title>Jane Smith</v-list-item-title>
                <v-list-item-subtitle>Logged In</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <v-list-item v-for="item in items" :key="item.title">
              <v-list-item-content>
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
      </v-card>
    </div>

    <div>
      <v-card>
        <v-navigation-drawer fixed right permanent class="sidebar">
          <template v-slot:prepend>
            <v-list-item two-line>
              <v-list-item-avatar>
                <img src="https://randomuser.me/api/portraits/women/81.jpg" />
              </v-list-item-avatar>

              <v-list-item-content>
                <v-list-item-title>Jane Smith</v-list-item-title>
                <v-list-item-subtitle>Logged In</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <v-list-item v-for="item in items" :key="item.title">
              <v-list-item-content>
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
      </v-card>
    </div>

    <div class="main">
      <header>
        <v-app-bar fixed app>
          <!-- スマホ時だけ表示したい -->
          <!-- 一時的に非表示 -->
          <!-- <v-app-bar-nav-icon @click.stop="drawer = !drawer" /> -->
          <v-row>
            <v-toolbar-title>
              <nuxt-link to="/" class="header_logo">Advancey</nuxt-link>
            </v-toolbar-title>
            <!-- ログイン有無で切り替えたい -->
            <div>
              <!-- <nuxt-link to="/about" class="header_link"
                >サービス詳細</nuxt-link
              >
              <nuxt-link to="/users" class="header_link"
                >ユーザー一覧</nuxt-link
              >
              <nuxt-link to="/topics" class="header_link">掲示板</nuxt-link> -->
              <v-btn>メモする</v-btn>
              <!-- ドロップダウン -->
              <v-menu offset-y>
                <template v-slot:activator="{ on, attrs }">
                  <v-btn color="transparent" dark v-bind="attrs" v-on="on">
                    <v-avatar>
                      <!-- アイコン設定がないとき→条件は後で追加 -->
                      <img
                        src="~assets/default-user-icon.png"
                        style="width: 45px; height: 45px"
                      />
                    </v-avatar>
                    <p style="color: black">{{ user.name }}</p>
                  </v-btn>
                </template>
                <v-list>
                  <v-list-item>
                    <v-list-item-title
                      ><nuxt-link to="/private_posts" class="header_link"
                        >非公開の投稿</nuxt-link
                      ></v-list-item-title
                    >
                  </v-list-item>
                  <v-list-item>
                    <!-- マイページ＝ユーザー詳細ページにした -->
                    <v-list-item-title
                      ><nuxt-link
                        :to="`/users/${this.user.id}`"
                        class="header_link"
                        >マイページ</nuxt-link
                      ></v-list-item-title
                    >
                  </v-list-item>
                  <v-list-item>
                    <v-list-item-title
                      ><v-btn @click="logOut"
                        >ログアウト</v-btn
                      ></v-list-item-title
                    >
                  </v-list-item>
                </v-list>
              </v-menu>
            </div>
          </v-row>
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
    </div>
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