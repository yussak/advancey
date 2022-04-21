<template>
  <div style="text-align: center">
    <h2>このページは閲覧出来ません</h2>
    <nuxt-link :to="`/`">Topページへ戻る</nuxt-link>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "このページは閲覧出来ません",
    };
  },
};
</script>