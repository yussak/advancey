<template>
  <div>
    <!-- <h2>topic index</h2> -->
    <!-- すべてのユーザーのtopicをここに追加（ユーザーごとのページじゃなく） -->
    <!-- 全員の質問・マイ質問というように分けたい -->
    <!-- フォーム作成 -->
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
    <!-- 質問一覧 -->
    <h3 style="text-align: center">質問一覧</h3>
    <v-data-table
      :headers="headers"
      :items="topics"
      :sort-by="['created_at']"
      :sort-desc="[true]"
    >
      <template v-slot:[`item.action`]="{ item }">
        <!-- 自分の質問だけに表示したい -->
        <v-icon small @click="deleteTopic(item)">delete</v-icon>
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
      title: "",
      headers: [
        {
          text: "質問",
          value: "title",
        },
        {
          // text: "ユーザー名",
          // value: "username",

          // 質問作成したユーザー名も表示可能にする
          text: "ユーザーID(後でユーザー名に変更する)",
          value: "user_id",
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
    topic_params() {
      return {
        topic: {
          title: this.title,
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
        })
        .catch((err) => {
          alert("failed");
          console.log(err);
        });
    },
  },
};
</script>
