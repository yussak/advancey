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
        <v-card-text>
          {{ $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm") }}
        </v-card-text>
      </v-card-actions>
      <v-card-title>タイトル</v-card-title>
      <v-card-text>{{ topic.title }}</v-card-text>
      <v-card-title v-if="topic.content">詳細</v-card-title>
      <v-card-text v-if="topic.content" class="br-content">{{
        topic.content
      }}</v-card-text>
      <v-card-text>
        <img
          v-if="topic.image_url"
          :src="topic.image_url"
          style="max-width: 100%"
          alt="質問画像"
        />
      </v-card-text>
      <v-card-actions>
        <span class="mr-2"
          ><v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}</span
        >
        <span v-if="topic.solve_status" class="green--text font-weight-bold">
          解決済み
        </span>
        <span v-else class="red--text font-weight-bold">受付中</span>
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
  props: ["user", "topic"],
  computed: {
    postCommentCount() {
      return this.topic.topic_comments.length;
    },
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>