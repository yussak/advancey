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
          <v-col cols="10">
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
/* カレントページでも色を変えない */
.theme--light.v-btn--active:hover::before,
.theme--light.v-btn--active::before {
  background: none !important;
}
.theme--light.v-list-item--active:hover::before,
.theme--light.v-list-item--active::before {
  background: none !important;
}
.main {
  /* 幅は仮 */
  max-width: 1200px !important;
}
.header_wrapper {
  display: flex;
  justify-content: space-between;
  max-width: 1500px;
  width: 90%;
  margin: 0 auto;
}
.bold-text {
  font-weight: bold;
}
</style>