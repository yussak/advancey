<template>
  <div>
    <h2 class="text-center mb-4">運営からのお知らせ</h2>
    <ValidationObserver v-slot="{ invalid }" ref="addNewsObserver">
      <v-form v-if="user.admin" class="white mb-4">
        <v-container>
          <ValidationProvider
            rules="required|max:200"
            name="お知らせ"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="content"
              counter="200"
              label="お知らせ内容"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-btn :disabled="invalid" @click="addNews">お知らせを投稿</v-btn>
        </v-container>
      </v-form>
    </ValidationObserver>
    <div v-for="news in revNewsList" :key="news.id">
      <div class="d-flex">
        <p class="mr-2 font-weight-bold">
          {{ $dateFns.format(new Date(news.created_at), "yyyy/MM/dd") }}
        </p>
        <p>{{ news.content }}</p>
        <v-icon v-if="user.admin" @click="deleteNews(news)">delete</v-icon>
      </div>
      <v-divider></v-divider>
    </div>
  </div>
</template>


<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "運営からのお知らせ",
    };
  },
  data() {
    return {
      newsList: [],
      content: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    revNewsList() {
      return this.newsList.slice().reverse();
    },
  },
  mounted() {
    this.fetchNewsList();
  },
  methods: {
    fetchNewsList() {
      const url = `/v1/news`;
      axios.get(url).then((res) => {
        this.newsList = res.data;
      });
    },
    async addNews() {
      axios
        .post(`/v1/news`, {
          news_list: {
            user_id: this.user.id,
            content: this.content,
          },
        })
        .then(() => {
          this.fetchNewsList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "お知らせを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
          this.content = "";
          this.$refs.addNewsObserver.reset();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteNews(news) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/news/${news.id}`).then(() => {
          this.fetchNewsList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "お知らせを削除しました",
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
