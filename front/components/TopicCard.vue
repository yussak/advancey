<template>
  <div>
    <v-card @click="showTopic(topic)">
      <v-card-actions>
        <UserCard :user="topic.user" />
        <v-card-text>
          {{ $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm") }}
        </v-card-text>
        <v-spacer></v-spacer>
        <v-icon
          v-on:click.stop
          v-if="user.id === topic.user_id || user.admin"
          @click="handleSubmitDeleteTopic(topic)"
          >delete</v-icon
        >
      </v-card-actions>
      <v-card-title class="subtitle-1 pb-2">タイトル</v-card-title>
      <v-card-text class="br-content body-1 pb-2">{{
        topic.title
      }}</v-card-text>
      <v-card-title v-if="topic.content" class="subtitle-1 body-1 pb-2"
        >詳細</v-card-title
      >
      <v-card-text v-if="topic.content" class="br-content pb-2">{{
        topic.content
      }}</v-card-text>
      <v-card-text v-if="topic.image_url" class="text-center">
        <img
          :src="topic.image_url"
          style="max-width: 100%; max-height: 200px"
          alt="質問画像"
        />
      </v-card-text>
      <v-divider></v-divider>
      <v-card-actions>
        <span class="mr-2"
          ><v-icon>mdi-comment-outline</v-icon>{{ topicCommentCount }}</span
        >
        <span v-if="topic.solve_status" class="green--text font-weight-bold">
          解決済み
        </span>
        <span v-else class="red--text font-weight-bold">受付中</span>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: ["topic"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    topicCommentCount() {
      return this.topic.topic_comments.length;
    },
  },
  methods: {
    async handleSubmitDeleteTopic(topic) {
      this.$emit("submitDeleteTopic", topic);
    },
    showTopic(topic) {
      this.$router.push(`/topics/${topic.id}`);
    },
  },
};
</script>