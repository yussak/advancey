<template>
  <div>
    <h1>投稿詳細ページです</h1>
    {{ post.content }}
    <form>
      <v-text-field
        v-model="content"
        label="content"
        data-vv-name="content"
        required
      ></v-text-field>
    </form>
    <button @click="update()">編集する</button>
    <a @click="$router.back()">もどる</a>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      content: "", //編集のため追加してみる
      post: [],
    };
  },
  mounted() {
    this.fetchContent();
  },
  //編集のため追加してみる
  computed: {
    params() {
      return {
        post: {
          content: this.content,
        },
      };
    },
  },
  methods: {
    fetchContent() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.post = res.data;
      });
    },
    update() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios
        .put(url, this.params)
        .then((res) => {
          this.fetchContent();
          // console.log("成功");
        })
        .catch((err) => {
          console.log("失敗");
        });
    },
  },
};
</script>
