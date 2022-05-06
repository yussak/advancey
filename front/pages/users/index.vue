<template>
  <div>
    <h2 class="text-center mb-4">ユーザー一覧</h2>
    <div class="d-flex align-center">
      <UserCard :user="currentUser" />
      <p v-if="currentUser.admin" class="ml-2 blue--text font-weight-bold">
        admin<v-icon class="blue--text">mdi-crown</v-icon>
      </p>
    </div>
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
      users: [],
      admin: false,
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
    // ユーザー一覧から自分を除外
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
      axios
        .get(`v1/users`)
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
