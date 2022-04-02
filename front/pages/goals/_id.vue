<template>
  <div>
    <h1>目標詳細</h1>
    <p>ここでカレンダーにメモ書く</p>
  </div>
</template>

<script>
// import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "目標詳細",
    };
  },
  data() {
    return {
      //
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    //
  },
  methods: {
    //
  },
};
</script>
