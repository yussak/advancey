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
            <!-- 中身があってもリロード時空のテキストが一瞬表示されてしまうの要修正 -->
            <v-col v-if="!(posts && revPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in revPosts" :key="post.id" :cols="6">
              <PostCard :post="post" />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 自分のメモ -->
        <v-tab-item>
          <v-card>
            <v-row dense>
              <v-col v-if="!(posts && revPosts.length)">メモがありません</v-col>
              <v-col v-else v-for="post in revPosts" :key="post.id" :cols="6">
                <PostCard :post="post" />
              </v-col>
            </v-row>
          </v-card>
        </v-tab-item>
        <!-- 実践中 -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && doingPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in doingPosts" :key="post.id" :cols="6">
              <PostCard :post="post" />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 実践したい -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && wantPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in wantPosts" :key="post.id" :cols="6">
              <PostCard :post="post" />
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 身についた -->
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(posts && masterPosts.length)"
              >メモがありません</v-col
            >
            <v-col v-else v-for="post in masterPosts" :key="post.id" :cols="6">
              <PostCard :post="post" />
            </v-col>
          </v-row>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-card-text> タブ6の内容をここに記述します。 </v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import PostCard from "@/components/PostCard";

export default {
  props: ["posts"],
  components: {
    PostCard,
  },
  data() {
    return {
      search: "",
      titles: [
        { name: "全部のメモ" },
        { name: "自分のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
        { name: "いいね" },
      ],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    // myPosts allPosts作成予定
    revPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (post.user_id === this.user.id && post.privacy === false) {
            return true;
          }
        });
    },
    // タグ絞る＋若い投稿を上に表示+非公開投稿を除外
    doingPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "実践中"
          ) {
            return true;
          }
        });
    },
    wantPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "実践したい"
          ) {
            return true;
          }
        });
    },
    masterPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "身についた"
          ) {
            return true;
          }
        });
    },
  },
};
</script>

<style>
.user-link:hover {
  text-decoration: underline !important;
}
</style>
