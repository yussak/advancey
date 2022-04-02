<template>
  <div>
    <h1>
      <span>{{ user.name }}</span
      >の目標一覧
    </h1>

    <v-row>
      <v-col cols="6">
        <v-form>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="content"
                  counter="100"
                  label="達成したいことを決めましょう！"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-textarea
                  v-model="reason"
                  counter="100"
                  label="なぜ達成したいかを書いてみましょう！"
                  required
                ></v-textarea>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="todo"
                  counter="100"
                  label="やること"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="period"
                  counter="100"
                  label="期間（日）を数字で入力してください"
                  required
                  type="number"
                ></v-text-field>
              </v-col>
            </v-row>
            <!-- <v-row>
              <v-col cols="12" md="8">
                <v-file-input
                  accept="image/*"
                  label="画像を追加（任意）"
                ></v-file-input>
              </v-col>
            </v-row> -->
            <v-row>
              <v-col cols="12">
                <v-btn @click="addGoal">目標を立てる</v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-form>
      </v-col>
    </v-row>

    <p>若いのを上にしたい</p>
    <ul>
      <li v-for="goal in goals" :key="goal.id" style="list-style: none">
        <nuxt-link :to="`/goals/${goal.id}`">{{ goal.content }} </nuxt-link>
        <!-- {{ goal.created_at }} -->
        <v-icon @click="deleteGoal(goal)">delete</v-icon>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "目標一覧", //ユーザー名＋さんの目標一覧としたい
      // title: this.user.name + "の目標一覧", //ユーザー名＋さんの目標一覧としたい
      // →ここに書くと一瞬undefinedの目標一覧」になる
    };
  },
  data() {
    return {
      goals: [],
      content: "",
      reason: "",
      todo: "",
      period: "",
      // user_id: "", //いらなかった→topicでも不要なら消す
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
    addGoal() {
      const url = `/v1/goals/`;
      axios
        .post(url, {
          user_id: this.user.id,
          content: this.content,
          reason: this.reason,
          todo: this.todo,
          period: this.period,
        })
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
      this.content = "";
      this.reason = "";
      this.todo = "";
      this.period = "";
    },
    fetchGoalList() {
      const url = `/v1/goals`;
      axios.get(url).then((res) => {
        this.goals = res.data;
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
