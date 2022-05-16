<template>
  <div>
    <v-dialog v-model="editGoalDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn text>
          <v-icon v-bind="attrs" v-on="on" @click="openEditGoalDialog()"
            >edit</v-icon
          >編集</v-btn
        >
      </template>
      <v-card>
        <v-card-title>目標編集</v-card-title>
        <v-card-text>
          <ValidationObserver v-slot="{ invalid }" ref="editGoalObserver">
            <v-form v-if="user.id === goal.user_id">
              <v-container>
                <ValidationProvider
                  rules="required|max:100"
                  name="達成したいこと"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="content"
                    counter="100"
                    rows="3"
                    label="達成したいことを決めましょう！"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <ValidationProvider
                  rules="required|max:200"
                  name="理由"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="reason"
                    counter="200"
                    rows="3"
                    label="なぜ達成したいかを書いてみましょう！"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <ValidationProvider
                  rules="required|max:200"
                  name="やること"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="todo"
                    counter="200"
                    rows="3"
                    label="やること"
                  ></v-textarea>
                  <p v-if="errors" class="error-message">{{ errors[0] }}</p>
                </ValidationProvider>
                <v-checkbox
                  v-model="achieve_status"
                  label="達成済みにする"
                ></v-checkbox>
                <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
                <v-file-input
                  v-if="!goal.image_url"
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
                  v-if="goal.image_url"
                  :src="goal.image_url"
                  alt="目標の画像"
                  style="max-width: 600px; max-height: 300px"
                />
                <v-btn
                  color="blue darken-1"
                  text
                  @click="editGoalDialog = false"
                >
                  キャンセル
                </v-btn>
                <v-btn
                  color="blue darken-1"
                  text
                  :disabled="invalid"
                  @click="(editGoalDialog = false), handleSubmitEditGoal()"
                  >保存する</v-btn
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
  props: ["goal"],
  data() {
    return {
      editGoalDialog: false,
      content: "",
      reason: "",
      todo: "",
      achieve_status: false,
      privacy: "",
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
    openEditGoalDialog() {
      this.content = this.goal.content;
      this.reason = this.goal.reason;
      this.todo = this.goal.todo;
      this.achieve_status = this.goal.achieve_status;
    },
    handleSubmitEditGoal() {
      const goal = new FormData();
      goal.append("goal[content]", this.content);
      goal.append("goal[reason]", this.reason);
      goal.append("goal[todo]", this.todo);
      if (this.privacy !== null) {
        goal.append("goal[privacy]", this.privacy);
      }
      if (this.achieve_status !== null) {
        goal.append("goal[achieve_status]", this.achieve_status);
      }
      if (this.imageFile !== null) {
        goal.append("goal[image]", this.imageFile);
      }
      this.$emit("submitEditGoal", goal);
      this.$refs.editGoalObserver.reset();
    },
  },
};
</script>