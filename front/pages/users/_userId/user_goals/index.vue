<template>
  <div>
    <h1>
      <span>{{ goalUser.name }}</span
      >の目標一覧
    </h1>
    <p>そのユーザーの目標一覧</p>
    <ValidationObserver v-slot="{ invalid }" ref="addGoalObserver">
      <v-form v-if="currentUser.id === goalUser.id">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="達成したいこと"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="content"
              counter="100"
              label="達成したいことを決めましょう！"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:200"
            name="理由"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="reason"
              counter="200"
              label="なぜ達成したいかを書いてみましょう！"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:200"
            name="やること"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="todo"
              counter="200"
              label="やること"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加"
            @change="setImage"
          ></v-file-input>
          <v-btn :disabled="invalid" @click="addGoal">目標を立てる</v-btn>
        </v-container>
      </v-form>
    </ValidationObserver>
    <ul>
      <li v-for="goal in goals" :key="goal.id">
        <nuxt-link :to="`/goals/${goal.id}`">
          {{ goal.content }}
        </nuxt-link>
        {{ $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm") }}
        username: {{ goal.user.name }}
        <v-icon v-if="goal.user_id === currentUser.id" @click="deleteGoal(goal)"
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
      goalUser: [],
      goals: [],
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchUserInfo();
  },
  methods: {
    fetchUserInfo() {
      const url = `/v1/users/${this.$route.params.userId}`;
      axios.get(url).then((res) => {
        this.goalUser = res.data.user;
        this.goals = res.data.goals;
      });
    },
    setImage(e) {
      this.imageFile = e;
    },
    addGoal() {
      const goal = new FormData();
      goal.append("goal[user_id]", this.currentUser.id);
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
          // this.fetchGoalList();
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
      this.$refs.addGoalObserver.reset();
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
