<template>
  <div>
    <v-dialog v-model="adminDialog">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="orange"
          dark
          v-bind="attrs"
          v-on="on"
          @click="adminDialog = true"
        >
          管理者モード
        </v-btn>
      </template>
      <!-- ダイアログ中身 -->
      <v-card>
        <v-card-title>管理者モード</v-card-title>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="adminDialog = false">
            キャンセル
          </v-btn>
        </v-card-actions>
        <v-card-text style="height: 300px">
          <form>
            <v-text-field
              v-model="profile"
              label="profile"
              required
            ></v-text-field>
          </form>
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="changeAdmin"> 送信 </v-btn>
          <v-btn color="blue darken-1" text @click="adminDialog = false">
            キャンセル
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      adminDialog: false,
      profile: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async changeAdmin() {
      if (this.profile === "admin") {
        axios
          .put(`/v1/users/${this.user.id}`, {
            user: {
              admin: true,
            },
          })
          .then(() => {
            alert("管理者になりました！");
            this.adminDialog = false;
            this.profile = "";
            // 管理者かどうかをユーザー一覧で表示させたいが出来ない
            //送信したときに反映させたい→違うファイルの分を変更させたい→watch?
          })
          .catch((err) => {
            console.log(err);
          });
      } else {
        axios
          .put(`/v1/users/${this.user.id}`, {
            user: {
              admin: false,
            },
          })
          .then(() => {
            alert("通常ユーザーになりました");
            this.adminDialog = false;
            this.profile = "";
            // 管理者かどうかをユーザー一覧で表示させたいが出来ない
            //送信したときに反映させたい→違うファイルの分を変更させたい→watch?
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>