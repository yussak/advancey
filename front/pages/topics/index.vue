<template>
  <div>
    <!-- 全員の質問・マイ質問というように分けたい -->
    <h3 style="text-align: center">質問する</h3>
    <form>
      <v-text-field
        v-model="title"
        counter="100"
        label="質問"
        required
      ></v-text-field>
      <v-btn @click="addTopic">質問を追加する</v-btn>
    </form>
    <h3 style="text-align: center">質問一覧</h3>
    <v-data-table
      :headers="headers"
      :items="topics"
      :sort-by="['created_at']"
      :sort-desc="[true]"
    >
      <template v-slot:[`item.action`]="{ item }">
        <!-- 自分の質問だけに表示したい -->
        <div v-if="$store.state.auth.currentUser.id === item.user.id">
          <v-icon small @click="deleteTopic(item)">delete</v-icon>
        </div>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      topics: [],
      topic: [],
      title: "",
      user_id: "",
      headers: [
        // 解決状況なども追加予定(既存の見る)
        {
          text: "質問",
          value: "title",
        },
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "質問日時",
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
    this.fetchTopics();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    topic_params() {
      return {
        topic: {
          title: this.title,
          user_id: this.user.id,
        },
      };
    },
  },
  methods: {
    fetchTopics() {
      const url = `/v1/topics`;
      axios.get(url).then((res) => {
        this.topics = res.data;
      });
    },
    async addTopic() {
      const url = `/v1/topics`;
      await axios
        .post(url, this.topic_params)
        .then((res) => {
          this.fetchTopics();
          this.title = "";
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
    async deleteTopic(item) {
      const url = `/v1/topics/${item.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchTopics();
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