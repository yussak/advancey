<template>
  <div>
    <h1>詳細</h1>
    <p>タイトル：{{ topic.title }}</p>
    <p>詳細：{{ topic.content }}</p>
    <a @click="$router.back()">もどる</a>
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="topic_comment_content"
              counter="100"
              label="質問へのコメント"
              required
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-btn @click="addTopicComment">コメントする</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <v-divider></v-divider>
    <!-- <template> -->
    <v-card>
      <v-card-content>
        コメント一覧<span style="color: red"
          >（コメント数表示する）</span
        ></v-card-content
      >
      <!-- Vuex周り書く必要ありそう -->
      <!-- <p>コメント数：{{ topic.commentCounts }}</p> -->
      <v-data-table
        :headers="headers"
        :items="topic_comments"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <template v-slot:[`item.action`]="{ item }">
          <!-- 自分の投稿だけに表示したい -->
          <v-icon small @click="deleteTopicComment(item)">delete</v-icon>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      topic: [],
      title: "",
      content: "",
      topic_comments: [],
      topic_comment_content: "",
      headers: [
        {
          text: "コメント",
          value: "topic_comment_content",
        },
        {
          text: "ユーザー名",
          value: "username",
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
    this.fetchTopicContents();
    this.fetchTopicComments();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    topic_comment_params() {
      return {
        topic_comment: {
          topic_comment_content: this.topic_comment_content,
        },
      };
    },
  },
  methods: {
    fetchTopicContents() {
      const url = `/v1/topics/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.topic = res.data;
      });
    },
    fetchTopicComments() {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
      axios.get(url).then((res) => {
        this.topic_comments = res.data;
      });
    },
    async addTopicComment() {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
      await axios
        .post(url, this.topic_comment_params)
        .then((res) => {
          this.fetchTopicComments(); //これあるせいで重い＆重複してるかも。後で消して検証(他の所も見る)
          // でもこれ書かないと追加されないので一旦書く
          // pushとかどう？後で試す
          this.topic_comment_content = "";
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          alert("failed");
          console.log(err);
        });
    },
    async deleteTopicComment(item) {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments/${item.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchTopicComments();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
  },
};
</script>
