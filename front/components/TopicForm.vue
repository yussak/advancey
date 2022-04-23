<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addTopicObserver">
      <v-form style="background: orange">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="タイトル"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="title"
              counter="100"
              label="タイトル（必須）"
              required
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider rules="max:300" name="詳細" v-slot="{ errors }">
            <v-textarea
              v-model="content"
              counter="300"
              label="詳細を入力（任意）"
              required
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加"
            @change="setImage"
          ></v-file-input>
          <v-btn :disabled="invalid" @click="handleSubmitTopic"
            >質問を追加</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  data() {
    return {
      title: "",
      content: "",
      solve_status: false,
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
    handleSubmitTopic() {
      const topic = new FormData();
      topic.append("topic[title]", this.title);
      topic.append("topic[user_id]", this.user.id);
      if (this.imageFile !== null) {
        topic.append("topic[image]", this.imageFile);
      }
      this.$emit("submit", topic);
      this.title = "";
      this.content = "";
      this.image = [];
      this.$refs.addTopicObserver.reset();
    },
  },
};
</script>