<template>
  <div>
    <h1>ユーザー一覧</h1>
    <v-card>
      <v-data-table :headers="headers" :items="users"> </v-data-table>
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
      ],
    };
  },
  mounted() {
    this.fetchContents();
  },
  methods: {
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
