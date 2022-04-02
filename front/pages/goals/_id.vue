<template>
  <div>
    <h1>目標詳細</h1>
    <p>ここでカレンダーにメモ書く</p>
    <p>{{ goal.content }}</p>
    <p>{{ goal.reason }}</p>
    <p>{{ goal.todo }}</p>
    <p>{{ goal.period }}</p>
    <nuxt-link :to="`/goals/`">目標一覧に戻る</nuxt-link>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "目標詳細",
    };
  },
  data() {
    return {
      goal: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchGoalInfo();
  },
  methods: {
    fetchGoalInfo() {
      const url = `/v1/goals/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.goal = res.data;
      });
    },
  },
};
</script>
