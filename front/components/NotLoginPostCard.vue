<template>
  <div>
    <v-card>
      <v-card-actions>
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
          <p class="font-weight-bold">{{ user.name }}</p>
        </v-card-actions>
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
        <v-icon @click="openRequestLoginDialog">mdi-magnify</v-icon>
        <v-icon v-if="post.tag">mdi-tag</v-icon>
        {{ post.tag }}
      </v-card-actions>
    </v-card>
    <RequestLoginDialog ref="requestLoginDialog" />
  </div>
</template>

<script>
import RequestLoginDialog from "@/components/RequestLoginDialog";

export default {
  props: ["user", "post"],
  components: {
    RequestLoginDialog,
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>
