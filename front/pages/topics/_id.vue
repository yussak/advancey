<template>
  <div>
    <h1>詳細</h1>
    {{ topic.title }}
    <a @click="$router.back()">もどる</a>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      topic: [],
      title: "",
    };
  },
  mounted() {
    // title contentなど含めてcontentsとする
    this.fetchTopicContents();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    fetchTopicContents() {
      const url = `/v1/topics/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.topic = res.data;
      });
    },
  },
};
</script>
