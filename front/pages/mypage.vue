<template>
  <div>
    <div v-if="user">
      <h2 class="text-center">
        <span style="color: red; font-weight: normal; font-size: 20px"
          >ここにアイコン画像</span
        >{{ user.name }}さん
      </h2>
      <!-- 初期値設定出来なかったので飛ばした（dataに書いても出ず） -->
      <p>自己紹介：{{ user.profile }}</p>

      <!-- twitterリンクなど貼れるようにしたい（qiita見る） -->
      <!-- 自分のページだけで表示→マイページだから大丈夫だと思うが後ほど確認 -->
      <v-row justify="center">
        <v-dialog v-model="user_info_dialog" scrollable fullscreen hide-overlay>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="primary"
              dark
              v-bind="attrs"
              v-on="on"
              @click="openEditUserInfoDialog()"
            >
              ユーザー情報を編集
            </v-btn>
          </template>
          <v-card>
            <v-card-title>ユーザー情報編集</v-card-title>
            <v-card-actions>
              <v-btn
                color="blue darken-1"
                text
                @click="user_info_dialog = false"
              >
                戻る
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                @click="(user_info_dialog = false), updateUserInfo()"
              >
                保存する
              </v-btn>
            </v-card-actions>
            <v-card-text style="height: 300px">
              <form>
                <v-text-field
                  v-model="name"
                  :counter="10"
                  label="Name"
                  data-vv-name="name"
                  required
                ></v-text-field>
                <v-text-field
                  v-model="profile"
                  :counter="50"
                  label="自己紹介を入力してみましょう！"
                  data-vv-name="profile"
                ></v-text-field>
              </form>
            </v-card-text>
            <v-card-actions>
              <v-btn
                color="blue darken-1"
                text
                @click="user_info_dialog = false"
              >
                戻る
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                @click="(user_info_dialog = false), updateUserInfo()"
              >
                保存する
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-row>
      <p>フォロー中：</p>
      <p>フォロワー：</p>
      <!-- 編集画面で表示させる・マイページには出さない -->
      <!-- <p>email: {{ user.email }}</p> -->
    </div>
    <!-- 編集画面で表示させる・マイページには出さない -->
    <v-btn @click="logOut">ログアウト</v-btn>
    <!-- <v-btn @click="deleteUser">退会する</v-btn> -->
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      dialogm1: "", //これいる？
      user_info_dialog: false,
      user_profile_dialog: false,
      name: "",
      profile: "",
    };
  },
  mounted() {
    this.fetchUserProfile();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    user_params() {
      return {
        user: {
          name: this.name,
          profile: this.profile,
        },
      };
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
    fetchUserProfile() {
      const url = `/v1/users/${this.user.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
      });
    },
    openEditUserInfoDialog() {
      this.name = this.user.name;
      this.profile = this.user.profile;
    },
    updateUserInfo() {
      const url = `/v1/users/${this.user.id}`;
      axios
        .put(url, this.user_params)
        .then((res) => {
          // 編集はできるが、ダイアログ閉じても変わってないので対処必要
          // fetchUserProfile作ったがうまく行かず→vuexで管理してるのでまた別のことやる必要ありそう
          this.fetchUserProfile();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    deleteUser() {
      const user = firebase.auth().currentUser;
      user
        .delete()
        .then(() => {
          alert("User deleted.");
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
  fetch({ store, redirect }) {
    store.watch(
      (state) => state.auth.currentUser,
      (newUser, oldUser) => {
        if (!newUser) {
          return redirect("/login");
        }
      }
    );
  },
};
</script>

<style>
</style>
