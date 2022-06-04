<template>
  <div>
    <h2 class="text-center mb-4">ユーザー一覧</h2>
    <v-list color="transparent">
      <v-list-item
        @click="showUser(currentUser)"
        v-on:click.stop
        class="user-link"
      >
        <v-avatar>
          <img
            v-if="currentUser.image_url"
            :src="currentUser.image_url"
            alt="ユーザーアイコン"
          />
          <img
            v-else
            src="~assets/default-user-icon.png"
            alt="ユーザーアイコン"
          />
        </v-avatar>
        <v-list-item-content class="ml-4">
          <v-list-item-title
            >{{ currentUser.name }}
            <span
              v-if="currentUser.admin"
              class="blue--text font-weight-bold ml-2"
            >
              admin
            </span></v-list-item-title
          >
          <v-list-item-subtitle
            v-html="currentUser.profile"
            class="body-2"
          ></v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
    </v-list>
    <v-list v-for="user in usersExceptMyself" :key="user.id">
      <v-list-item @click="showUser(user)" v-on:click.stop class="user-link">
        <v-avatar>
          <img
            v-if="user.image_url"
            :src="user.image_url"
            alt="ユーザーアイコン"
          />
          <img
            v-else
            src="~assets/default-user-icon.png"
            alt="ユーザーアイコン"
          />
        </v-avatar>
        <v-list-item-content class="ml-4">
          <v-list-item-title
            >{{ user.name }}
            <span v-if="user.admin" class="blue--text font-weight-bold ml-2">
              admin
            </span></v-list-item-title
          >
          <v-list-item-subtitle
            v-html="user.profile"
            class="body-2"
          ></v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-divider></v-divider>
    </v-list>
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
    showUser(user) {
      this.$router.push(`/users/${user.id}`);
    },
  },
};
</script>
