<template>
  <div>
    <h1>ユーザー詳細</h1>
    <v-avatar>
      <!-- アイコン設定がないとき→条件は後で追加 -->
      <img
        src="~assets/default-user-icon.png"
        style="width: 45px; height: 45px"
      />
    </v-avatar>
    <span style="font-weight: bold">{{ user.name }}</span
    >さん
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
