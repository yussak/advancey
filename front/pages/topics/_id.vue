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
    <EditTopicDialog
      v-if="user.id === topic.user_id"
      @submitEditTopictopic="updateTopic"
      :topic="topic"
    />
    <v-row>
      <v-col>
        <UserCard v-if="topic.user" :user="topic.user" />
        <p>タイトル：{{ topic.title }}</p>
        <p v-if="topic.content">詳細：{{ topic.content }}</p>
        <div v-if="topic.image_url !== null">
          <p>画像</p>
          <img
            :src="topic.image_url"
            alt="質問の画像"
            style="max-width: 600px"
          />
        </div>
        <a @click="$router.back()">戻る</a>
        <v-icon
          v-if="topic.user_id === user.id || user.admin"
          @click="deleteTopic"
          >delete</v-icon
        >
      </v-col>
    </v-row>
    <TopicCommentForm @submit="addTopicComment" :topic="topic" />
    <h3 v-if="count" class="text-center">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center">コメントはまだありません</h3>
    <!-- スタイル調整・コンポ化したい -->
    <v-card>
      <v-data-table
        :headers="headers"
        :items="topic_comments"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <template v-slot:[`item.username`]="{ item }">
          <UserCard :user="item.user" />
        </template>
        <template v-slot:[`item.image_url`]="{ item }">
          <img
            v-if="item.image_url"
            :src="item.image_url"
            alt="質問コメントの画像"
            width="30"
            height="30"
          />
        </template>
        <template v-slot:[`item.created_at`]="{ item }">
          {{ $dateFns.format(new Date(item.created_at), "yyyy/MM/dd HH:mm") }}
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 編集済みとしたい -->
          <v-icon
            v-if="item.user_id === user.id"
            @click="openEditTopicCommentDialog(item)"
            >edit</v-icon
          >
          <v-icon
            v-if="item.user_id === user.id || user.admin"
            small
            @click="deleteTopicComment(item)"
            >delete</v-icon
          >
        </template>
      </v-data-table>
    </v-card>
    <EditTopicCommentDialog
      ref="child"
      :topic="topic"
      @submitEditTopicComment="updateTopicComment"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import EditTopicCommentDialog from "@/components/EditTopicCommentDialog";
import TopicCommentForm from "@/components/TopicCommentForm";
import EditTopicDialog from "@/components/EditTopicDialog";

export default {
  head() {
    return {
      title: "質問詳細",
    };
  },
  components: {
    EditTopicCommentDialog,
    TopicCommentForm,
    EditTopicDialog,
  },
  data() {
    return {
      topic: [],
      title: "",
      content: "",
      solve_status: false,
      topic_comments: [],
      image: [],
      imageFile: null,
      headers: [
        {
          text: "コメント",
          value: "content",
        },
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "画像表示（試し）",
          value: "image_url",
        },
        {
          text: "コメント日時",
          value: "created_at",
        },
        {
          text: "",
          value: "action",
        },
      ],
    };
  },
  mounted() {
    this.fetchTopic();
    this.fetchTopicCommentList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    count() {
      return this.topic_comments.length;
    },
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
