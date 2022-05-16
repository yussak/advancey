<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addGoalObserver">
      <v-form class="white">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="達成したいこと（必須）"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="content"
              counter="100"
              rows="3"
              label="達成したいことを決めましょう！（必須）"
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
              label="なぜ達成したいかを書いてみましょう！（必須）"
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
              label="やることを書いてみましょう！（必須）"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加"
            @change="setImage"
          ></v-file-input>
          <v-btn :disabled="invalid" @click="handleSubmitGoal" color="primary"
            >目標を立てる</v-btn
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
      content: "",
      reason: "",
      todo: "",
      privacy: false,
      achieve_status: false,
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
    handleSubmitGoal() {
      const goal = new FormData();
      goal.append("goal[user_id]", this.user.id);
      goal.append("goal[content]", this.content);
      goal.append("goal[reason]", this.reason);
      goal.append("goal[todo]", this.todo);
      if (this.privacy !== null) {
        goal.append("goal[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        goal.append("goal[image]", this.imageFile);
      }
      this.$emit("submit", goal);
      this.content = "";
      this.reason = "";
      this.todo = "";
      this.privacy = "";
      this.image = [];
      this.$refs.addGoalObserver.reset();
    },
  },
};
</script>