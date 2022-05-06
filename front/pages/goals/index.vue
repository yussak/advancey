<template>
  <div>
    <h2 class="text-center">目標を立てる</h2>
    <GoalForm @submit="addGoal" class="mb-4" />
    <h2 class="text-center">目標一覧</h2>
    <!-- ページネーションほしい -->
    <v-card>
      <v-tabs grow>
        <v-tab v-for="title in goalTitles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(goals && goals.length)">目標がありません</v-col>
            <v-col v-else v-for="goal in goals" :key="goal.id" cols="12">
              <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
            </v-col>
          </v-row>
        </v-tab-item>
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(goals && unachieved_goals.length)"
              >目標がありません</v-col
            >
            <v-col
              v-else
              v-for="goal in unachieved_goals"
              :key="goal.id"
              cols="12"
            >
              <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
            </v-col>
          </v-row>
        </v-tab-item>
        <v-tab-item>
          <v-row dense>
            <v-col v-if="!(goals && achieved_goals.length)"
              >目標がありません</v-col
            >
            <v-col
              v-else
              v-for="goal in achieved_goals"
              :key="goal.id"
              cols="12"
            >
              <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
            </v-col>
          </v-row>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import GoalCard from "@/components/GoalCard";

export default {
  head() {
    return {
      title: "目標一覧",
    };
  },
  components: {
    GoalCard,
  },
  data() {
    return {
      goals: [],
      unachieved_goals: [],
      achieved_goals: [],
      goalTitles: [{ name: "全て" }, { name: "未達成" }, { name: "達成済み" }],
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
      axios
        .get(`/v1/goals`)
        .then((res) => {
          this.goals = res.data.goals;
          this.unachieved_goals = res.data.unachieved_goals;
          this.achieved_goals = res.data.achieved_goals;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addGoal(goal) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
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
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${goal.id}`)
          .then(() => {
            this.fetchGoalList();
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
