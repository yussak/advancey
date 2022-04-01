<template>
  <v-app>
    <div>
      <Success />
      <Loading />
    </div>

    <!-- <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer> -->

    <!-- スマホ時だけドロワーメニュー追加したい -->
    <!-- ヘッダー -->
    <v-app-bar app>
      <div class="header_wrapper">
        <div class="header_left">
          <nuxt-link :to="`/`" class="logo" v-if="user"> Advancey </nuxt-link>
          <div class="logo" v-else>Advancey</div>
        </div>
        <div class="header_right">
          <div style="display: flex" v-if="user">
            <v-avatar>
              <!-- アイコン表示されない→編集でVuex更新してないからかも -->
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
              <!-- コミュニティでmessage.user_idとしたときと違う値が出る… -->
              <!-- {{ user.id }} -->
            </v-avatar>
            <p class="bold-text">
              {{ user.name }}
            </p>
          </div>
        </div>
      </div>
    </v-app-bar>
    <v-main>
      <v-container class="main">
        <v-row>
          <!-- サイドバー -->
          <v-col cols="3">
            <SideBar />
          </v-col>
          <!-- メイン -->
          <v-col cols="9">
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
import GuestLoginButton from "@/components/GuestLoginButton";
import DeleteUserDialog from "@/components/DeleteUserDialog";
import ChangeAdminDialog from "@/components/ChangeAdminDialog";
import SideBar from "@/components/SideBar";

export default {
  data() {
    return {
      drawer: false,
      title: "Advancey",
      show1: false,
    };
  },
  components: {
    Loading,
    Success,
    GuestLoginButton,
    DeleteUserDialog,
    ChangeAdminDialog,
    SideBar,
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
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
  /* background: orange; */
}
.bold-text {
  font-weight: bold;
}
</style>