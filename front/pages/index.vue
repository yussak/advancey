<template>
  <div>
    <Carousel />
    <v-card>
      <v-tabs grow>
        <!-- メモ、質問、目標、コミュニティ -->
        <v-tab v-for="title in outerTitles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <!-- メモ -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in memoTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard
                          v-if="user"
                          :post="post"
                          @submitDeletePost="deletePost"
                        />
                        <NotLoginPostCard
                          v-else
                          :user="post.user"
                          :post="post"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && doing_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in doing_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard
                          v-if="user"
                          :post="post"
                          @submitDeletePost="deletePost"
                        />
                        <NotLoginPostCard
                          v-else
                          :user="post.user"
                          :post="post"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && want_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in want_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard
                          v-if="user"
                          :post="post"
                          @submitDeletePost="deletePost"
                        />
                        <NotLoginPostCard
                          v-else
                          :user="post.user"
                          :post="post"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && master_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in master_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard
                          v-if="user"
                          :post="post"
                          @submitDeletePost="deletePost"
                        />
                        <NotLoginPostCard
                          v-else
                          :user="post.user"
                          :post="post"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 質問 -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in topicTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(topics && topics.length)"
                        >質問がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="topic in topics"
                        :key="topic.id"
                        cols="12"
                      >
                        <TopicCard
                          v-if="user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                        <NotLoginTopicCard
                          v-else
                          :user="topic.user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(topics && unsolved_topics.length)"
                        >質問がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="topic in unsolved_topics"
                        :key="topic.id"
                        cols="12"
                      >
                        <TopicCard
                          v-if="user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                        <NotLoginTopicCard
                          v-else
                          :user="topic.user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(topics && solved_topics.length)"
                        >質問がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="topic in solved_topics"
                        :key="topic.id"
                        cols="12"
                      >
                        <TopicCard
                          v-if="user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                        <NotLoginTopicCard
                          v-else
                          :user="topic.user"
                          :topic="topic"
                          @submitDeleteTopic="deleteTopic"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 目標 -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in goalTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(goals && goals.length)"
                        >目標がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="goal in goals"
                        :key="goal.id"
                        cols="12"
                      >
                        <GoalCard
                          v-if="user"
                          :goal="goal"
                          @submitDeleteGoal="deleteGoal"
                        />
                        <NotLoginGoalCard
                          v-else
                          :user="goal.user"
                          :goal="goal"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(goals && unachieved_goals.length)"
                        >目標がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="goal in unachieved_goals"
                        :key="goal.id"
                        cols="12"
                      >
                        <GoalCard
                          v-if="user"
                          :goal="goal"
                          @submitDeleteGoal="deleteGoal"
                        />
                        <NotLoginGoalCard
                          v-else
                          :user="goal.user"
                          :goal="goal"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(goals && achieved_goals.length)"
                        >目標がありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="goal in achieved_goals"
                        :key="goal.id"
                        cols="12"
                      >
                        <GoalCard
                          v-if="user"
                          :goal="goal"
                          @submitDeleteGoal="deleteGoal"
                        />
                        <NotLoginGoalCard
                          v-else
                          :user="goal.user"
                          :goal="goal"
                        />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- コミュニティ -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in communityTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(communities && communities.length)"
                        >コミュニティがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="community in communities"
                        :key="community.id"
                        cols="12"
                      >
                        <CommunityCard
                          v-if="user"
                          :community="community"
                          @submitDeleteCommunity="deleteCommunity"
                        />
                        <NotLoginCommunityCard v-else :community="community" />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import PostCard from "@/components/PostCard";
import NotLoginPostCard from "@/components/NotLoginPostCard";
import TopicCard from "@/components/TopicCard";
import NotLoginTopicCard from "@/components/NotLoginTopicCard";
import GoalCard from "@/components/GoalCard";
import NotLoginGoalCard from "@/components/NotLoginGoalCard";
import CommunityCard from "@/components/CommunityCard";
import NotLoginCommunityCard from "@/components/NotLoginCommunityCard";

export default {
  head() {
    return {
      title: "ホーム",
    };
  },
  components: {
    PostCard,
    NotLoginPostCard,
    TopicCard,
    NotLoginTopicCard,
    GoalCard,
    NotLoginGoalCard,
    CommunityCard,
    NotLoginCommunityCard,
  },
  data() {
    return {
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
      communities: [],
      outerTitles: [
        { name: "メモ" },
        { name: "Q&A" },
        { name: "目標" },
        { name: "コミュニティ" },
      ],
      memoTitles: [
        { name: "新着" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "やって良かった" },
      ],
      topicTitles: [{ name: "新着" }, { name: "受付中" }, { name: "解決済み" }],
      goalTitles: [{ name: "新着" }, { name: "未達成" }, { name: "達成済み" }],
      communityTitles: [{ name: "新着" }],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
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