<template>
  <div>
    <!-- 全員の質問・マイ質問というように分けたい -->
    <!-- 後解決・未解決もいい感じに分けたい（どうするか考える） -->
    <h3 style="text-align: center">質問する</h3>
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="title"
              counter="100"
              label="タイトル"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-textarea
              v-model="content"
              counter="300"
              label="質問の詳細があれば入力してください"
              required
            ></v-textarea>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-btn @click="addTopic">質問を追加する</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <h3 style="text-align: center">質問一覧</h3>
    <v-card>
      <v-text-field
        v-model="search"
        label="キーワードで質問を検索"
        single-line
        hide-details
      ></v-text-field>
      <v-data-table
        :headers="headers"
        :items="topics"
        :search="search"
        :sort-by="['created_at', 'solve_status']"
        :sort-desc="[true, false]"
      >
        <!-- 順番がすぐに切り替わらないの直したい -->
        <!-- デフォルトの順番は日付が若い順にしたつもり（未解決を上にするとかじゃなく） -->
        <template v-slot:[`item.solve_status`]="{ item }">
          <p class="text-green" v-if="item.solve_status === true">
            解決済み<v-icon class="text-green">mdi-check</v-icon>
          </p>
          <p v-else class="text-red">
            未解決<v-icon class="text-red">mdi-close</v-icon>
          </p>
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 自分の質問だけに表示したい→出来たと思う -->
          <v-icon
            v-if="$store.state.auth.currentUser.id === item.user.id"
            @click="deleteTopic(item)"
            >delete</v-icon
          >
          <!-- 詳細だけアイコン＋全体をリンクにする予定（削除はボタン周りだけ） -->
          <v-icon @click="showItem(item)">mdi-magnify</v-icon>
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
      search: "",
      topics: [],
      topic: [],
      title: "",
      content: "",
      user_id: "",
      solve_status: false,
      headers: [
        {
          text: "質問",
          value: "title",
        },
        // 省略させたい
        // {
        //   text: "詳細",
        //   value: "content",
        // },
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "解決状況",
          value: "solve_status",
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
    this.fetchTopics(); // 質問の数ぶんfetchしてるせいで重い
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    topic_params() {
      return {
        topic: {
          title: this.title,
          content: this.content,
          solve_status: this.solve_status,
          user_id: this.user.id,
        },
      };
    },
  },
  methods: {
    async showItem(item) {
      this.$router.push(`/topics/${item.id}`);
    },
    // 質問の数ぶんfetchしてるせいで重い
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
          // this.fetchTopics(); //これあるせいで重い＆重複してるかも。後で消して検証(他のところも見る)
          this.title = "";
          this.content = "";
          console.log(res.data);
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
<style>
/* 色は後でいい感じの探す＋これ共通化したい */
.text-green {
  color: green !important;
}
.text-red {
  color: brown !important;
}
</style>