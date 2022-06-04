<template>
  <div>
    <v-card @click="showGoal(goal)">
      <v-card-actions>
        <UserCard :user="goal.user" />
        {{ $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm") }}
        <v-spacer></v-spacer>
        <v-icon
          v-on:click.stop
          v-if="user.id === goal.user_id || user.admin"
          @click="handleSubmitDeleteGoal(goal)"
          >delete</v-icon
        >
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
      <v-divider></v-divider>
      <v-card-actions>
        <span v-if="goal.privacy" class="red--text font-weight-bold mr-2"
          >Private</span
        >
        <span class="mr-2"
          ><v-icon>mdi-comment-outline</v-icon>{{ goalCommentCount }}</span
        >
        <span v-if="goal.achieve_status" class="green--text font-weight-bold">
          達成
        </span>
        <span v-else class="red--text font-weight-bold">未達成</span>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: ["goal"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    goalCommentCount() {
      return this.goal.goal_comments.length;
    },
  },
  methods: {
    async handleSubmitDeleteGoal(goal) {
      this.$emit("submitDeleteGoal", goal);
    },
    showGoal(goal) {
      this.$router.push(`/goals/${goal.id}`);
    },
  },
};
</script>
