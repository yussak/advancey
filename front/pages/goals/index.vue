<template>
  <div>
    <h1>
      <span>{{ user.name }}</span
      >の目標一覧
    </h1>
    <p>今のルーティングだと他の人の一覧見れないので修正</p>

    <!-- 自分の一覧だけでフォーム表示したい→まず他の人の一覧見れるようにしてから -->
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
              <v-col cols="12" md="8">
                <v-file-input
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-btn @click="addGoal">目標を立てる</v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-form>
      </v-col>
    </v-row>

    <ul>
      <li v-for="goal in reverseGoals" :key="goal.id" style="list-style: none">
        <nuxt-link :to="`/goals/${goal.id}`">{{ goal.content }} </nuxt-link>
        {{ $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm") }}

        <v-icon v-if="goal.user_id === user.id" @click="deleteGoal(goal)"
          >delete</v-icon
        >
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
      image: [],
      imageFile: null,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    reverseGoals() {
      return this.goals.slice().reverse();
    },
  },
  mounted() {
    this.fetchGoalList();
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    addGoal() {
      const goal = new FormData();
      goal.append("goal[user_id]", this.user.id);
      goal.append("goal[content]", this.content);
      goal.append("goal[reason]", this.reason);
      goal.append("goal[todo]", this.todo);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      if (this.imageFile !== null) {
        goal.append("goal[image]", this.imageFile);
      }
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
      this.content = "";
      this.reason = "";
      this.todo = "";
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
