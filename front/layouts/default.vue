<template>
  <v-app>
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

    <!-- スマホ時だけドロワーメニュー追加したい -->
    <!-- ヘッダー -->
    <v-app-bar app>
      <div class="header_wrapper">
        <div class="header_left">
          <nuxt-link :to="`/`" class="logo" v-if="user"> Advancey </nuxt-link>
          <div class="logo" v-else>Advancey</div>
        </div>
        <div class="header_right">
          <div style="display: flex" v-if="user">
            <v-avatar>
              <!-- アイコン表示されない→編集でVuex更新してないからかも -->
              <img
                v-if="user.image_url"
                :src="user.image_url"
                alt="ユーザーアイコン"
              />
              <img
                v-else
                src="~assets/default-user-icon.png"
                alt="ユーザーアイコン"
              />
              <!-- コミュニティでmessage.user_idとしたときと違う値が出る… -->
              <!-- {{ user.id }} -->
            </v-avatar>
            <p class="bold-text">
              {{ user.name }}
            </p>
          </div>
        </div>
      </div>
    </v-app-bar>
    <v-main>
      <v-container class="main">
        <v-row>
          <!-- サイドバー -->
          <v-col cols="3">
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
                <v-dialog v-model="adminDialog">
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn
                      color="orange"
                      dark
                      v-bind="attrs"
                      v-on="on"
                      @click="adminDialog = true"
                    >
                      管理者モード
                    </v-btn>
                  </template>
                  <!-- ダイアログ中身 -->
                  <v-card>
                    <v-card-title>管理者モード</v-card-title>
                    <v-card-actions>
                      <v-btn
                        color="blue darken-1"
                        text
                        @click="adminDialog = false"
                      >
                        キャンセル
                      </v-btn>
                    </v-card-actions>
                    <v-card-text style="height: 300px">
                      <form>
                        <v-text-field
                          v-model="profile"
                          label="profile"
                          required
                        ></v-text-field>
                        <p v-if="error" class="errors">{{ error }}</p>
                      </form>
                    </v-card-text>
                    <v-card-actions>
                      <v-btn color="blue darken-1" text @click="changeAdmin">
                        送信
                      </v-btn>
                      <v-btn
                        color="blue darken-1"
                        text
                        @click="adminDialog = false"
                      >
                        キャンセル
                      </v-btn>
                    </v-card-actions>
                  </v-card>
                </v-dialog>
              </v-list-item>
              <v-list-item v-if="user">
                <v-btn @click="logOut">ログアウト</v-btn>
              </v-list-item>
            </v-list>
          </v-col>
          <!-- メイン -->
          <v-col cols="9">
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
import axios from "@/plugins/axios";
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import firebase from "@/plugins/firebase";
import GuestLoginButton from "@/components/GuestLoginButton";
import DeleteUserDialog from "@/components/DeleteUserDialog";

export default {
  data() {
    return {
      drawer: false,
      title: "Advancey",
      show1: false,
      adminDialog: false,
      profile: "",
      error: null, //adminの方でエラー表示しなければ消す
    };
  },
  components: {
    Loading,
    Success,
    GuestLoginButton,
    DeleteUserDialog,
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
    async changeAdmin() {
      if (this.profile === "admin") {
        axios
          .put(`/v1/users/${this.user.id}`, {
            user: {
              admin: true,
            },
          })
          .then(() => {
            alert("管理者になりました！");
            this.adminDialog = false;
            this.profile = "";
            //送信したときに反映させたい→違うファイルの分を変更させたい→watch?
          })
          .catch((err) => {
            console.log(err);
          });
      } else {
        axios
          .put(`/v1/users/${this.user.id}`, {
            user: {
              admin: false,
            },
          })
          .then(() => {
            alert("通常ユーザーになりました");
            this.adminDialog = false;
            this.profile = "";
            //送信したときに反映させたい→違うファイルの分を変更させたい→watch?
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
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
  /* background: orange; */
}
.bold-text {
  font-weight: bold;
}
</style>