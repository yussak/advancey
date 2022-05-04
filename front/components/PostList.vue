<template>
  <div>
    <h2 class="text-center">メモ一覧</h2>
    <v-card>
      <v-tabs grow>
        <!-- タイトル -->
        <v-tab v-for="title in titles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <!-- 全部のメモ -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && posts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in posts" :key="post.id" cols="12" md="6">
              <PostCard
                :post="post"
                @submitDeletePostToPostList="handleSubmitDeletePost"
              />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 実践中 -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && doing_posts.length)"
              >メモがありません</v-col
            >
            <v-col
              v-else
              v-for="post in doing_posts"
              :key="post.id"
              cols="12"
              md="6"
            >
              <PostCard
                :post="post"
                @submitDeletePost="handleSubmitDeletePost"
              />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 実践したい -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && want_posts.length)">メモがありません</v-col>
            <v-col
              v-else
              v-for="post in want_posts"
              :key="post.id"
              cols="12"
              md="6"
            >
              <PostCard
                :post="post"
                @submitDeletePost="handleSubmitDeletePost"
              />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- やって良かった -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && master_posts.length)"
              >メモがありません</v-col
            >
            <v-col
              v-else
              v-for="post in master_posts"
              :key="post.id"
              cols="12"
              md="6"
            >
              <PostCard
                :post="post"
                @submitDeletePost="handleSubmitDeletePost"
              />
            </v-col>
          </v-row>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import PostCard from "@/components/PostCard";

export default {
  props: [
    "posts",
    "doing_posts",
    "want_posts",
    "master_posts",
    "private_posts",
  ],
  components: {
    PostCard,
  },
  data() {
    return {
      titles: [
        { name: "全部のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "やって良かった" },
      ],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    handleSubmitDeletePost(post) {
      this.$emit("submitDeletePost", post);
    },
  },
};
</script>

<style>
.user-link:hover {
  text-decoration: underline !important;
}
</style>
