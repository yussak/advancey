<template>
  <div>
    <v-card>
      <v-card-actions>
        <UserCard :user="goal.user" />
        <p class="mx-2">
          {{
            $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm")
          }}に追加
        </p>
        <p v-if="goal.achieve_status" class="green--text font-weight-bold">
          達成済み
        </p>
        <p v-else class="red--text font-weight-bold">未達成</p>
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
        style="max-width: 100%; max-height: 300px"
        alt="目標画像"
      />
      <v-card-actions>
        <v-icon
          v-if="user.id === goal.user_id || user.admin"
          @click="handleSubmitDeleteGoal(goal)"
          >delete</v-icon
        >
        <v-icon @click="showGoal(goal)">mdi-magnify</v-icon>
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
  },
  methods: {
    async handleSubmitDeleteGoal(goal) {
      this.$emit("submitDeleteGoal", goal);
    },
    async showGoal(goal) {
      this.$router.push(`/goals/${goal.id}`);
    },
  },
};
</script>
