<template>
  <div>
    <h2>非公開メモ一覧</h2>
    <p>このページは自分だけが閲覧可能です</p>
    <PostList :posts="private_posts" />
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  middleware: "handle-user-privateposts",
  head() {
    return {
      title: "非公開メモ一覧",
    };
  },
  data() {
    return {
      private_posts: [],
      titles: [
        { name: "全部のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
      ],
    };
  },
  mounted() {
    this.fetchPrivatePostList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    fetchPrivatePostList() {
      const url = `/v1/users/${this.$route.params.userId}/private_posts`;
      axios
        .get(url)
        .then((res) => {
          this.private_posts = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        this.fetchPrivatePostList();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      }
    },
  },
};
</script>
