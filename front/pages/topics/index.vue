<template>
  <div>
    <h2 class="text-center">質問する</h2>
    <TopicForm @submit="addTopic" class="mb-4" />
    <h2 class="text-center">質問一覧</h2>
    <!-- ページネーションほしい -->
    <v-row>
      <v-col v-for="topic in topics" :key="topic.id" :cols="12">
        <TopicCard :topic="topic" @submitDeleteTopic="deleteTopic" />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import TopicCard from "@/components/TopicCard";

export default {
  head() {
    return {
      title: "質問掲示板",
    };
  },
  data() {
    return {
      topics: [],
    };
  },
  components: {
    TopicCard,
  },
  created() {
    this.fetchTopicList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async addTopic(topic) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      axios
        .post(`/v1/topics`, topic, config)
        .then(() => {
          this.fetchTopicList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchTopicList() {
      const url = `/v1/topics`;
      axios.get(url).then((res) => {
        this.topics = res.data;
      });
    },
    async deleteTopic(topic) {
      const url = `/v1/topics/${topic.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
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
  },
};
</script>