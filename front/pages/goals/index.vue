<template>
  <div>
    <h2 class="text-center">目標を立てる</h2>
    <GoalForm @submit="addGoal" class="mb-4" />
    <h2 class="text-center">目標一覧</h2>
    <!-- ページネーションほしい -->
    <v-row>
      <v-col v-for="goal in goals" :key="goal.id" :cols="12">
        <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import GoalCard from "@/components/GoalCard";

export default {
  components: {
    GoalCard,
  },
  head() {
    return {
      title: "目標一覧",
    };
  },
  data() {
    return {
      goals: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchGoalList();
  },
  methods: {
    fetchGoalList() {
      const url = `/v1/goals`;
      axios.get(url).then((res) => {
        this.goals = res.data;
      });
    },
    async addGoal(goal) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      axios
        .post(`/v1/goals`, goal, config)
        .then(() => {
          this.fetchGoalList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "目標を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteGoal(goal) {
      const url = `/v1/goals/${goal.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchGoalList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "目標を削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
  },
};
</script>
