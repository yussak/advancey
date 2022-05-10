<template>
  <div>
    <nuxt-link :to="`/posts/${post.id}`" style="text-decoration: none">
      <v-card>
        <v-card-actions>
          <UserCard :user="post.user" />
          <v-card-text>
            {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
          </v-card-text>
          <v-spacer></v-spacer>
          <v-icon
            v-if="user.id === post.user_id || user.admin"
            @click="handleSubmitDeletePost(post)"
            >delete</v-icon
          >
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
          <v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}
          <v-icon v-if="post.tag">mdi-tag</v-icon>
          {{ post.tag }}
        </v-card-actions>
      </v-card>
    </nuxt-link>
  </div>
</template>

<script>
export default {
  props: ["post"],
  data() {
    return {
      postMenu: false,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    postCommentCount() {
      return this.post.post_comments.length;
    },
  },
  methods: {
    async handleSubmitDeletePost(post) {
      this.$emit("submitDeletePost", post);
    },
  },
};
</script>

<style>
.test {
  z-index: 100;
}
</style>