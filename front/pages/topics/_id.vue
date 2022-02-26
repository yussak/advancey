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
      topic_comment_content: "",
    };
  },
  mounted() {
    // title contentなど含めてcontentsとする
    this.fetchTopicContents();
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
    // fetchTopicComments() {
    //   const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
    //   axios.get(url).then((res) => {
    //     this.topic = res.data;
    //   });
    // },
    async addTopicComment() {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
      await axios
        .post(url, this.topic_comment_params)
        .then((res) => {
          // this.fetchTopicComments(); //これあるせいで重い＆重複してるかも。後で消して検証(他の所も見る)
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
  },
};
</script>
