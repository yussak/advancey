<template>
  <div>
    <h1 v-if="currentUser.id === user.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <v-card class="mb-4">
      <v-card-actions>
        <p v-if="currentUser.id === user.id" class="d-flex align-center">
          <UserCard :user="currentUser" />
          <span v-if="currentUser.admin" class="blue--text font-weight-bold"
            >admin</span
          >
        </p>
        <span v-else class="d-flex align-center">
          <UserCard :user="user" />
          <span v-if="user.admin" class="blue--text font-weight-bold"
            >admin</span
          >
        </span>
        <v-spacer></v-spacer>
        <EditUserDialog
          v-if="currentUser.id === user.id"
          ref="editUserDialog"
          @submitEditName="editUser"
          @submitEditProfile="editUser"
          @submitEditImage="editUserImage"
          @submitEditEmail="editUserEmail"
        />
      </v-card-actions>
      <v-card-text v-if="currentUser.id === user.id && currentUser.profile">{{
        currentUser.profile
      }}</v-card-text>
      <v-card-text v-else-if="currentUser.id !== user.id && user.profile">{{
        user.profile
      }}</v-card-text>

      <v-card-actions v-if="currentUser.id !== user.id">
        <v-btn v-if="isFollowed" @click="unfollow">フォロー中</v-btn>
        <v-btn v-else @click="follow" class="blue">フォローする</v-btn>
      </v-card-actions>
      <v-card-text>
        <span v-if="user.following">
          {{ user.following.length }} フォロー中
        </span>
        <span v-if="user.followers">
          {{ user.followers.length }} フォロワー
        </span>
      </v-card-text>
      <span v-if="user.created_at">
        <v-icon>mdi-calendar</v-icon>
        {{
          $dateFns.format(new Date(user.created_at), "yyyy年MM月")
        }}からAdvanceyを利用しています
      </span>
      <v-card-actions>
        <v-icon @click="$router.back()"
          >mdi-arrow-left-bottom</v-icon
        ></v-card-actions
      >
    </v-card>
    <AddPostDialog
      v-if="currentUser.id === user.id"
      @submitPost="addPost"
      class="text-center my-4"
    />
    <UserPageTabList
      :posts="posts"
      :doing_posts="doing_posts"
      :want_posts="want_posts"
      :done_posts="done_posts"
      :master_posts="master_posts"
      :topics="topics"
      :unsolved_topics="unsolved_topics"
      :solved_topics="solved_topics"
      :goals="goals"
      :achieved_goals="achieved_goals"
      :unachieved_goals="unachieved_goals"
      @submitDeletePost="deletePost"
      @submitDeleteTopic="deleteTopic"
      @submitDeleteGoal="deleteGoal"
    />
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import UserPageTabList from "@/components/UserPageTabList";
import EditUserDialog from "@/components/EditUserDialog";

export default {
  head() {
    return {
      title: "ユーザー詳細",
    };
  },
  components: {
    UserPageTabList,
    EditUserDialog,
  },
  data() {
    return {
      user: [], // 自分以外のページで必要
      posts: [],
      doing_posts: [],
      want_posts: [],
      done_posts: [],
      master_posts: [],
      topics: [],
      unsolved_topics: [],
      solved_topics: [],
      goals: [],
      achieved_goals: [],
      unachieved_goals: [],
      isFollowed: false,
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
    followerCount() {
      return this.followers.length;
    },
  },
  mounted() {
    this.fetchUserObjects();
    this.getFollowRelationships();
  },
  methods: {
    // 事前準備
    fetchUserObjects() {
      axios
        .get(`/v1/users/${this.$route.params.id}`)
        .then((res) => {
          this.user = res.data.user;
          this.posts = res.data.posts;
          this.doing_posts = res.data.doing_posts;
          this.want_posts = res.data.want_posts;
          this.done_posts = res.data.done_posts;
          this.master_posts = res.data.master_posts;
          this.topics = res.data.topics;
          this.unsolved_topics = res.data.unsolved_topics;
          this.solved_topics = res.data.solved_topics;
          this.goals = res.data.goals;
          this.unachieved_goals = res.data.unachieved_goals;
          this.achieved_goals = res.data.achieved_goals;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchUser() {
      axios
        .get(`/v1/users/${this.$route.params.id}`)
        .then((res) => {
          this.user = res.data.user;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // ユーザー
    getFollowRelationships() {
      axios.get(`/v1/users/${this.$route.params.id}`).then((res) => {
        res.data.user.followers.forEach((follower) => {
          if (
            Object.values(follower).some(
              (follower_id) => follower_id === this.currentUser.id
            )
          ) {
            this.isFollowed = true;
          } else {
            this.isFollowed = false;
          }
        });
      });
    },
    follow() {
      axios.post(`v1/relationships`, {
        follower_id: this.currentUser.id,
        followed_id: this.user.id,
      });
      axios.get(`v1/users/${this.user.id}`).then(() => {
        this.isFollowed = true;
      });
    },
    unfollow() {
      axios.delete(`v1/relationships/${this.$route.params.id}`, {
        params: {
          follower_id: this.currentUser.id,
          followed_id: this.user.id,
        },
      });
      axios.get(`v1/users/${this.user.id}`).then(() => {
        this.isFollowed = false;
      });
    },

    async editUser(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      this.$store.dispatch("auth/setUser", data);
    },
    async editUserEmail(user) {
      const fbUser = await firebase.auth().currentUser;
      fbUser.updateEmail(user.get("user[email]"));
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
      this.$refs.editUserDialog.changeUserImageDialog = false;
    },
    // メモ
    fetchPostList() {
      axios
        // 連続して投稿できない→posts#indexには出来てるがusers#showにできてない
        .get(`/v1/users/${this.$route.params.id}`)
        .then((res) => {
          this.posts = res.data.posts;
          this.doing_posts = res.data.doing_posts;
          this.want_posts = res.data.want_posts;
          this.master_posts = res.data.master_posts;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // 連続して投稿できない→二回目以降がバックに保存できてなさそう→posts#indexには出来てるがusers#showにできてない
    async addPost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .post(`/v1/posts`, post, config)
        .then(() => {
          this.fetchPostList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "メモを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deletePost(post) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/posts/${post.id}`)
          .then(() => {
            this.fetchPostList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "メモを削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    // 質問
    fetchTopicList() {
      axios
        .get(`/v1/users/${this.$route.params.id}`)
        .then((res) => {
          this.topics = res.data.topics;
          this.unsolved_topics = res.data.unsolved_topics;
          this.solved_topics = res.data.solved_topics;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteTopic(topic) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/topics/${topic.id}`)
          .then(() => {
            this.fetchTopicList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "質問を削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    // 目標
    fetchGoalList() {
      axios
        .get(`/v1/users/${this.$route.params.id}`)
        .then((res) => {
          this.goals = res.data.goals;
          this.unachieved_goals = res.data.unachieved_goals;
          this.achieved_goals = res.data.achieved_goals;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteGoal(goal) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${goal.id}`)
          .then(() => {
            this.fetchGoalList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "目標を削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>