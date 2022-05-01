<template>
  <div>
    <h2 class="text-center">目標を建てる</h2>
    <GoalForm @submit="addGoal" class="mb-4" />
    <h2 class="text-center">目標一覧</h2>
    <!-- ページネーションほしい -->
    <v-row>
      <v-col v-for="goal in goals" :key="goal.id" :cols="12">
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
          <v-card-title>{{ goal.title }}</v-card-title>
          <v-card-subtitle
            v-if="goal.content"
            class="text-truncate"
            style="max-width: 60%"
            >{{ goal.content }}
          </v-card-subtitle>
          <v-card-text>
            <img
              v-if="goal.image_url"
              :src="goal.image_url"
              style="max-width: 100%; max-height: 300px"
              alt="目標画像"
            />
          </v-card-text>
          <v-card-actions>
            <v-icon v-if="user.id === goal.user_id" @click="deleteGoal(goal)"
              >delete</v-icon
            >
            <v-icon @click="showGoal(goal)">mdi-magnify</v-icon>
          </v-card-actions>
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
    async showGoal(goal) {
      this.$router.push(`/goals/${goal.id}`);
    },
  },
};
</script>
