<template>
  <div>
    <v-row v-if="$store.state.auth.currentUser.id === user.id" justify="center">
      <v-dialog v-model="editUserDialog" scrollable fullscreen hide-overlay>
        <!-- ダイアログボタン -->
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            color="primary"
            dark
            v-bind="attrs"
            v-on="on"
            @click="openEditUserInfoDialog()"
          >
            ユーザー情報を編集
          </v-btn>
        </template>
        <!-- ダイアログ中身 -->
        <v-card>
          <v-card-title>ユーザー情報編集</v-card-title>
          <v-card-actions>
            <v-btn color="blue darken-1" text @click="editUserDialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="
                handleSubmit();
                editUserDialog = false;
              "
            >
              保存する
            </v-btn>
          </v-card-actions>
          <v-card-text style="height: 300px">
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
            <span style="font-weight: bold">{{ user.name }}さん</span>
            <!-- フォームもコンポーネント化したい -->
            <form>
              <v-text-field
                v-model="name"
                :counter="10"
                label="Name"
                data-vv-name="name"
                required
              ></v-text-field>
              <v-text-field
                v-model="profile"
                :counter="50"
                label="自己紹介を入力してみましょう！"
                data-vv-name="profile"
              ></v-text-field>
              <v-row>
                <v-col cols="6" md="8">
                  <v-file-input
                    v-model="image"
                    accept="image/*"
                    label="アイコン画像を変更"
                    prepend-icon="mdi-camera"
                    @change="setImage"
                  >
                  </v-file-input>
                </v-col>
              </v-row>
            </form>
          </v-card-text>
          <v-card-actions>
            <v-btn color="blue darken-1" text @click="editUserDialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="
                handleSubmit();
                editUserDialog = false;
              "
            >
              保存する
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
  </div>
</template>

<script>
export default {
  data() {
    return {
      editUserDialog: false,
      name: "",
      profile: "",
      imageFile: null,
      image: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    openEditUserInfoDialog() {
      this.name = this.user.name;
      this.profile = this.user.profile;
      this.image = this.user.image;
    },
    // password emailも編集したい
    handleSubmit() {
      const user = new FormData();
      user.append("user[name]", this.name);
      user.append("user[profile]", this.profile);
      if (this.imageFile !== null) {
        user.append("user[image]", this.imageFile);
      }
      this.$emit("submit", user);
    },
  },
};
</script>