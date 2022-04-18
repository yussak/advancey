<template>
  <div>
    <v-dialog v-model="showUserInfoDialog" scrollable fullscreen hide-overlay>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
          @click="openShowUserInfoDialog()"
        >
          ユーザー情報閲覧
        </v-btn>
      </template>
      <v-card>
        <v-card-title>ユーザー情報</v-card-title>
        <v-card-text style="height: 300px">
          <div>
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
            <span
              class="bold-text"
              style="color: red"
              @click="openEditUserImageDialog()"
              >変更する</span
            >
          </div>

          <p class="bold-text">
            {{ user.name }}
            <span style="color: red" @click="openEditUserNameDialog()"
              >変更する</span
            >
          </p>
          <p class="bold-text">
            {{ user.profile }}
            <span style="color: red" @click="openEditUserProfileDialog()"
              >変更する</span
            >
          </p>
          <!-- フォームもコンポーネント化したい -->
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="showUserInfoDialog = false">
            戻る
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- edit name -->
    <v-dialog v-model="changeUserNameDialog" max-width="700">
      <v-card>
        <v-form>
          <v-container>
            <v-text-field
              label="name"
              v-model="name"
              data-vv-name="name"
              required
            ></v-text-field>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn
            color="blue darken-1"
            text
            @click="changeUserNameDialog = false"
          >
            戻る
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="
              handleSubmitUserName();
              changeUserNameDialog = false;
            "
          >
            変更
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- edit prof -->
    <v-dialog v-model="changeUserProfileDialog" max-width="700">
      <v-card>
        <v-form>
          <v-container>
            <v-text-field
              label="profile"
              v-model="profile"
              data-vv-name="profile"
              required
            ></v-text-field>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn
            color="blue darken-1"
            text
            @click="changeUserNameDialog = false"
          >
            戻る
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="
              handleSubmitUserProfile();
              changeUserProfileDialog = false;
            "
          >
            変更
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- edit img -->
    <v-dialog v-model="changeUserImageDialog" max-width="700">
      <v-card>
        <v-form>
          <v-container>
            <v-file-input
              v-model="image"
              accept="image/*"
              label="画像を選択"
              @change="setImage"
            ></v-file-input>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn
            color="blue darken-1"
            text
            @click="changeUserImageDialog = false"
          >
            戻る
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="
              handleSubmitUserImage();
              changeUserProfileDialog = false;
            "
          >
            変更
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showUserInfoDialog: false,
      changeUserNameDialog: false,
      changeUserProfileDialog: false,
      changeUserImageDialog: false,
      name: "",
      profile: "",
      email: "",
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
    openShowUserInfoDialog() {
      this.showUserInfoDialog = true;
      this.name = this.user.name;
      this.profile = this.user.profile;
      this.email = this.user.email;
      this.image = this.user.image;
    },
    openEditUserNameDialog() {
      this.changeUserNameDialog = true;
      this.name = this.user.name;
    },
    openEditUserProfileDialog() {
      this.changeUserProfileDialog = true;
      this.profile = this.user.profile;
    },
    openEditUserImageDialog() {
      this.changeUserImageDialog = true;
    },
    handleSubmitUserName() {
      const user = new FormData();
      user.append("user[name]", this.name);
      this.$emit("submitEditName", user);
    },
    handleSubmitUserProfile() {
      const user = new FormData();
      user.append("user[profile]", this.profile);
      this.$emit("submitEditProfile", user);
    },
    handleSubmitUserImage() {
      const user = new FormData();
      if (this.imageFile !== null) {
        user.append("user[image]", this.imageFile);
      }
      this.$emit("submitEditImage", user);
    },
  },
};
</script>