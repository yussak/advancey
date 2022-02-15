<template>
  <div>
    <h1>ユーザー一覧</h1>
    <v-card>
      <v-data-table :headers="headers" :items="users">
        <template v-slot:[`item.action`]="{ item }">
          <v-icon small @click="showItem(item)">詳細</v-icon>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      users: [],
      headers: [
        {
          text: "username",
          value: "name",
        },
        {
          text: "Actions",
          value: "action",
        },
      ],
    };
  },
  mounted() {
    this.fetchContents();
  },
  methods: {
    async showItem(item) {
      this.$router.push(`/users/${item.id}`);
    },
    fetchContents() {
      const url = "v1/users";
      axios
        .get(url)
        .then((res) => {
          console.log(res.data);
          this.users = res.data;
        })
        .catch((err) => {
          console.log("失敗");
        });
    },
  },
};
</script>
