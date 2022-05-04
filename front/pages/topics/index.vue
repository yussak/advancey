<template>
  <div>
    <h2 class="text-center">質問する</h2>
    <TopicForm @submit="addTopic" class="mb-4" />
    <h2 class="text-center">質問一覧</h2>
    <!-- ページネーションほしい -->
    <v-card>
      <v-tabs grow>
        <v-tab v-for="title in topicTitles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(topics && topics.length)">質問がありません</v-col>
            <v-col v-else v-for="topic in topics" :key="topic.id" cols="12">
              <TopicCard :topic="topic" @submitDeleteTopic="deleteTopic" />
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
              <TopicCard :topic="topic" @submitDeleteTopic="deleteTopic" />
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
              <TopicCard :topic="topic" @submitDeleteTopic="deleteTopic" />
            </v-col>
          </v-row>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import TopicCard from "@/components/TopicCard";

export default {
  components: {
    TopicCard,
  },
  head() {
    return {
      title: "質問掲示板",
    };
  },
  data() {
    return {
      topics: [],
      unsolved_topics: [],
      solved_topics: [],
      topicTitles: [{ name: "全て" }, { name: "受付中" }, { name: "解決済み" }],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchTopicList();
  },
  methods: {
    fetchTopicList() {
      const url = `/v1/topics`;
      axios.get(url).then((res) => {
        this.topics = res.data.topics;
        this.unsolved_topics = res.data.unsolved_topics;
        this.solved_topics = res.data.solved_topics;
      });
    },
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