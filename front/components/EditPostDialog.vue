<template>
  <div>
    <v-dialog v-model="editPostDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn text v-bind="attrs" v-on="on" @click="openEditPostDialog()">
          <v-icon>edit</v-icon>編集
        </v-btn>
      </template>
      <v-card>
        <v-card-title>メモ編集</v-card-title>
        <v-card-text>
          <ValidationObserver v-slot="{ invalid }" ref="editPostObserver">
            <v-form>
              <v-container>
                <ValidationProvider
                  name="メモ"
                  v-slot="{ errors }"
                  rules="required|max:200"
                >
                  <v-textarea
                    v-model="content"
                    counter="200"
                    rows="1"
                    row-height="1"
                    auto-grow
                    label="メモ（必須）"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <v-radio-group v-model="tag" row>
                  <v-radio label="実践中" value="実践中"></v-radio>
                  <v-radio label="実践したい" value="実践したい"></v-radio>
                  <v-radio label="実践済み" value="実践済み"></v-radio>
                  <v-radio
                    label="やって良かった"
                    value="やって良かった"
                  ></v-radio>
                </v-radio-group>
                <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
                <v-file-input
                  v-if="!post.image_url"
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
                <v-file-input
                  v-else
                  v-model="image"
                  accept="image/*"
                  label="画像を変更"
                  @change="setImage"
                ></v-file-input>
                <img
                  v-if="post.image_url"
                  :src="post.image_url"
                  alt="メモの画像"
                  style="width: 100%; height: auto"
                />
                <v-btn
                  color="blue darken-1"
                  text
                  @click="editPostDialog = false"
                >
                  キャンセル
                </v-btn>
                <v-btn
                  color="blue darken-1"
                  text
                  :disabled="invalid"
                  @click="(editPostDialog = false), handleSubmit()"
                >
                  保存
                </v-btn>
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
  props: ["post"],
  data() {
    return {
      editPostDialog: false,
      content: "",
      tag: "",
      privacy: false,
      image: [],
      imageFile: null,
      image_url: "",
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
    openEditPostDialog() {
      this.content = this.post.content;
      this.tag = this.post.tag;
      this.privacy = this.post.privacy;
    },
    handleSubmit() {
      const post = new FormData();
      post.append("post[content]", this.content);
      if (this.tag !== null) {
        post.append("post[tag]", this.tag);
      }
      if (this.privacy !== null) {
        post.append("post[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        post.append("post[image]", this.imageFile);
      }
      this.$emit("submit", post);
      this.editPostDialog = false;
      this.$refs.editPostObserver.reset();
    },
  },
};
</script>