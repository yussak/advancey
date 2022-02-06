<template>
  <div v-if="user">
    <p>名前は{{ user.name }}</p>
    <AddPost @submit="addPost" />
    <PostList :posts="posts" />
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
    async addPost(content) {
      await axios.post("/v1/posts", { content });
      this.posts.push({
        content,
      });
    },
  },
};
</script>

<style>
</style>
