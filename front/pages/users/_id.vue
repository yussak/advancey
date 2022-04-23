<template>
  <div>
    <h1 v-if="user.id === currentUser.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <UserCard :user="user" />
    <p v-if="user.profile">自己紹介：{{ user.profile }}</p>
    <nuxt-link :to="`/users`">ユーザー一覧に戻る</nuxt-link>

    <!-- コンポーネントにしたい -->
    <!-- 自分のページ以外で表示 -->
    <v-row v-if="user.id !== currentUser.id">
      <v-col>
        <v-btn v-if="!isFollowed" color="blue" @click="follow(user)"
          >フォローする</v-btn
        >
        <!-- フォローしてないのにしてることになるの修正したい -->
        <v-btn v-if="isFollowed" @click="unfollow(user)">フォロー中</v-btn>
      </v-col>
    </v-row>

    <!-- フォロー・フォロワー一覧ダイアログ -->
    <!-- クリックした方のタブ]を開くようにしたい -->
    <v-row>
      <v-dialog v-model="user_follow_dialog" scrollable fullscreen hide-overlay>
        <!-- ダイアログボタン -->
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            text
            v-bind="attrs"
            v-on="on"
            class="test"
            @click="openUserFollowerListDialog()"
          >
            フォロワー: {{ followerCount }}人 フォロー中: {{ followingCount }}人
          </v-btn>
        </template>
        <!-- ダイアログ中身→どっちも１つで表示してタブで切り替えたい -->
        <v-card>
          <v-card-actions>
            <v-btn
              color="blue darken-1"
              text
              @click="user_follow_dialog = false"
            >
              戻る
            </v-btn>
          </v-card-actions>
          <v-card-text style="height: 300px">
            <v-tabs>
              <v-tab v-for="title in titles" :key="title.id">
                {{ title.name }}
              </v-tab>
              <v-tab-item>
                <v-list>
                  <v-list-item v-if="!followers.length"
                    >フォロワーはいません</v-list-item
                  >
                  <v-list-item v-else v-for="user in followers" :key="user.id">
                    <nuxt-link
                      :to="`/users/${user.id}`"
                      style="text-decoration: none; color: black"
                      class="user-link"
                    >
                      <v-card-actions>
                        <v-avatar>
                          <!-- アイコン設定がないとき→条件は後で追加（詳細ページとは違う条件が必要そう） -->
                          <img src="~assets/default-user-icon.png" />
                        </v-avatar>
                        <v-card-text>
                          <v-row>
                            <p>
                              <span class="bold-text">{{ user.name }}さん</span>
                            </p>
                          </v-row>
                        </v-card-text>
                      </v-card-actions>
                    </nuxt-link>
                  </v-list-item>
                </v-list>
              </v-tab-item>
              <v-tab-item>
                <v-list>
                  <v-list-item v-if="!following.length"
                    >誰もフォローしていません</v-list-item
                  >
                  <v-list-item v-else v-for="user in following" :key="user.id">
                    <nuxt-link
                      :to="`/users/${user.id}`"
                      style="text-decoration: none; color: black"
                      class="user-link"
                    >
                      <v-card-actions>
                        <v-avatar>
                          <!-- アイコン設定がないとき→条件は後で追加 -->
                          <img
                            src="~assets/default-user-icon.png"
                            style="width: 45px; height: 45px"
                          />
                        </v-avatar>
                        <v-card-text>
                          <v-row>
                            <p>
                              <span class="bold-text">{{ user.name }}さん</span>
                            </p>
                          </v-row>
                        </v-card-text>
                      </v-card-actions>
                    </nuxt-link>
                  </v-list-item>
                </v-list>
              </v-tab-item>
            </v-tabs>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>

    <!-- 右辺、ぜんぶeditUserに統一できるはず(画像以外) -->
    <!-- refsは親から子コンポーネントのモーダルを閉じるため -->
    <!-- ユーザー編集ダイアログ 自分のページだけ表示 -->
    <EditUserDialog
      v-if="user.id === currentUser.id"
      ref="editUserDialog"
      @submitEditName="editUserName"
      @submitEditProfile="editUserProfile"
      @submitEditImage="editUserImage"
    />
    <v-row>
      <v-col>
        <!-- ユーザーページでは[全部の投稿]は表示しないよう変更したい -->
        <PostList :posts="posts" />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import PostList from "@/components/PostList";
import EditUserDialog from "@/components/EditUserDialog";

