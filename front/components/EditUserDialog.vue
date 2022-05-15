<template>
  <div>
    <v-dialog v-model="showUserInfoDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-icon v-bind="attrs" v-on="on" @click="openShowUserInfoDialog()">
          edit
        </v-icon>
      </template>
      <v-card>
        <v-card-title>ユーザー情報編集</v-card-title>
        <v-card-text>
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
            <v-icon @click="openEditUserImageDialog()">edit</v-icon>
          </div>

          <p>
            {{ user.name }}
            <span
              v-if="user.email === 'guest@guest.com'"
              onclick="return confirm('ゲストユーザーは変更できません');"
              >変更する</span
            >
            <v-icon v-else @click="openEditUserNameDialog()">edit</v-icon>
          </p>
          <p>
            {{ user.profile }}
            <v-icon @click="openEditUserProfileDialog()">edit</v-icon>
          </p>
          <p>
            {{ user.email }}
            <v-icon @click="openEditUserEmailDialog()">edit</v-icon>
          </p>
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="showUserInfoDialog = false">
            キャンセル
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- edit name -->
    <v-dialog v-model="changeUserNameDialog" max-width="700">
      <v-card>
        <ValidationObserver v-slot="{ invalid }" ref="editUserNameObserver">
          <v-form>
            <v-container>
              <ValidationProvider
                rules="required|max:30"
                name="ユーザー名"
                v-slot="{ errors }"
              >
                <v-text-field
                  label="ユーザー名"
                  v-model="name"
                  counter="30"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <v-btn
                color="blue darken-1"
                text
                @click="changeUserNameDialog = false"
              >
                キャンセル
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                :disabled="invalid"
                @click="
                  handleSubmitUserName();
                  changeUserNameDialog = false;
                "
              >
                更新
              </v-btn>
            </v-container>
          </v-form>
        </ValidationObserver>
      </v-card>
    </v-dialog>

    <!-- edit prof -->
    <v-dialog v-model="changeUserProfileDialog" max-width="700">
      <v-card>
        <ValidationObserver v-slot="{ invalid }" ref="editUserProfileObserver">
          <v-form>
            <v-container>
              <ValidationProvider
                rules="max:50"
                name="自己紹介"
                v-slot="{ errors }"
              >
                <v-textarea
                  v-model="profile"
                  counter="50"
                  label="自己紹介"
                ></v-textarea>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <v-btn
                color="blue darken-1"
                text
                @click="changeUserProfileDialog = false"
              >
                キャンセル
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                :disabled="invalid"
                @click="
                  handleSubmitUserProfile();
                  changeUserProfileDialog = false;
                "
              >
                更新
              </v-btn>
            </v-container>
          </v-form>
        </ValidationObserver>
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
            キャンセル
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

    <!-- edit email -->
    <v-dialog v-model="changeUserEmailDialog" max-width="700">
      <v-card>
        <ValidationObserver v-slot="{ invalid }" ref="editUserEmailObserver">
          <v-form>
            <v-container>
              <ValidationProvider
                rules="required|max:100|email"
                name="メールアドレス"
                v-slot="{ errors }"
              >
                <v-text-field
                  label="現在のメールアドレス"
                  v-model="email"
                  counter="100"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <ValidationProvider
                rules="required|min:6"
                name="パスワード"
                v-slot="{ errors }"
              >
                <v-text-field
                  v-model="password"
                  label="パスワード"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <p v-if="error" class="error-message">{{ error }}</p>
              <v-btn
                color="blue darken-1"
                text
                :disabled="invalid"
                @click="reAuth()"
              >
                確認
              </v-btn>
            </v-container>
          </v-form>
        </ValidationObserver>
        <ValidationObserver v-slot="{ invalid }" ref="editUserEmailObserver">
          <v-form>
            <v-container>
              <ValidationProvider
                rules="required|max:100|email"
                name="メールアドレス"
                v-slot="{ errors }"
              >
                <v-text-field
                  label="新しいメールアドレス"
                  v-model="newEmail"
                  counter="100"
                  :disabled="!reAuthStatus"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
              <v-btn
                color="blue darken-1"
                text
                @click="changeUserEmailDialog = false"
              >
                キャンセル
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                :disabled="invalid && !reAuthStatus"
                @click="
                  handleSubmitUserEmail();
                  changeUserEmailDialog = false;
                "
              >
                更新
              </v-btn>
            </v-container>
          </v-form>
        </ValidationObserver>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";

export default {
  data() {
    return {
      showUserInfoDialog: false,
      changeUserNameDialog: false,
      changeUserProfileDialog: false,
      changeUserImageDialog: false,
      changeUserEmailDialog: false,
      name: "",
      profile: "",
      email: "",
      newEmail: "",
      image: [],
      imageFile: null,
      password: "",
      reAuthStatus: false,
      error: null,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async reAuth() {
      await firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .catch((error) => {
          switch (error.code) {
            case "auth/user-not-found":
              this.error = "メールアドレスが間違っています";
              return;
            case "auth/wrong-password":
              this.error = "※パスワードが正しくありません";
              return;
            default:
              this.error = "※メールアドレスとパスワードをご確認ください";
              return;
          }
        });
      if (this.error === null) {
        this.reAuthStatus = true;
        alert("再認証に成功しました。更新ボタンをクリックしてください");
      }
    },
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
    openEditUserEmailDialog() {
      this.changeUserEmailDialog = true;
      this.email = this.user.email;
    },
    openEditUserImageDialog() {
      this.changeUserImageDialog = true;
    },
    handleSubmitUserName() {
      const user = new FormData();
      user.append("user[name]", this.name);
      this.$emit("submitEditName", user);
      this.$refs.editUserNameObserver.reset();
    },
    handleSubmitUserProfile() {
      const user = new FormData();
      user.append("user[profile]", this.profile);
      this.$emit("submitEditProfile", user);
      this.$refs.editUserProfileObserver.reset();
    },
    handleSubmitUserEmail() {
      const user = new FormData();
      user.append("user[email]", this.newEmail);
      this.$emit("submitEditEmail", user);
      this.$refs.editUserEmailObserver.reset();
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