<template>
  <div>
    <AddPost @submit="addPost" />
    <PostList :posts="posts" />
  </div>
</template>

<script>
import AddPost from "@/components/AddPost";
import PostList from "@/components/PostList";

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
    addPost(content) {
      this.posts.push({
        content,
      });
    },
  },
};
</script>

<style>
</style>
