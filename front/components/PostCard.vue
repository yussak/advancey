<template>
  <div>
    <v-card @click="showPost(post)">
      <v-card-actions>
        <UserCard :user="post.user" />
        {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
        <v-icon
          v-on:click.stop
          v-if="user.id === post.user_id || user.admin"
          @click="handleSubmitDeletePost(post)"
          >delete</v-icon
        >
      </v-card-actions>
      <v-card-title v-text="post.content" class="br-content"></v-card-title>
      <v-card-text>
        <img
          v-if="post.image_url"
          :src="post.image_url"
          style="max-width: 100%"
          alt="メモ画像"
        />
      </v-card-text>
      <v-card-actions>
        <v-card-text>
          <span v-if="post.privacy" class="red--text font-weight-bold"
            >Private</span
          >
          <span
            ><v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}</span
          >
          <span>
            <v-icon v-if="post.tag">mdi-tag</v-icon>
            {{ post.tag }}</span
          >
        </v-card-text>
      </v-card-actions>
    </v-card>
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
    showPost(post) {
      this.$router.push(`/posts/${post.id}`);
    },
  },
};
</script>