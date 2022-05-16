<template>
  <div>
    <h2>非公開目標一覧</h2>
    <p>このページは自分だけが閲覧可能です</p>
    <v-icon @click="$router.back()">mdi-arrow-left-bottom</v-icon>
    <v-row dense>
      <v-col>
        <v-card>
          <v-tabs grow>
            <v-tab v-for="title in goalTitles" :key="title.id">
              {{ title.name }}
            </v-tab>
            <v-tab-item>
              <v-row dense>
                <v-col v-if="!private_goals.length">目標がありません</v-col>
                <v-col
                  v-else
                  v-for="goal in private_goals"
                  :key="goal.id"
                  cols="12"
                  md="6"
                >
                  <GoalCard :goal="goal" @submitDeleteGoal="deleteGoal" />
                </v-col>
              </v-row>
            </v-tab-item>
            <v-tab-item>
              <v-row dense>
                <v-col v-if="!unachieved_goals.length">目標がありません</v-col>
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
                <v-col v-if="!achieved_goals.length">目標がありません</v-col>
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
    this.fetchPrivateGoalList();
  },
  methods: {
    fetchPrivateGoalList() {
      axios
        .get(`/v1/users/${this.$route.params.userId}/private_goals`)
        .then((res) => {
          this.private_goals = res.data.goals;
          this.unachieved_goals = res.data.unachieved_goals;
          this.achieved_goals = res.data.achieved_goals;
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
