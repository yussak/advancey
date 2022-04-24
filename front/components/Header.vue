<template>
  <div>
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
          <nuxt-link :to="`/`" class="logo hidden-sm-and-down" v-if="user">
            Advancey
          </nuxt-link>
          <div class="logo hidden-sm-and-down" v-else>Advancey</div>
        </div>
        <div class="header_right">
          <UserCard v-if="user" :user="user" />
        </div>
      </div>
    </v-app-bar>
  </div>
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
.header_wrapper {
  display: flex;
  justify-content: space-between;
  max-width: 1500px;
  width: 100%;
}
</style>