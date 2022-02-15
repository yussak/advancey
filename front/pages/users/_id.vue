<template>
  <div>
    <h1>ユーザー詳細</h1>
    ユーザー名：{{ user.name }}
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      user: [],
    };
  },
  mounted() {
    this.fetchContent();
  },
  methods: {
    fetchContent() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
      });
    },
  },
};
</script>
