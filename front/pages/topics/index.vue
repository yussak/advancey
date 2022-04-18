<template>
  <div>
    <!-- 全員の質問・マイ質問というように分けたい -->
    <!-- 後解決・未解決もいい感じに分けたい（どうするか考える） -->
    <h3 style="text-align: center">質問する</h3>
    <!-- コンポ化する -->
    <v-form>
      <v-container>
        <v-text-field
          v-model="title"
          counter="100"
          label="タイトル（必須）"
          required
        ></v-text-field>
        <v-textarea
          v-model="content"
          counter="300"
          label="詳細を入力"
          required
        ></v-textarea>
        <v-file-input
          v-model="image"
          accept="image/*"
          label="画像を追加"
          @change="setImage"
        ></v-file-input>
        <v-btn @click="addTopic">質問を追加する</v-btn>
      </v-container>
    </v-form>
    <h3 style="text-align: center">質問一覧</h3>
    <!-- コンポ化する -->
    <v-card>
      <v-text-field
        v-model="search"
        label="キーワードで質問を検索"
        single-line
        hide-details
      ></v-text-field>
      <v-data-table
        :items="topics"
        :headers="headers"
        :search="search"
        :sort-by="['created_at', 'solve_status']"
        :sort-desc="[true, false]"
      >
        <template v-slot:[`item.username`]="{ item }">
          <v-avatar>
            <!-- アイコン設定がないとき→条件は後で追加 -->
            <img
              src="~assets/default-user-icon.png"
              style="width: 45px; height: 45px"
            />
          </v-avatar>
          {{ item.user.name }}さん
        </template>
        <!-- 順番がすぐに切り替わらないの直したい -->
        <!-- デフォルトの順番は日付が若い順にしたつもり（未解決を上にするとかじゃなく） -->
        <template v-slot:[`item.image_url`]="{ item }">
          <img
            v-if="item.image_url"
            :src="item.image_url"
            alt="test"
            width="30"
            height="30"
          />
        </template>
        <template v-slot:[`item.solve_status`]="{ item }">
          <p class="text-green" v-if="item.solve_status === true">
            解決済み<v-icon class="text-green">mdi-check</v-icon>
          </p>
          <p v-else class="text-red">
            未解決<v-icon class="text-red">mdi-close</v-icon>
          </p>
        </template>
        <template v-slot:[`item.created_at`]="{ item }">
          {{ $dateFns.format(new Date(item.created_at), "yyyy/MM/dd HH:mm") }}
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 自分の質問だけに表示したい→出来たと思う -->
          <v-icon
            v-if="$store.state.auth.currentUser.id === item.user_id"
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
  head() {
    return {
      title: "掲示板",
    };
  },
  data() {
    return {
      search: "",
      topics: [],
      topic: [],
      title: "",
      content: "",
      solve_status: false,
      image: [],
      imageFile: null,
      headers: [
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "質問",
          value: "title",
        },
        {
          text: "画像表示（試し）",
          value: "image_url",
        },
        // {
        // 省略させたい
        //   text: "詳細",
        //   value: "content",
        // },
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
  created() {
    this.fetchTopicList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    addTopic() {
      const topic = new FormData();
      topic.append("topic[title]", this.title);
      topic.append("topic[user_id]", this.user.id);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      if (this.imageFile !== null) {
        topic.append("topic[image]", this.imageFile);
      }
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
      this.title = "";
      this.image = [];
    },
    async showItem(item) {
      this.$router.push(`/topics/${item.id}`);
    },
    // 質問の数ぶんfetchしてるせいで重い
    fetchTopicList() {
      const url = `/v1/topics`;
      axios.get(url).then((res) => {
        this.topics = res.data;
      });
    },
    async deleteTopic(item) {
      const url = `/v1/topics/${item.id}`;
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

<style>
/* 色は後でいい感じの探す＋これ共通化したい */
.text-green {
  color: green !important;
}
.text-red {
  color: brown !important;
}
</style>