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
    ></v-data-table>
  </v-card>
</template>

<script>
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
        { text: "ユーザー名", value: "username" },
      ],
    };
  },
};
</script>

<style>
</style>
