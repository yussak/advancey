<template>
  <div>
    <v-dialog v-model="editTopicDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
          @click="openEditTopicDialog()"
        >
          質問を編集する
        </v-btn>
      </template>
      <v-card>
        <v-card-title>質問編集</v-card-title>
        <v-card-text>
          <ValidationObserver v-slot="{ invalid }" ref="editTopicObserver">
            <v-form>
              <v-container>
                <ValidationProvider
                  name="タイトル"
                  v-slot="{ errors }"
                  rules="required|max:100"
                >
                  <v-text-field
                    v-model="title"
                    label="タイトル（必須）"
                    counter="100"
                  ></v-text-field>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <ValidationProvider
                  name="詳細"
                  v-slot="{ errors }"
                  rules="max:300"
                >
                  <v-textarea
                    v-model="content"
                    label="詳細（任意）"
                    counter="300"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <p class="font-weight-bold red--text">
                  チェックをつけると解決済になり、コメントの受付ができなくなります
                </p>
                <p>チェックを外せばまた受け付けられます</p>
                <v-checkbox
                  v-model="solve_status"
                  label="解決済みにする"
                ></v-checkbox>
                <v-file-input
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
                <img
                  v-if="topic.image_url"
                  :src="topic.image_url"
                  alt="質問の画像"
                  style="max-width: 600px; max-height: 300px"
                />
                <v-btn
                  color="blue darken-1"
                  text
                  @click="editTopicDialog = false"
                >
                  戻る
                </v-btn>
                <v-btn
                  color="blue darken-1"
                  text
                  :disabled="invalid"
                  @click="(editTopicDialog = false), handleSubmitEditTopic()"
                >
                  保存する
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
  props: ["topic"],
  data() {
    return {
      imageFile: null,
      image: [],
      title: "",
      content: "",
      editTopicDialog: false,
      solve_status: false,
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
    openEditTopicDialog() {
      this.title = this.topic.title;
      this.content = this.topic.content;
      this.solve_status = this.topic.solve_status;
    },
    handleSubmitEditTopic() {
      const topic = new FormData();
      topic.append("topic[title]", this.title);
      topic.append("topic[content]", this.content);
      topic.append("topic[user_id]", this.user.id);
      topic.append("topic[topic_id]", this.topic.id);
      if (this.imageFile !== null) {
        topic.append("topic[image]", this.imageFile);
      }
      this.image = [];
      this.$refs.editTopicObserver.reset();
      this.$emit("submitEditTopictopic", topic);
    },
  },
};
</script>