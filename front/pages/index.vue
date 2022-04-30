<template>
  <div v-if="user">
    <UserCard :user="user" />
    <PostForm @submit="addPost" />
    <!-- <PostList :posts="posts" /> -->
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import PostForm from "@/components/PostForm";
import PostList from "@/components/PostList";

export default {
  // middleware: "login-check", //ログイン後でもリロードするとリダイレクトされる
  head() {
    return {
      title: "ホーム",
    };
  },
  components: {
    PostForm,
    PostList,
  },
  data() {
    return {
      // posts: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    // this.fetchPostList();
  },
  methods: {
    // fetchPostList() {
    //   const url = `/v1/posts`;
    //   axios
    //     .get(url, {
    //       params: { user_id: this.$store.state.auth.currentUser.id },
    //     })
    //     .then((res) => {
    //       this.posts = res.data;
    //       console.log(res.data);
    //     });
    // },
    async addPost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      axios
        .post(`/v1/posts`, post, config)
        .then(() => {
          this.fetchPostList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "投稿を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>