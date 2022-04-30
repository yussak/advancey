<template>
  <div>
    <h2 class="text-center">質問する</h2>
    <TopicForm @submit="addTopic" class="mb-4" />
    <h2 class="text-center">質問一覧</h2>
    <!-- ページネーションほしい -->
    <v-row>
      <v-col v-for="topic in topics" :key="topic.id" :cols="12">
        <v-card>
          <v-card-actions>
            <UserCard :user="topic.user" />
            <p class="mx-2">
              {{
                $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm")
              }}に追加
            </p>
            <p v-if="topic.solve_status" class="green--text font-weight-bold">
              解決済み
            </p>
            <p v-else class="red--text font-weight-bold">受付中</p>
          </v-card-actions>
          <v-card-title>{{ topic.title }}</v-card-title>
          <v-card-subtitle
            v-if="topic.content"
            class="text-truncate"
            style="max-width: 60%"
            >{{ topic.content }}
          </v-card-subtitle>
          <v-card-text>
            <img
              v-if="topic.image_url"
              :src="topic.image_url"
              style="max-width: 100%"
              alt="質問画像"
            />
          </v-card-text>
          <v-card-actions>
            <v-icon v-if="user.id === topic.user_id" @click="deleteTopic(topic)"
              >delete</v-icon
            >
            <v-icon @click="showTopic(topic)">mdi-magnify</v-icon>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

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
    async showTopic(topic) {
      this.$router.push(`/topics/${topic.id}`);
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