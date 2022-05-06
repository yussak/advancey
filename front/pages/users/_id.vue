<template>
  <div>
    <h1 v-if="currentUser.id === user.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <v-card class="mb-4">
      <v-card-actions>
        <UserCard :user="currentUser" v-if="currentUser.id === user.id" />
        <UserCard :user="user" v-else />
        <v-spacer></v-spacer>
        <EditUserDialog
          v-if="currentUser.id === user.id"
          ref="editUserDialog"
          @submitEditName="editUser"
          @submitEditProfile="editUser"
          @submitEditImage="editUserImage"
        />
        <a @click="$router.back()">戻る</a>
      </v-card-actions>
      <v-card-text v-if="currentUser.id === user.id && currentUser.profile">{{
        currentUser.profile
      }}</v-card-text>
      <v-card-text v-else-if="currentUser.id !== user.id && user.profile">{{
        user.profile
      }}</v-card-text>
      <v-card-text v-if="user.created_at">
        <v-icon>mdi-calendar</v-icon>
        {{
          $dateFns.format(new Date(user.created_at), "yyyy年MM月")
        }}からAdvanceyを利用しています
      </v-card-text>
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
      master_posts: [],
      topics: [],
      unsolved_topics: [],
      solved_topics: [],
      goals: [],
      achieved_goals: [],
      unachieved_goals: [],
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchUserObjects();
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
    // ユーザー
    async editUser(user) {
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
    // 連続して投稿できない→二回目以降がバックに保存できてなさそう→Topicは出来てるので見てみる
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