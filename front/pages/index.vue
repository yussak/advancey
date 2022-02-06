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
    },
  },
};
</script>

<style>
</style>
