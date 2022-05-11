<template>
  <div>
    <v-dialog v-model="editPostCommentDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          text
          v-bind="attrs"
          v-on="on"
          @click="openEditPostCommentDialog()"
        >
          <v-icon>edit</v-icon>編集
        </v-btn>
      </template>
      <v-card>
        <v-card-title>コメント編集</v-card-title>
        <v-card-text>
          <ValidationObserver
            v-slot="{ invalid }"
            ref="editPostCommentObserver"
          >
            <v-form>
              <v-container>
                <ValidationProvider
                  name="メモ"
                  v-slot="{ errors }"
                  rules="required|max:100"
                >
                  <v-textarea
                    v-model="modal_text"
                    label="コメント"
                    rows="3"
                    counter="100"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <v-file-input
                  v-if="!image_url"
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
                  v-if="image_url"
                  :src="image_url"
                  alt="メモコメントの画像"
                  style="width: 100%; height: auto"
                />
              </v-container>
              <v-btn
                color="blue darken-1"
                text
                @click="editPostCommentDialog = false"
              >
                キャンセル
              </v-btn>
              <v-btn
                color="blue darken-1"
                text
                :disabled="invalid"
                @click="
                  handleSubmitEditPostComment();
                  editPostCommentDialog = false;
                "
              >
                保存</v-btn
              >
            </v-form>
          </ValidationObserver>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  props: ["post", "comment"],
  data() {
    return {
      editPostCommentDialog: false,
      content: "",
      image: [],
      imageFile: null,
      modal_text: "",
      image_url: "",
      id: "", //コメント編集のため
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
    openEditPostCommentDialog() {
      this.modal_text = this.comment.content;
      this.image_url = this.comment.image_url;
      this.id = this.comment.id;
    },
    handleSubmitEditPostComment() {
      const comment = new FormData();
      comment.append("comment[content]", this.modal_text);
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[post_id]", this.post.id);
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      this.commendId = this.id;
      this.image = [];
      this.$refs.editPostCommentObserver.reset();
      this.$emit("submitEditPostComment", comment, this.commendId);
    },
  },
};
</script>