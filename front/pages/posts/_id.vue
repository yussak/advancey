<template>
  <div>
    <h1>投稿詳細ページです</h1>
    {{ post.content }}
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      post: [],
    };
  },
  mounted() {
    this.fetchContent();
  },
  methods: {
    fetchContent() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.post = res.data;
        console.log(this.post);
      });
    },
  },
};
</script>
