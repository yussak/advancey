<template>
  <div>
    <nuxt-link :to="`/goals/${goal.id}`" style="text-decoration: none">
      <v-card>
        <v-card-actions>
          <UserCard :user="goal.user" />
          <p class="mx-2">
            {{
              $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm")
            }}に追加
          </p>
          <v-spacer></v-spacer>
          <v-icon
            v-if="user.id === goal.user_id || user.admin"
            @click="handleSubmitDeleteGoal(goal)"
            >delete</v-icon
          >
        </v-card-actions>
        <v-card-title>達成したいこと</v-card-title>
        <v-card-text>{{ goal.content }} </v-card-text>
        <v-card-title>理由</v-card-title>
        <v-card-text>{{ goal.reason }}</v-card-text>
        <v-card-title>そのためにやること</v-card-title>
        <v-card-text>{{ goal.todo }}</v-card-text>
        <img
          v-if="goal.image_url"
          :src="goal.image_url"
          style="width: 100%; height: auto"
          alt="目標画像"
        />
        <v-card-actions>
          <v-card-text>
            <span
              ><v-icon>mdi-comment-outline</v-icon>{{ goalCommentCount }}</span
            >
            <span
              v-if="goal.achieve_status"
              class="green--text font-weight-bold"
            >
              達成済み
            </span>
            <span v-else class="red--text font-weight-bold">未達成</span>
          </v-card-text>
        </v-card-actions>
      </v-card>
    </nuxt-link>
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
  },
};
</script>
