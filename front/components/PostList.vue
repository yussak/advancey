<template>
  <v-card>
    <v-card-content>
      投稿一覧
      <v-spacer></v-spacer>
      <v-text-field
        v-model="search"
        label="Search"
        single-line
        hide-details
      ></v-text-field>
    </v-card-content>
    <v-data-table
      :headers="headers"
      :items="posts"
      :search="search"
      :sort-by="['created_at']"
      :sort-desc="[true]"
    >
      <template v-slot:[`item.action`]="{ item }">
        <v-icon small @click="deleteItem(item)">delete</v-icon>
        <v-icon small @click="showItem(item)">詳細</v-icon>
      </template>
    </v-data-table>
  </v-card>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["posts"],
  data() {
    return {
      search: "",
      headers: [
        {
          text: "タイトル",
          align: "left",
          sortable: false,
          value: "content",
        },
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "投稿日",
          value: "created_at",
        },
        {
          text: "Actions",
          value: "action",
        },
      ],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        const posts = this.user.posts.filter((post) => {
          return post.id !== item.id;
        });
        const newUser = {
          ...this.user,
          posts,
        };
        this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>

<style>
</style>
