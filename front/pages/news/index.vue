<template>
  <div>
    <h2 class="text-center mb-4">運営からのお知らせ</h2>
    <NewsForm @submit="addNews" />
    <div v-for="news in newsList" :key="news.id">
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
import NewsForm from "@/components/NewsForm";

export default {
  components: {
    NewsForm,
  },
  head() {
    return {
      title: "運営からのお知らせ",
    };
  },
  data() {
    return {
      newsList: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchNewsList();
  },
  methods: {
    fetchNewsList() {
      axios
        .get(`/v1/news`)
        .then((res) => {
          this.newsList = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addNews(news) {
      await axios
        .post(`/v1/news`, news)
        .then(() => {
          this.fetchNewsList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "お知らせを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteNews(news) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/news/${news.id}`)
          .then(() => {
            this.fetchNewsList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "お知らせを削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>
