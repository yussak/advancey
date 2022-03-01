<template>
  <div>
    <h2>private_posts</h2>
    <p>このページの投稿は自分だけが閲覧可能です</p>
    <p style="color: red; font-weight: bold">
      他の人の投稿も見えてしまうので要対処<br />
      Rails側でuser絞ってからnuxtに渡そうとしたりNuxt側でcurrentUserのものだけ取得しようとしたがうまく行かず<br />
      自分の投稿＆非公開の投稿だけを表示したい（自分のだけに絞るので苦戦中）
    </p>
    <v-container fluid>
      <v-row dense>
        <!-- 空のときテキスト表示したい -->
        <!-- 自分の非公開だけ表示したい -->
        <!-- <v-col v-for="post in this.user.private_posts" :key="post.id" :cols="4"> -->
        <!-- <v-col v-for="post in user.privatePosts" :key="post.id" :cols="4"> -->
        <v-col v-for="post in private_posts" :key="post.id" :cols="4">
          <!-- 新しいのが下に追加されるので修正したい -->
          <v-card>
            <v-card-text
              v-if="post.privacy === true"
              style="color: red; font-weight: bold"
              >private</v-card-text
            >
            <v-card-text>{{ post.username }}</v-card-text>
            <v-card-title v-text="post.content"></v-card-title>
            <v-card-text>{{ post.created_at }}</v-card-text>
            <v-card-text>
              <!-- タグがある時だけアイコン表示 -->
              <v-icon v-if="post.tag !== ''">mdi-tag</v-icon>
              {{ post.tag }}</v-card-text
            >
            <v-icon @click="deleteItem(post)">delete</v-icon>
            <v-icon @click="showItem(post)">mdi-magnify</v-icon>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      private_posts: [],
      content: "",
    };
  },
  mounted() {
    this.fetchPrivatePosts();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    fetchPrivatePosts() {
      const url = `/v1/users/${this.user.id}/private_posts`;
      axios.get(url).then((res) => {
        this.private_posts = res.data;
        console.log(res.data);
      });
    },
  },
};
</script>
