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
            <v-text-field
              v-model="content"
              counter="100"
              label="達成したいことを決めましょう！（必須）"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:200"
            name="理由"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="reason"
              counter="200"
              label="なぜ達成したいかを書いてみましょう！（必須）"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:200"
            name="やること"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="todo"
              counter="200"
              label="やることを書いてみましょう！（必須）"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加"
            @change="setImage"
          ></v-file-input>
          <v-btn :disabled="invalid" @click="handleSubmitGoal"
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
      if (this.imageFile !== null) {
        goal.append("goal[image]", this.imageFile);
      }
      this.$emit("submit", goal);
      this.content = "";
      this.reason = "";
      this.todo = "";
      this.image = [];
      this.$refs.addGoalObserver.reset();
    },
  },
};
</script>