export default {
  head() {
    return {
      title: "ユーザー詳細",
    };
  },
  components: {
    PostList,
    EditUserDialog,
  },
  data() {
    return {
      user: [], // 自分以外のページで必要
      posts: [],
      user_follow_dialog: false,
      followers: [],
      following: [],
      isFollowed: false,
      followerCount: 0,
      followingCount: 0,
      titles: [{ name: "フォロワー" }, { name: "フォロー中" }],
    };
  },
  mounted() {
    this.fetchUserInfo();
    this.getFollowRelationships();
    this.getFollowers();
    this.getFollowing();
    this.fetchPostList();
  },
  computed: {
    // 現在のページのuserとcurrentUserを区別
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    // 自分以外のユーザーページで情報取得
    fetchUserInfo() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
      });
    },
    getFollowRelationships() {
      axios
        .get(`/v1/relationships`, {
          params: {
            follower_id: this.currentUser.id,
            followed_id: this.user.id,
          },
        })
        .then((res) => {
          console.log(res);
          res.data.forEach((r) => {
            console.log(this.user.id);
            if (
              // r.follower_id === this.currentUser.id &&
              r.follower_id === 3 &&
              r.followed_id === 1
              // r.followed_id === this.user.id
            ) {
              this.isFollowed = true;
            } else {
              this.isFollowed = false;
            }
          });
        });
    },
    getFollowers() {
      axios.get(`/v1/users/${this.$route.params.id}/followers`).then((res) => {
        this.followers = res.data;
        this.followerCount = this.followers.length;
      });
    },
    getFollowing() {
      axios.get(`/v1/users/${this.$route.params.id}/following`).then((res) => {
        this.following = res.data;
        this.followingCount = this.following.length;
      });
    },
    follow(user) {
      axios
        .post(`/v1/relationships`, {
          follower_id: this.currentUser.id,
          followed_id: user.id,
        })
        .then(() => {
          this.isFollowed = true;
          // this.getFollowRelationships();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    unfollow(user) {
      axios
        .delete(`/v1/relationships/${this.$route.params.id}`, {
          params: {
            follower_id: this.currentUser.id,
            followed_id: user.id,
          },
        })
        .then(() => {
          this.isFollowed = false;
          // this.getFollowRelationships();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // @click=dialog name=trueで書き換えればこれ消せる（default.vue参考）
    // いや中身表示のためいるかも
    openUserFollowerListDialog() {},
    async editUserName(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      this.$store.dispatch("auth/setUser", data);
    },
    async editUserProfile(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      this.$store.dispatch("auth/setUser", data);
    },
    async editUserImage(user) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user,
        config
      );
      this.$store.dispatch("auth/setUser", data);
      this.image = [];
      // 親から子のモーダルを閉じる
      this.$refs.editUserDialog.changeUserImageDialog = false;
    },
    fetchPostList() {
      const url = `/v1/posts`;
      axios.get(url).then((res) => {
        this.posts = res.data;
      });
    },
    async updateUserInfo(user) {
      const test = await firebase.auth().currentUser; //VuexのcuUじゃなくfirebase側の？
      // test.updateEmail(this.email);
      // const { data } = axios.put(`/v1/users/${this.$route.params.id}`, {
      //   user: { email: this.email },
      // });
      // this.$store.dispatch("auth/setUser", data).then(() => {
      //   alert("ok");
      // });
      // test
      //   .updateEmail(this.email)
      //   .then(() => {
      //     const { data } = axios.put(`/v1/users/${this.$route.params.id}`, {
      //       // user: { email: this.email },
      //       user,
      //     });
      //     this.$store.dispatch("auth/setUser", data).then(() => {
      //       alert("ok");
      //     });
      //   })
      //   .catch((error) => {
      //     this.error = ((code) => {
      //       switch (code) {
      //         case "auth/email-already-in-use":
      //           return "既にそのメールアドレスは使われています";
      //         case "auth/wrong-password":
      //           return "※パスワードが正しくありません";
      //         case "auth/weak-password":
      //           return "※パスワードは最低６文字以上にしてください";
      //         default:
      //           return "※メールアドレスとパスワードをご確認ください";
      //       }
      //     })(error.code);
      //   });

      // const config = {
      //   headers: {
      //     "content-type": "multipart/form-data",
      //   },
      // };
      // const { data } = await axios.put(
      //   `/v1/users/${this.$route.params.id}`,
      //   user,
      //   config
      // );
      // this.$store.dispatch("auth/setUser", data);
    },
  },
};
</script>