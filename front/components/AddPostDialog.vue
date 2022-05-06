<template>
  <div>
    <v-dialog v-model="addPostDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" dark v-bind="attrs" v-on="on">
          メモを追加
        </v-btn>
      </template>
      <v-card>
        <v-card-title>
          <span>メモを追加</span>
        </v-card-title>
        <v-card-text>
          <ValidationObserver v-slot="{ invalid }" ref="addPostObserver">
            <v-form class="white">
              <v-container>
                <ValidationProvider
                  rules="required|max:200"
                  name="メモ"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="content"
                    counter="200"
                    label="思いついたことなど何でもメモしてみましょう！（必須）"
                  ></v-text-field>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <v-radio-group v-model="tag" row>
                  <v-radio label="実践中" value="実践中"></v-radio>
                  <v-radio label="実践したい" value="実践したい"></v-radio>
                  <v-radio
                    label="やって良かった"
                    value="やって良かった"
                  ></v-radio>
                </v-radio-group>
                <v-file-input
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
                <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
                <v-btn
                  :disabled="invalid"
                  @click="
                    handleSubmitPost();
                    addPostDialog = false;
                  "
                  >メモを作成</v-btn
                >
              </v-container>
            </v-form>
          </ValidationObserver>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      addPostDialog: false,
      content: "",
      tag: "",
      privacy: false,
      image: [],
      imageFile: null,
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
    handleSubmitPost() {
      const post = new FormData();
      post.append("post[content]", this.content);
      post.append("post[user_id]", this.user.id);
      if (this.tag !== null) {
        post.append("post[tag]", this.tag);
      }
      if (this.privacy !== null) {
        post.append("post[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        post.append("post[image]", this.imageFile);
      }
      this.$emit("submitPost", post);
      this.content = "";
      this.tag = "";
      this.privacy = "";
      this.image = [];
      this.$refs.addPostObserver.reset();
    },
  },
};
</script>

<style>
/* scoped外したので他の所にもきくはず */
/* 共通スタイル作ってそこに移したい */
.error-message {
  color: red;
}
</style>