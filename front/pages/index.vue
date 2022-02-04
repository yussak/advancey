<template>
  <div>
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
