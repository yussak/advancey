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
          管理モード
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
          <v-form>
            <v-container>
              <v-text-field v-model="profile" label="profile"></v-text-field>
            </v-container>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="changeAdmin">送信</v-btn>
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
        const { data } = await axios.put(`/v1/users/${this.user.id}`, {
          user: {
            admin: true,
          },
        });
        alert("管理者になりました！");
        this.adminDialog = false;
        this.profile = "";
        this.$store.dispatch("auth/setUser", data);
      } else {
        const { data } = await axios.put(`/v1/users/${this.user.id}`, {
          user: {
            admin: false,
          },
        });
        alert("通常ユーザーになりました");
        this.adminDialog = false;
        this.profile = "";
        this.$store.dispatch("auth/setUser", data);
      }
    },
  },
};
</script>