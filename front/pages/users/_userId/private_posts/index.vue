<template>
  <div>
    <h2>非公開メモ一覧</h2>
    <p>このページは自分だけが閲覧可能です</p>
    <v-icon @click="$router.back()">mdi-arrow-left-bottom</v-icon>
    <PostList
      :posts="private_posts"
      :doing_posts="doing_posts"
      :want_posts="want_posts"
      :done_posts="done_posts"
      :master_posts="master_posts"
      @submitDeletePost="deletePost"
    />
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "非公開メモ一覧",
    };
  },
  middleware: "handle-user-privateposts",
  data() {
    return {
      private_posts: [],
      doing_posts: [],
      want_posts: [],
      done_posts: [],
      master_posts: [],
      titles: [
        { name: "全部のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "実践済み" },
        { name: "やって良かった" },
      ],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchPrivatePostList();
  },
  methods: {
    fetchPrivatePostList() {
      axios
        .get(`/v1/users/${this.$route.params.userId}/private_posts`)
        .then((res) => {
          this.private_posts = res.data.posts;
          this.doing_posts = res.data.doing_posts;
          this.want_posts = res.data.want_posts;
          this.done_posts = res.data.done_posts;
          this.master_posts = res.data.master_posts;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deletePost(post) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/posts/${post.id}`)
          .then(() => {
            this.fetchPrivatePostList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "メモを削除しました",
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
