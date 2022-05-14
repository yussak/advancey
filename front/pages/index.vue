<template>
  <div>
    <Carousel />
    <TopTabList
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
      :communities="communities"
      @submitDeletePost="deletePost"
      @submitDeleteTopic="deleteTopic"
      @submitDeleteGoal="deleteGoal"
      @submitDeleteCommunity="deleteCommunity"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import TopTabList from "@/components/TopTabList";

export default {
  head() {
    return {
      title: "ホーム",
    };
  },
  components: {
    TopTabList,
  },
  data() {
    return {
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
      communities: [],
    };
  },
  mounted() {
    this.fetchTopObjects();
  },
  methods: {
    // 事前準備
    fetchTopObjects() {
      axios
        .get(`/v1/top_page/posts`)
        .then((res) => {
          this.posts = res.data.posts;
          this.doing_posts = res.data.doing_posts;
          this.want_posts = res.data.want_posts;
          this.done_posts = res.data.done_posts;
          this.master_posts = res.data.master_posts;
        })
        .catch((err) => {
          console.log(err);
        });
      axios
        .get(`/v1/top_page/topics`)
        .then((res) => {
          this.topics = res.data.topics;
          this.unsolved_topics = res.data.unsolved_topics;
          this.solved_topics = res.data.solved_topics;
        })
        .catch((err) => {
          console.log(err);
        });
      axios
        .get(`/v1/top_page/goals`)
        .then((res) => {
          this.goals = res.data.goals;
          this.unachieved_goals = res.data.unachieved_goals;
          this.achieved_goals = res.data.achieved_goals;
        })
        .catch((err) => {
          console.log(err);
        });
      axios
        .get(`/v1/top_page/communities`)
        .then((res) => {
          this.communities = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // メモ
    fetchPostList() {
      axios
        .get(`/v1/top_page/posts`)
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
        .get(`/v1/top_page/topics`)
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
        .get(`/v1/top_page/goals`)
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
    // コミュニティ
    fetchCommunityList() {
      axios
        .get(`/v1/top_page/communities`)
        .then((res) => {
          this.communities = res.data.communities;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteCommunity(community) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/communities/${community.id}`)
          .then(() => {
            this.fetchCommunityList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "コミュニティを削除しました",
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