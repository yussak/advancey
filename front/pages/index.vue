<template>
  <div v-if="user">
    <UserCard :user="user" />
    <PostForm @submit="addPost" />
    <PostList :posts="posts" />
  </div>
</template>

<script>
import PostForm from "@/components/PostForm";
import PostList from "@/components/PostList";
import axios from "@/plugins/axios";

export default {
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
      posts: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchPostList();
  },
  methods: {
    fetchPostList() {
      const url = `/v1/posts`;
      axios.get(url).then((res) => {
        this.posts = res.data;
      });
    },
    async addPost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const url = "/v1/posts";
      axios
        .post(url, post, config)
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
  fetch({ store, redirect }) {
    store.watch(
      (state) => state.auth.currentUser,
      (newUser, oldUser) => {
        if (!newUser) {
          return redirect("/login");
        }
      }
    );
  },
};
</script>