<template>
  <div>
    <h1 v-if="user.id === currentUser.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <UserCard :user="currentUser" v-if="user.id === currentUser.id" />
    <UserCard :user="user" v-else />
    <p v-if="user.id === currentUser.id && currentUser.profile">
      自己紹介：{{ currentUser.profile }}
    </p>
    <p v-else-if="user.id !== currentUser.id && user.profile">
      自己紹介：{{ user.profile }}
    </p>
    <p v-if="user.created_at">
      <v-icon>mdi-calendar</v-icon>
      {{
        $dateFns.format(new Date(user.created_at), "yyyy年MM月")
      }}からAdvanceyを利用しています
    </p>
    <a @click="$router.back()">戻る</a>

    <!-- 右辺、ぜんぶeditUserに統一できるはず(画像以外) -->
    <!-- refsは親から子コンポーネントのモーダルを閉じるため -->
    <EditUserDialog
      v-if="user.id === currentUser.id"
      ref="editUserDialog"
      @submitEditName="editUserName"
      @submitEditProfile="editUserProfile"
      @submitEditImage="editUserImage"
    />
    <AddPostDialog v-if="user.id === currentUser.id" @submitPost="addPost" />

    <v-card>
      <v-tabs grow>
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
                        <PostCard :post="post" @submitDeletePost="deletePost" />
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
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import EditUserDialog from "@/components/EditUserDialog";
import PostCard from "@/components/PostCard";
import TopicCard from "@/components/TopicCard";
import GoalCard from "@/components/GoalCard";

export default {
  head() {
    return {
      title: "ユーザー詳細",
    };
  },
  components: {
    EditUserDialog,
    PostCard,
    TopicCard,
    GoalCard,
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
      outerTitles: [{ name: "メモ" }, { name: "Q&A" }, { name: "目標" }],
      memoTitles: [
        { name: "全て" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "やって良かった" },
      ],
      topicTitles: [{ name: "全て" }, { name: "受付中" }, { name: "解決済み" }],
      goalTitles: [{ name: "全て" }, { name: "未達成" }, { name: "達成済み" }],
    };
  },
  mounted() {
    this.fetchMyObjects();
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    fetchMyObjects() {
      axios.get(`/v1/users/${this.$route.params.id}`).then((res) => {
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
      });
    },
    async fetchPostList() {
      const url = `/v1/users/${this.$route.params.id}`;
      await axios.get(url).then((res) => {
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
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
      axios.get(`/v1/users/${this.$route.params.id}`).then((res) => {
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
      axios.get(`/v1/users/${this.$route.params.id}`).then((res) => {
        this.goals = res.data.goals;
        this.unachieved_goals = res.data.unachieved_goals;
        this.achieved_goals = res.data.achieved_goals;
      });
    },
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