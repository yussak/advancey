<template>
  <div>
    <p>各ユーザーの目標一覧へのリンク</p>
    <div v-for="user in users" :key="user.id">
      <div class="d-flex">
        <p>{{ user.name }}、id:{{ user.id }}</p>
        <nuxt-link :to="`users/${user.id}/user_goals/`">link</nuxt-link>
        {{ user.goals }}
      </div>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "皆の目標一覧",
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
      users: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchUserList();
  },
  methods: {
    fetchUserList() {
      const url = "v1/users";
      axios
        .get(url)
        .then((res) => {
          this.users = res.data;
          console.log(res.data);
          this.goals = res.data.goals;
        })
        .catch((err) => {
          console.log(err);
        });
    },
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
