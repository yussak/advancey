<template>
  <header>
    <!-- バーガー中身 -->
    <v-navigation-drawer
      v-model="drawer"
      :clipped="clipped"
      fixed
      app
      right
      disable-resize-watcher
    >
      <LinkList />
    </v-navigation-drawer>
    <!-- ヘッダー -->
    <v-app-bar :clipped-left="clipped" fixed app>
      <div class="header_wrapper">
        <div class="header_left">
          <nuxt-link :to="`/`" class="logo d-flex align-center">
            <img src="~assets/logo.png" alt="ロゴ" width="50" />
            Advancey
          </nuxt-link>
        </div>
        <div class="header_right d-flex align-center">
          <!-- バーガーアイコン -->
          <v-app-bar-nav-icon
            @click.stop="drawer = !drawer"
            class="d-md-none"
          />
          <GuestLoginButton v-if="!user" class="hidden-sm-and-down" />
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