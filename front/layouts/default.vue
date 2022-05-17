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
            <!-- <v-col cols="12" md="8"> -->
            <Nuxt />
          </v-col>
          <!-- サイドバー -->
          <!-- <v-col class="hidden-sm-and-down" cols="2">
            <RightSideBar />
          </v-col> -->
        </v-row>
      </v-container>
    </v-main>
    <v-footer app class="d-flex flex-column">
      <div class="d-flex">
        <nuxt-link :to="`/about`" class="mr-2">サービス詳細</nuxt-link>
        <nuxt-link :to="`/news`">運営からのお知らせ</nuxt-link>
      </div>

      <span>&copy; Advancey All Rights Reserved.</span>
    </v-footer>
  </v-app>
</template>

<script>
import Loading from "@/components/Loading";
import Success from "@/components/Success";
import Header from "@/components/Header";
import LinkList from "@/components/LinkList";
import RightSideBar from "@/components/RightSideBar";

export default {
  components: {
    Loading,
    Success,
    Header,
    LinkList,
    RightSideBar,
  },
};
</script>

<style>
.logo {
  color: #333 !important;
  font-size: 30px !important;
  text-decoration: none !important;
}
.errors {
  color: red;
  margin-top: 20px;
}
.main {
  max-width: 1200px !important;
  width: 100%;
}
.br-content {
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>