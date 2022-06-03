<template>
  <div>
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
    <v-card class="mb-4">
      <v-card-text class="font-weight-bold text-h6"
        ><v-icon @click="$router.back()" class="mr-4">mdi-arrow-left</v-icon
        >質問</v-card-text
      >
      <v-divider></v-divider>
      <v-card-actions class="pb-0">
        <p><UserCard v-if="topic.user" :user="topic.user" /></p>
        <v-spacer></v-spacer>
        <!-- ドロップダウン -->
        <v-menu v-if="user.id === topic.user_id || admin" v-model="topicMenu">
          <template v-slot:activator="{ on, attrs }">
            <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
          </template>
          <v-list>
            <v-list-item>
              <EditTopicDialog :topic="topic" @submitEditTopic="updateTopic" />
            </v-list-item>
            <v-list-item>
              <v-btn text
                ><v-icon @click="deleteTopic">delete</v-icon>削除</v-btn
              >
            </v-list-item>
          </v-list>
        </v-menu>
      </v-card-actions>
      <v-card-title class="subtitle-1 pb-2">タイトル</v-card-title>
      <v-card-text class="br-content">{{ topic.title }}</v-card-text>
      <v-card-title v-if="topic.content" class="subtitle-1 pb-2"
        >詳細</v-card-title
      >
      <v-card-text v-if="topic.content" class="br-content body-1">{{
        topic.content
      }}</v-card-text>
      <v-card-text class="text-center" v-if="topic.image_url">
        <img
          :src="topic.image_url"
          alt="質問の画像"
          style="max-width: 100%; max-height: 200px"
        />
      </v-card-text>
      <v-card-text v-if="topic.created_at">
        {{ $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm") }}
        <span v-if="topic.created_at !== topic.updated_at">(編集済み)</span>
      </v-card-text>
      <v-divider></v-divider>
      <v-card-text class="font-weight-bold">
        <span v-if="topic.solve_status" class="green--text">解決済</span>
        <span v-else class="red--text">未解決</span>
      </v-card-text>
    </v-card>
    <TopicCommentForm @submit="addTopicComment" :topic="topic" />
    <h3 v-if="count" class="text-center my-4">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center">コメントはまだありません</h3>
    <v-row v-for="comment in topic_comments" :key="comment.id">
      <v-col>
        <v-card>
          <v-card-actions>
            <p><UserCard :user="comment.user" /></p>
            <div class="hidden-sm-and-down">
              <p>
                {{
                  $dateFns.format(
                    new Date(comment.created_at),
                    "yyyy/MM/dd HH:mm"
                  )
                }}
                <span v-if="comment.created_at !== comment.updated_at"
                  >(編集済み)</span
                >
              </p>
            </div>
            <v-spacer></v-spacer>
            <!-- ドロップダウン -->
            <v-menu bottom v-model="comment.topicCommentMenu">
              <template v-slot:activator="{ on, attrs }">
                <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
              </template>
              <v-list>
                <v-list-item>
                  <EditTopicCommentDialog
                    v-if="user.id === comment.user_id"
                    :topic="topic"
                    :comment="comment"
                    @submitEditTopicComment="updateTopicComment"
                  />
                </v-list-item>
                <v-list-item>
                  <v-btn text
                    ><v-icon
                      v-if="user.id === comment.user_id || user.admin"
                      @click="deleteTopicComment(comment)"
                      >delete</v-icon
                    >削除</v-btn
                  >
                </v-list-item>
              </v-list>
            </v-menu>
          </v-card-actions>
          <v-card-text class="hidden-md-and-up py-0">
            <span>{{
              $dateFns.format(new Date(comment.created_at), "yyyy/MM/dd HH:mm")
            }}</span>
            <span v-if="comment.created_at !== comment.updated_at"
              >(編集済み)</span
            >
          </v-card-text>
          <v-card-title class="br-content">{{ comment.content }}</v-card-title>
          <v-card-text class="text-center">
            <img
              v-if="comment.image_url"
              :src="comment.image_url"
              alt="質問コメントの画像"
              style="max-width: 100%; max-height: 200px"
            />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
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
      topicMenu: false,
      topicCommentMenu: false,
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
          this.topicMenu = false;
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
