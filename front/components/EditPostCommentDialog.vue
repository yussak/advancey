<template>
  <div>
    <v-dialog v-model="editPostCommentDialog" max-width="700">
      <v-card>
        <v-card-title>コメント編集</v-card-title>
        <v-card-text>
          <v-form>
            <v-container>
              <!-- バリデ追加 -->
              <v-text-field
                v-model="modal_text"
                label="コメント"
                counter="100"
              ></v-text-field>
              <v-file-input
                v-model="image"
                accept="image/*"
                label="画像を追加"
                @change="setImage"
              ></v-file-input>
              <!-- 幅の上限はどこかで指定するかも -->
              <!-- サイズを小さくして拡大させるかも -->
              <img
                v-if="image_url !== null"
                :src="image_url"
                alt="メモコメントの画像"
                style="max-width: 600px; max-height: 300px"
              />
            </v-container>
          </v-form>
        </v-card-text>
        <v-card-actions>
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
            @click="
              handleSubmitEditPostComment();
              editPostCommentDialog = false;
            "
          >
            保存する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  props: ["post", "item"],
  data() {
    return {
      imageFile: null,
      image: [],
      content: "",
      editPostCommentDialog: false,
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
    openEditPostCommentDialog(item) {
      this.editPostCommentDialog = true;
      this.modal_text = item.content;
      this.image_url = item.image_url;
      this.id = item.id;
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
      this.$emit("submitEditPostComment", comment, this.commendId);
    },
  },
};
</script>