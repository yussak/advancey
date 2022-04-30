<template>
  <div>
    <h2 class="text-center mb-4">ユーザー一覧</h2>
    <UserCard :user="currentUser" />
    <v-row>
      <v-col v-for="user in usersExceptMyself" :key="user.id" :cols="12">
        <v-card>
          <UserCard :user="user" />
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "ユーザー一覧",
    };
  },
  data() {
    return {
      admin: false,
      users: [],
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
    // ユーザー一覧から自分を除外
    // rails側で制御したい
    usersExceptMyself() {
      return this.users.filter((user) => {
        if (user.id !== this.currentUser.id) {
          return true;
        }
      });
    },
  },
  mounted() {
    this.fetchUserList();
  },
  methods: {
    fetchUserList() {
      const url = "v1/users";
      axios
        .get(url)
        .then((res) => {
          this.users = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>
