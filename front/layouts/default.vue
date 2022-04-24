<template>
  <v-app>
    <div>
      <Success />
      <Loading />
    </div>

    <!-- ヘッダー -->
    <Header />
    <v-main class="blue-grey lighten-5">
      <v-container class="main">
        <v-row>
          <!-- サイドバー -->
          <v-col class="hidden-sm-and-down" cols="2">
            <LinkList />
          </v-col>
          <!-- メイン -->
          <v-col cols="12" md="10">
            <Nuxt />
          </v-col>
        </v-row>
      </v-container>
    </v-main>
    <v-footer app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import Header from "@/components/Header";
import LinkList from "@/components/LinkList";

export default {
  components: {
    Loading,
    Success,
    Header,
    LinkList,
  },
};
</script>

<style>
.logo {
  color: black !important;
  font-size: 30px !important;
  text-decoration: none !important;
}
.errors {
  color: red;
  margin-top: 20px;
}
.main {
  /* 幅は仮 */
  max-width: 1200px !important;
}
</style>