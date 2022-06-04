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
          {{ $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm") }}
        </v-card-text>
      </v-card-actions>
      <v-card-title class="subtitle-1 pb-2">達成したいこと</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.content }} </v-card-text>
      <v-card-title class="subtitle-1 pb-2">理由</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.reason }}</v-card-text>
      <v-card-title class="subtitle-1 pb-2">そのためにやること</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.todo }}</v-card-text>
      <v-card-text v-if="goal.image_url" class="text-center">
        <img
          :src="goal.image_url"
          style="max-width: 100%; max-height: 200px"
          alt="目標画像"
        />
      </v-card-text>
      <v-card-actions>
        <span><v-icon>mdi-comment-outline</v-icon>{{ postCommentCount }}</span>
        <span
          v-if="goal.achieve_status"
          class="green--text font-weight-bold ml-2"
        >
          達成
        </span>
        <span v-else class="red--text font-weight-bold ml-2">未達成</span>
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
  props: ["user", "goal"],
  computed: {
    postCommentCount() {
      return this.goal.goal_comments.length;
    },
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>
