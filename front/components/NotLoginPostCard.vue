<template>
  <div>
    <v-card @click="openRequestLoginDialog">
      <v-card-actions>
        <v-avatar>
          <img
            v-if="user.image_url"
            :src="user.image_url"
            alt="ユーザーアイコン"
          />
          <img
            v-else
            src="~assets/default-user-icon.png"
            alt="ユーザーアイコン"
          />
        </v-avatar>
        <v-card-text class="font-weight-bold">{{ user.name }}</v-card-text>
        <v-spacer></v-spacer>
        <v-card-text>
          {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
        </v-card-text>
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
        <span class="mr-2"
          ><v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}</span
        >
        <span><v-icon v-if="post.tag">mdi-tag</v-icon>{{ post.tag }}</span>
      </v-card-actions>
    </v-card>
    <RequestLoginDialog ref="requestLoginDialog" />
  </div>
</template>

<script>
import RequestLoginDialog from "@/components/RequestLoginDialog";

export default {
  components: {
    RequestLoginDialog,
  },
  props: ["user", "post"],
  computed: {
    postCommentCount() {
      return this.post.post_comments.length;
    },
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>
