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
        <v-icon
          v-if="user.id === post.user_id || user.admin"
          @click="handleSubmitDeletePost(post)"
          >delete</v-icon
        >
        <v-icon @click="showPost(post)">mdi-magnify</v-icon>
        <v-icon v-if="post.tag">mdi-tag</v-icon>
        {{ post.tag }}
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: ["post"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async showPost(post) {
      this.$router.push(`/posts/${post.id}`);
    },
    async handleSubmitDeletePost(post) {
      this.$emit("submitDeletePost", post);
    },
  },
};
</script>
