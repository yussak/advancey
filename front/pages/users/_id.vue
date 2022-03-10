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
    <!-- ユーザーページでは全部の投稿は表示しないよう変更 -->
    <PostList :posts="user.posts" />
  </div>
</template>

<script>
import PostList from "@/components/PostList";
import axios from "@/plugins/axios";

export default {
  components: {
    PostList,
  },
  data() {
    return {
      user: [],
      posts: [],
    };
  },
  mounted() {
    this.fetchUserInfo();
  },
  methods: {
    fetchUserInfo() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
      });
    },
  },
};
</script>
