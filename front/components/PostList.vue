<template>
  <div>
    <h3 style="text-align: center">メモ一覧</h3>
    <v-container fluid>
      <v-row dense>
        <!-- 空のときテキスト表示したい -->
        <v-col v-for="post in posts" :key="post.id" :cols="4">
          <!-- 新しいのが下に追加されるので修正したい -->
          <v-card>
            <v-card-text>{{ post.username }}</v-card-text>
            <v-card-title v-text="post.content"></v-card-title>
            <v-card-text>{{ post.created_at }}</v-card-text>
            <v-card-text><v-icon>mdi-tag</v-icon>{{ post.tag }}</v-card-text>
            <v-icon @click="deleteItem(post)">delete</v-icon>
            <v-icon @click="showItem(post)">mdi-magnify</v-icon>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

    <v-card>
      <!-- タブ名 -->
      <!-- <v-tabs v-model="tab" background-color="transparent" grow>
        <v-tab v-for="item in items" :key="item.tab">
          {{ item.tab }}
        </v-tab>
      </v-tabs> -->

      <!-- タブ中身 -->
      <!-- <v-tabs-items v-model="tab">
        <v-tab-item v-for="item in items" :key="item.tab">
          {{ item.content }}
        </v-tab-item>
      </v-tabs-items> -->
    </v-card>
    <!-- <v-card>
      <v-text-field
        v-model="search"
        label="Search"
        single-line
        hide-details
      ></v-text-field>
      <v-data-table
        :headers="headers"
        :items="posts"
        :search="search"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <template v-slot:[`item.tag`]="{ item }">
          <p v-if="item.tag === ''">なし</p>
          <p v-else>{{ item.tag }}</p>
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <v-icon small @click="deleteItem(item)">delete</v-icon>
          <v-icon small @click="showItem(item)">詳細</v-icon>
        </template>
      </v-data-table>
    </v-card> -->
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["posts"],
  data() {
    return {
      search: "",
      // headers: [
      //   {
      //     text: "タイトル",
      //     align: "left",
      //     sortable: false,
      //     value: "content",
      //   },
      //   {
      //     text: "タグ",
      //     value: "tag",
      //   },
      //   {
      //     text: "ユーザー名",
      //     value: "username",
      //   },
      //   {
      //     text: "投稿日",
      //     value: "created_at",
      //   },
      //   {
      //     text: "Actions",
      //     value: "action",
      //   },
      // ],
      tab: null,
      items: [
        { tab: "実践中", content: "実践中の投稿" },
        { tab: "実践したい", content: "実践したいの投稿" },
        { tab: "身についた", content: "身についたの投稿" },
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
      // 削除フラッシュ表示する（成功・失敗時）
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
