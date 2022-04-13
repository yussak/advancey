<template>
  <div>
    <!-- 条件変える（どっちも同じで明らかにおかしいので） -->
    <h1 v-if="this.user.id === this.user.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <v-avatar>
      <img v-if="user.image_url" :src="user.image_url" alt="ユーザーアイコン" />
      <img v-else src="~assets/default-user-icon.png" alt="ユーザーアイコン" />
    </v-avatar>
    <p class="bold-text">
      {{ user.name }}
    </p>
    <p v-if="user.profile">自己紹介：{{ user.profile }}</p>
    <nuxt-link :to="`/users`">ユーザー一覧に戻る</nuxt-link>

    <!-- コンポーネントにしたい -->
    <!-- 自分のページ以外で表示する -->
    <!-- たまに動かない（要修正）けど基本これでフォロー・解除出来る -->
    <!-- <v-row v-if="$store.state.auth.currentUser.id !== user.id">
      <v-col>
        <v-btn v-if="!isFollowed" color="blue" @click="follow(user)"
          >フォローする</v-btn
        >
        <v-btn v-if="isFollowed" @click="unfollow(user)">フォロー中</v-btn>
      </v-col>
    </v-row> -->

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
            <!-- フォロワー: {{ followerCount }}人 フォロー中: {{ followingCount }}人 -->
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

    <!-- ユーザー編集ダイアログ -->
    <!-- 自分のページの時だけ表示する→v-ifをコンポからこっちに持ってくる -->
    <EditUserDialog @submitEditName="editUserName" />
    <!-- <EditUserDialog @submit="updateUserInfo" /> -->

    <v-row>
      <v-col>
        <!-- ユーザーページでは全部の投稿は表示しないよう変更したい -->
        <!-- <PostList /> -->
        <PostList :posts="posts" />
        <!-- <PostList :posts="user.posts" /> -->
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
      //自分のページなら「マイページ」にしたい
      title: "ユーザー詳細",
    };
  },
  components: {
    PostList,
    EditUserDialog,
  },
  data() {
    return {
      // user: [],
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
    // this.fetchUserInfo();
    // this.getFollowRelationships();
    // this.getFollowers();
    // this.getFollowing();
    this.fetchPostList();
  },
  computed: {
    // 現在のページのユーザーとcurrentUserは区別
    // 自分じゃないページでcurrentUser.nameとかはしない
    // 基本user.nameでいいと思う
    // いやこれをuserにしたら他のユーザーページ開いてもcurrentのぶんがでてしまう→ここはcurrentUserで、
    // 基本はuser.nameにする（user=currentで両方できる）
    // あとdataにuser:[]も追加する
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async editUserName(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      // this.$store.dispatch("auth/setUser", data).then(() => {
      //   alert("ok");
      // });
      this.$store.dispatch("auth/setUser", data);
    },
    fetchPostList() {
      const url = `/v1/posts`;
      axios.get(url).then((res) => {
        this.posts = res.data;
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
    getFollowRelationships() {
      axios
        .get(`/v1/relationships`, {
          params: {
            follower_id: this.currentUser.id,
            followed_id: this.user.id,
          },
        })
        .then((res) => {
          if (!res.data) {
            this.isFollowed = false;
          } else {
            this.isFollowed = true;
          }
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
          this.getFollowRelationships();
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
          this.getFollowRelationships();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // 自分以外のユーザーページで情報取得に必要な気がする
    // fetchUserInfo() {
    //   const url = `/v1/users/${this.$route.params.id}`;
    //   axios.get(url).then((res) => {
    //     this.user = res.data;
    //   });
    // },
    // @click=dialog name=trueで書き換えればこれ消せる（default.vue参考）
    openUserFollowerListDialog() {},
    // async updateUserInfo() {
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