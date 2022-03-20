<template>
  <div>
    <h1 v-if="this.user.id === this.currentUser.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <v-avatar>
      <!-- アイコン設定がないとき→条件は後で追加 -->
      <img
        src="~assets/default-user-icon.png"
        style="width: 45px; height: 45px"
      />
    </v-avatar>
    <span style="font-weight: bold">{{ user.name }}</span
    >さん
    <p v-if="user.profile">自己紹介：{{ user.profile }}</p>

    <!-- ユーザー編集ダイアログ -->
    <!-- コンポーネントにしたい -->
    <!-- 自分のページ以外で表示する -->
    <!-- たまに動かない（要修正）けど基本これでフォロー・解除出来る -->
    <v-row v-if="$store.state.auth.currentUser.id !== user.id">
      <v-col>
        <v-btn v-if="!isFollowed" color="blue" @click="follow(user)"
          >フォローする</v-btn
        >
        <v-btn v-if="isFollowed" @click="unfollow(user)">フォロー中</v-btn>
      </v-col>
    </v-row>

    <!-- フォロー・フォロワー一覧ダイアログ -->
    <!-- クリックした方のタブを開くようにしたい -->
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
                          <!-- アイコン設定がないとき→条件は後で追加 -->
                          <img
                            src="~assets/default-user-icon.png"
                            style="width: 45px; height: 45px"
                          />
                        </v-avatar>
                        <v-card-text>
                          <v-row>
                            <p>
                              <span style="font-weight: bold"
                                >{{ user.name }}さん</span
                              >
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
                              <span style="font-weight: bold"
                                >{{ user.name }}さん</span
                              >
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

    <!-- 自分のページの時だけ表示する -->
    <v-row v-if="$store.state.auth.currentUser.id === user.id" justify="center">
      <v-dialog v-model="user_info_dialog" scrollable fullscreen hide-overlay>
        <!-- ダイアログボタン -->
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
        <!-- ダイアログ中身 -->
        <v-card>
          <v-card-title>ユーザー情報編集</v-card-title>
          <v-card-actions>
            <v-btn color="blue darken-1" text @click="user_info_dialog = false">
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
            <v-btn color="blue darken-1" text @click="user_info_dialog = false">
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

    <v-row>
      <v-col>
        <!-- ユーザーページでは全部の投稿は表示しないよう変更したい -->
        <PostList :posts="user.posts" />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import PostList from "@/components/PostList";
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      //自分のページなら「マイページ」にしたい
      title: "ユーザー詳細",
    };
  },
  components: {
    PostList,
  },
  data() {
    return {
      user: [],
      posts: [],
      user_info_dialog: false,
      user_follow_dialog: false,
      name: "",
      profile: "",
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
  },
  computed: {
    currentUser() {
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
    fetchUserInfo() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
      });
    },
    openUserFollowerListDialog() {},
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
          // vuexで管理してるのでまた別のことやる必要ありそう
          this.fetchUserInfo();
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
  },
};
</script>