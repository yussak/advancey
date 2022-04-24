<template>
  <div>
    <v-card>
      <v-card-actions>
        <UserCard :user="post.user" />
        <v-card-text>
          {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
          に投稿
        </v-card-text>
      </v-card-actions>
      <v-card-title v-text="post.content"></v-card-title>
      <v-card-text>
        <img
          v-if="post.image_url"
          :src="post.image_url"
          style="max-width: 100%"
          alt="メモ画像"
        />
      </v-card-text>
      <v-card-actions>
        <p v-if="post.privacy" class="red--text font-weight-bold">Private</p>
        <v-icon @click="deleteItem(post)">delete</v-icon>
        <v-icon @click="showItem(post)">mdi-magnify</v-icon>
        <v-icon v-if="post.tag">mdi-tag</v-icon>
        {{ post.tag }}
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["post"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async showItem(post) {
      this.$router.push(`/posts/${post.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        // 一覧から削除するよう修正したい
        // const posts = this.user.posts.filter((post) => {
        //   return post.id !== item.id;
        // });
        // const newUser = {
        //   ...this.user,
        //   posts,
        // };
        // 削除フラッシュ表示する（成功時）
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
        // this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>
