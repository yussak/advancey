<template>
  <div v-if="user">
    <p>名前は{{ user.name }}</p>
    <AddPost @submit="addPost" />
    <PostList :posts="user.posts" />
  </div>
</template>

<script>
import AddPost from "@/components/AddPost";
import PostList from "@/components/PostList";
import axios from "@/plugins/axios";

export default {
  components: {
    AddPost,
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
  methods: {
    async addPost(post) {
      const { data } = await axios.post("/v1/posts", { post });
      this.$store.dispatch("auth/setUser", {
        ...this.user,
        posts: [...this.user.posts, data],
      });
      this.$store.dispatch("notification/setNotice", {
        status: true,
        message: "投稿を追加しました",
      });
      setTimeout(() => {
        this.$store.dispatch("notification/setNotice", {});
      }, 3000);
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

<style>
</style>
