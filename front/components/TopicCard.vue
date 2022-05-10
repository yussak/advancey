<template>
  <div>
    <nuxt-link :to="`/topics/${topic.id}`" style="text-decoration: none">
      <v-card>
        <v-card-actions>
          <UserCard :user="topic.user" />
          <p class="mx-2">
            {{
              $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm")
            }}に追加
          </p>
          <v-spacer></v-spacer>
          <v-icon
            v-if="user.id === topic.user_id || user.admin"
            @click="handleSubmitDeleteTopic(topic)"
            >delete</v-icon
          >
        </v-card-actions>
        <v-card-title>タイトル</v-card-title>
        <v-card-text class="br-content">{{ topic.title }}</v-card-text>
        <v-card-title v-if="topic.content">詳細</v-card-title>
        <v-card-text v-if="topic.content" class="br-content">{{
          topic.content
        }}</v-card-text>
        <v-card-text>
          <img
            v-if="topic.image_url"
            :src="topic.image_url"
            style="max-width: 100%; height: auto"
            alt="質問画像"
          />
        </v-card-text>
        <v-card-actions>
          <v-card-text>
            <span
              ><v-icon>mdi-comment-outline</v-icon>{{ topicCommentCount }}</span
            >
            <span
              v-if="topic.solve_status"
              class="green--text font-weight-bold"
            >
              解決済み
            </span>
            <span v-else class="red--text font-weight-bold">受付中</span>
          </v-card-text>
        </v-card-actions>
      </v-card>
    </nuxt-link>
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
  },
};
</script>