<template>
  <div>
    <h2>private_posts</h2>
    <p>このページの投稿は自分だけが閲覧可能です</p>
    <v-container fluid>
      <v-row dense>
        <!-- 空のときテキスト表示したい -->
        <!-- <v-col v-if="!(private_posts && private_posts.length)"
          >メモがありません</v-col
        > -->
        <v-col v-for="post in privatePosts" :key="post.id" :cols="4">
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
  head() {
    return {
      title: "非公開メモ一覧",
    };
  },
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
    privatePosts() {
      // これで自分＆非公開の投稿に絞れた
      return this.private_posts.filter((post) => {
        if (post.privacy === true && post.user_id === this.user.id) {
          return true;
        }
      });
    },
  },
  methods: {
    fetchPrivatePosts() {
      const url = `/v1/private_posts`;
      axios.get(url).then((res) => {
        this.private_posts = res.data;
      });
    },
  },
};
</script>
