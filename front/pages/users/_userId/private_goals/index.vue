<template>
  <div>
    <h2>非公開目標一覧</h2>
    <p>このページは自分だけが閲覧可能です</p>
    <v-icon @click="$router.back()">mdi-arrow-left-bottom</v-icon>
    <v-row dense>
      <!-- <v-col v-if="!(goal && private_goals.length)">目標がありません</v-col> -->
      <!-- v-else -->
      <v-col v-for="goal in private_goals" :key="goal.id" cols="12" md="6">
        <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
      </v-col>
    </v-row>
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "非公開目標一覧",
    };
  },
  middleware: "handle-user-privategoals",
  data() {
    return {
      private_goals: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchPrivateGoalList();
  },
  methods: {
    fetchPrivateGoalList() {
      axios
        .get(`/v1/users/${this.$route.params.userId}/private_goals`)
        .then((res) => {
          this.private_goals = res.data.goals;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteGoal(goal) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${goal.id}`)
          .then(() => {
            this.fetchPrivateGoalList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "目標を削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>
