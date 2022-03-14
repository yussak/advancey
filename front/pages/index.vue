<template>
  <div v-if="user">
    <p>
      <v-avatar>
        <!-- アイコン設定がないとき→条件は後で追加 -->
        <img
          v-if="!user.avatar_url"
          src="~assets/default-user-icon.png"
          style="width: 45px; height: 45px"
        />
      </v-avatar>
      <span style="font-weight: bold">{{ user.name }}</span
      >さんとしてログイン中
    </p>
    <AddPost @submit="addPost" />
    <PostList :posts="user.posts" />
  </div>
</template>

<script>
import AddPost from "@/components/AddPost";
import PostList from "@/components/PostList";
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "ホーム",
    };
  },
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
      // async addPost(post, config) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const { data } = await axios.post("/v1/posts", post, config);
      // ここで新しい投稿読み込んでる（消したらリロードせんと追加されない
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
