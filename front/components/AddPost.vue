<template>
  <div>
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12" md="8">
            <v-text-field
              v-model="content"
              counter="10"
              label="思いついたことなど何でも書いてみましょう！"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="8">
            <v-select
              v-model="tag"
              :items="items"
              label="選択してください"
            ></v-select>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="8">
            <v-file-input
              v-model="image"
              accept="image/*"
              label="画像を追加（任意）"
              @change="setImage"
            ></v-file-input>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="3">
            <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="8">
            <v-btn @click="handleSubmit">作成</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      content: "",
      tag: "",
      image: [],
      // これで何も選択しない状態にできた？タグ名・アイコンも表示されてないので大丈夫そう
      items: ["", "実践中", "実践したい", "身についた"],
      privacy: false,
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
    handleSubmit() {
      // 可能ならlet→constにしたい
      let post = new FormData();
      post.append("post[content]", this.content);
      post.append("post[user_id]", this.user.id);
      // const config = {
      //   headers: {
      //     "content-type": "multipart/form-data",
      //   },
      // };
      if (this.tag !== null) {
        post.append("post[tag]", this.tag);
      }
      if (this.privacy !== null) {
        post.append("post[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        post.append("post[image]", this.imageFile);
      }
      // axios
      //   .post(`/v1/posts`, post, config)
      //   .then((res) => {
      //     alert("ok");
      //   })
      //   .catch((err) => {
      //     console.log(err);
      //   });
      this.$emit("submit", post);
      // this.$emit("submit", post, config);
      this.content = "";
      this.tag = "";
      this.privacy = "";
    },
    // 画像投稿→ここをformDataにすべきか？
    // handleSubmit() {
    //   const post = {
    //     content: this.content,
    //     user_id: this.user.id,
    //     tag: this.tag,
    //     privacy: this.privacy,
    //     image: this.imageFile,
    //   };
    //   this.$emit("submit", post);
    //   this.content = "";
    //   this.tag = "";
    //   this.privacy = "";
    // },
  },
};
</script>

<style>
</style>

