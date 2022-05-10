<template>
  <header>
    <!-- バーガー中身 -->
    <v-navigation-drawer
      v-model="drawer"
      :clipped="clipped"
      fixed
      app
      disable-resize-watcher
    >
      <LinkList />
    </v-navigation-drawer>
    <!-- ヘッダー -->
    <v-app-bar :clipped-left="clipped" fixed app>
      <div class="header_wrapper">
        <div class="header_left">
          <!-- バーガーアイコン -->
          <v-app-bar-nav-icon
            @click.stop="drawer = !drawer"
            class="d-md-none"
          />
          <!-- sm以下で非表示（vuetifyのクラス） -->
          <nuxt-link :to="`/`" class="logo hidden-sm-and-down">
            Advancey
          </nuxt-link>
        </div>
        <div class="header_right d-flex align-center">
          <UserCard v-if="user" :user="user" />
          <v-card-text
            v-if="user && user.admin"
            class="pa-0 blue--text font-weight-bold"
          >
            admin<v-icon class="blue--text">mdi-crown</v-icon>
          </v-card-text>
        </div>
      </div>
    </v-app-bar>
  </header>
</template>

<script>
import LinkList from "@/components/LinkList";
import UserCard from "@/components/UserCard";

export default {
  components: {
    LinkList,
    UserCard,
  },
  data() {
    return {
      drawer: false,
      clipped: false,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
};
</script>

<style>
header {
  z-index: 10;
}
.header_wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
}
</style>