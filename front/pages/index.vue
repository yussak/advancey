<template>
  <div>
    <!-- <div v-if="user"> -->
    <Carousel />
    <v-card>
      <v-tabs grow>
        <!-- メモ、質問、目標、コミュニティ -->
        <v-tab v-for="title in outerTitles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <!-- メモ PostList使いたい -->
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
                      <!-- 中身があってもリロード時空のテキストが一瞬表示されてしまうの要修正 -->
                      <!-- これで行けたかも→削除なおしたらまた検証 -->
                      <v-col
                        v-for="post in posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard
                          :post="post"
                          v-if="posts && posts.length"
                          @submitDeletePost="deletePost"
                        />
                        <p v-else>no MEMO</p>
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
                        <PostCard :post="post" @submitDeletePost="deletePost" />
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
                        <PostCard :post="post" @submitDeletePost="deletePost" />
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
                        <PostCard :post="post" @submitDeletePost="deletePost" />
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
                        <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
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
                        <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
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
                        <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
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
                        name:{{ community.name }}
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
import PostForm from "@/components/PostForm";
import PostList from "@/components/PostList";
import PostCard from "@/components/PostCard";
import TopicCard from "@/components/TopicCard";
import GoalCard from "@/components/GoalCard";

export default {
  head() {
    return {
      title: "ホーム",
    };
  },
  components: {
    PostForm,
    PostList,
    PostCard,
    TopicCard,
    GoalCard,
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
      addPostDialog: false,
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
        { name: "身についた" },
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
    fetchTopObjects() {
      axios.get(`/v1/top_page/posts`).then((res) => {
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
      });
      axios.get(`/v1/top_page/topics`).then((res) => {
        this.topics = res.data.topics;
        this.unsolved_topics = res.data.unsolved_topics;
        this.solved_topics = res.data.solved_topics;
      });
      axios.get(`/v1/top_page/goals`).then((res) => {
        this.goals = res.data.goals;
        this.unachieved_goals = res.data.unachieved_goals;
        this.achieved_goals = res.data.achieved_goals;
      });
      axios.get(`/v1/top_page/communities`).then((res) => {
        this.communities = res.data;
      });
    },
    async deletePost(post) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${post.id}`).then(() => {
          this.fetchPostList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "メモを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
    fetchPostList() {
      axios.get(`/v1/top_page/posts`).then((res) => {
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
      });
    },
    async deleteTopic(topic) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/topics/${topic.id}`).then(() => {
          this.fetchTopicList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
    fetchTopicList() {
      axios.get(`/v1/top_page/topics`).then((res) => {
        this.topics = res.data.topics;
        this.unsolved_topics = res.data.unsolved_topics;
        this.solved_topics = res.data.solved_topics;
      });
    },
    async deleteGoal(goal) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/goals/${goal.id}`).then(() => {
          this.fetchGoalList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "目標を削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
    fetchGoalList() {
      axios.get(`/v1/top_page/goals`).then((res) => {
        this.goals = res.data.goals;
        this.unachieved_goals = res.data.unachieved_goals;
        this.achieved_goals = res.data.achieved_goals;
      });
    },
  },
};
</script>