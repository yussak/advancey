<template>
  <div>
    <h2 class="text-center">質問詳細</h2>
    <v-alert
      v-if="topic.solve_status"
      border="top"
      colored-border
      type="info"
      elevation="2"
      class="text-center"
    >
      この質問は投稿者によって解決済みとされたためクローズされました
    </v-alert>
    <v-row>
      <v-col>
        <v-card class="mb-4">
          <v-card-actions>
            <UserCard v-if="topic.user" :user="topic.user" />
            <p v-if="topic.created_at">
              {{
                $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm")
              }}
            </p>
            <v-spacer></v-spacer>
            <EditTopicDialog
              v-if="user.id === topic.user_id"
              :topic="topic"
              @submitEditTopic="updateTopic"
            />
            <v-icon @click="deleteTopic">delete</v-icon>
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
          <v-card-title>タイトル</v-card-title>
          <v-card-text>{{ topic.title }}</v-card-text>
          <v-card-title v-if="topic.content">詳細</v-card-title>
          <v-card-text v-if="topic.content">{{ topic.content }}</v-card-text>
          <v-card-text>
            <img
              v-if="topic.image_url"
              :src="topic.image_url"
              alt="質問の画像"
              style="width: 100%; max-height: 500px; height: 100%"
            />
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <EditTopicDialog
              v-if="user.id === topic.user_id"
              :topic="topic"
              @submitEditTopic="updateTopic"
            />
            <v-icon @click="deleteTopic">delete</v-icon>
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <TopicCommentForm @submit="addTopicComment" :topic="topic" />
    <h3 v-if="count" class="text-center">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center">コメントはまだありません</h3>
    <v-row v-for="comment in topic_comments" :key="comment.id">
      <v-col>
        <v-card>
          <v-card-actions>
            <UserCard :user="comment.user" />
            <p>
              {{
                $dateFns.format(
                  new Date(comment.created_at),
                  "yyyy/MM/dd HH:mm"
                )
              }}
            </p>
            <v-spacer></v-spacer>
            <!-- 編集済みとしたい -->
            <v-icon
              v-if="user.id === comment.user_id"
              @click="openEditTopicCommentDialog(comment)"
              >edit</v-icon
            >
            <v-icon
              v-if="user.id === comment.user_id || user.admin"
              @click="deleteTopicComment(comment)"
              >delete</v-icon
            >
          </v-card-actions>
          <v-card-title>{{ comment.content }}</v-card-title>
          <img
            v-if="comment.image_url"
            :src="comment.image_url"
            alt="質問コメントの画像"
            style="width: 100%; max-height: 400px; height: 100%"
          />
        </v-card>
      </v-col>
    </v-row>
    <EditTopicCommentDialog
      ref="child"
      :topic="topic"
      @submitEditTopicComment="updateTopicComment"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import EditTopicDialog from "@/components/EditTopicDialog";
import TopicCommentForm from "@/components/TopicCommentForm";
import EditTopicCommentDialog from "@/components/EditTopicCommentDialog";

export default {
  head() {
    return {
      title: "質問詳細",
    };
  },
  components: {
    EditTopicDialog,
    TopicCommentForm,
    EditTopicCommentDialog,
  },
  data() {
    return {
      topic: [],
      topic_comments: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    count() {
      return this.topic_comments.length;
    },
  },
  mounted() {
    this.fetchTopic();
    this.fetchTopicCommentList();
  },
  methods: {
    // 質問
    fetchTopic() {
      axios
        .get(`/v1/topics/${this.$route.params.id}`)
        .then((res) => {
          this.topic = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteTopic() {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/topics/${this.$route.params.id}`)
          .then(() => {
            this.$router.push("/topics");
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
    async updateTopic(topic) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .put(`/v1/topics/${this.$route.params.id}`, topic, config)
        .then(() => {
          this.fetchTopic();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // コメント
    fetchTopicCommentList() {
      axios
        .get(`/v1/topics/${this.$route.params.id}`)
        .then((res) => {
          this.topic_comments = res.data.topic_comments;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addTopicComment(comment) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .post(
          `/v1/topics/${this.$route.params.id}/topic_comments`,
          comment,
          config
        )
        .then(() => {
          this.fetchTopicCommentList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteTopicComment(comment) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(
            `/v1/topics/${this.$route.params.id}/topic_comments/${comment.id}`
          )
          .then(() => {
            this.fetchTopicCommentList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "コメントを削除しました",
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
    openEditTopicCommentDialog(item) {
      this.$refs.child.openEditTopicCommentDialog(item);
    },
    async updateTopicComment(comment, commendId) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .put(
          `/v1/topics/${this.$route.params.id}/topic_comments/${commendId}`,
          comment,
          config
        )
        .then(() => {
          this.fetchTopicCommentList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを編集しました",
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
