<template>
  <div>
   
  </div>
</template>

<script>
export default {
  data() {
    return {
      content: "",
      tag: "",
      image: [],
      privacy: false,
      imageFile: null,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    handleSubmitPost() {
      const post = new FormData();
      post.append("post[content]", this.content);
      post.append("post[user_id]", this.user.id);
      if (this.tag !== null) {
        post.append("post[tag]", this.tag);
      }
      if (this.privacy !== null) {
        post.append("post[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        post.append("post[image]", this.imageFile);
      }
      this.$emit("submitPost", post);
      this.content = "";
      this.tag = "";
      this.privacy = "";
      this.image = [];
      this.$refs.addPostObserver.reset();
    },
  },
};
</script>

<style>
/* scoped外したので他の所にもきくはず */
/* 共通スタイル作ってそこに移したい */
.error-message {
  color: red;
}
</style>