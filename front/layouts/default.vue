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
            <v-list-item two-line :to="`/`">
              <v-list-item-content>
                <v-list-item-title class="logo">Advancey</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <!-- data()の方に書ければシンプルになるかも -->
            <v-list-item :to="`/`" v-if="user">
              <v-list-item-content>
                <v-list-item-title>ホーム</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/users/${this.user.id}`" v-if="user">
              <v-list-item-content>
                <v-list-item-title>マイページ</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/topics`">
              <v-list-item-content>
                <v-list-item-title>掲示板</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/communities`">
              <v-list-item-content>
                <v-list-item-title>コミュニティ</v-list-item-title>
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
            <v-list-item :to="`/private_posts`" v-if="user">
              <v-list-item-content>
                <v-list-item-title>非公開メモ一覧</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item v-if="user">
              <v-btn @click="logOut">ログアウト</v-btn>
            </v-list-item>
            <v-list-item :to="`/login`" v-if="!user">
              <v-list-item-content>
                <v-list-item-title>ログイン</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item :to="`/signup`" v-if="!user">
              <v-list-item-content>
                <v-list-item-title>新規登録</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item v-if="!user">
              <v-list-item-content>
                <GuestLoginButton />
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
            <v-list-item two-line :to="`/users/${user.id}`" v-if="user">
              <v-list-item-avatar>
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
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title>{{ user.name }}さん</v-list-item-title>
                <v-list-item-subtitle>としてログイン中</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </template>

          <v-divider></v-divider>

          <v-list dense>
            <v-list-item>
              <v-list-item-content>
                <v-list-item-title>サイドバー</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <!-- フォームにオートフォーカスしたい -->
              <v-btn :to="`/`" v-if="user">投稿する</v-btn>
            </v-list-item>
            <v-list-item>
              <!-- フォームにオートフォーカスしたい -->
              <v-btn :to="`/topics`" v-if="user">質問する</v-btn>
            </v-list-item>
            <v-list-item v-if="user">
              <v-btn @click="deleteUser">退会する</v-btn>
            </v-list-item>

            <v-list-item v-if="user">
              <v-dialog v-model="reLoginDialog">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn
                    color="primary"
                    dark
                    v-bind="attrs"
                    v-on="on"
                    @click="ReLoginDialog = true"
                  >
                    再認証
                  </v-btn>
                </template>
                <!-- ダイアログ中身 -->
                <v-card>
                  <v-card-title>再認証</v-card-title>
                  <v-card-actions>
                    <v-btn
                      color="blue darken-1"
                      text
                      @click="reLoginDialog = false"
                    >
                      キャンセル
                    </v-btn>
                  </v-card-actions>
                  <v-card-text style="height: 300px">
                    <form>
                      <v-text-field
                        v-model="email"
                        label="メールアドレス"
                        required
                      ></v-text-field>
                      <v-text-field
                        v-model="password"
                        label="現在のパスワード"
                        required
                      ></v-text-field>
                      <p v-if="error" class="errors">{{ error }}</p>
                    </form>
                  </v-card-text>
                  <v-card-actions>
                    <v-btn color="blue darken-1" text @click="reLogin">
                      再認証する
                    </v-btn>
                    <v-btn
                      color="blue darken-1"
                      text
                      @click="reLoginDialog = false"
                    >
                      キャンセル
                    </v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
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
        <!-- フッター表示されてない気がする -->
        <span>&copy; {{ new Date().getFullYear() }}</span>
      </v-footer>
    </div>
  </v-app>
</template>

<script>
import axios from "@/plugins/axios";
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import firebase from "@/plugins/firebase";
import GuestLoginButton from "@/components/GuestLoginButton";

export default {
  data() {
    return {
      drawer: false,
      title: "Advancey",
      show1: false,
      email: "",
      password: "",
      error: null,
      reLoginDialog: false,
      adminDialog: false,
      profile: "",
    };
  },
  components: {
    Loading,
    Success,
    GuestLoginButton,
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async reLogin() {
      await firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .catch((error) => {
          switch (error.code) {
            case "auth/user-not-found":
              this.error = "メールアドレスが間違っています";
              return;
            case "auth/wrong-password":
              this.error = "※パスワードが正しくありません";
              return;
            default:
              this.error = "※メールアドレスとパスワードをご確認ください";
              return;
          }
        });

      if (this.error === null) {
        (this.reLoginDialog = false),
          (this.email = ""),
          (this.password = ""),
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "ログインしました",
          });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 2000);
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
    async deleteUser() {
      const res = confirm("削除すると戻せません。よろしいですか？");
      const user = await firebase.auth().currentUser;

      if (res) {
        user.delete();
        axios.delete(`/v1/users/${this.user.id}`).then(() => {
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "アカウントを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
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
</style>