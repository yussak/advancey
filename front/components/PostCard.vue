<template>
  <div>
    <v-card @click="showPost(post)">
      <v-card-actions class="pb-0">
        <UserCard :user="post.user" />
        <v-spacer></v-spacer>
        <v-card-text>
          {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
        </v-card-text>
        <v-icon
          v-on:click.stop
          v-if="user.id === post.user_id || user.admin"
          @click="handleSubmitDeletePost(post)"
          >delete</v-icon
        >
      </v-card-actions>
      <v-card-title
        v-text="post.content"
        class="br-content body-1"
      ></v-card-title>
      <v-card-text v-if="post.image_url" class="text-center">
        <img
          :src="post.image_url"
          style="max-width: 100%; max-height: 200px"
          alt="メモ画像"
        />
      </v-card-text>
      <v-card-actions>
        <span v-if="post.privacy" class="red--text font-weight-bold mr-2"
          >Private</span
        >
        <span class="mr-2"
          ><v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}</span
        >
        <span v-if="post.tag">
          <v-icon>mdi-tag</v-icon>
          {{ post.tag }}</span
        >
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