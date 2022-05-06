<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addGoalCommentObserver">
      <v-form class="white mb-4">
        <v-container>
          <ValidationProvider
            rules="required|max:200"
            name="コメント"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="content"
              counter="200"
              label="コメント"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-menu
            ref="menuDate"
            v-model="selectCommentDateDialog"
            :close-on-content-click="false"
            :return-value.sync="selectCommentDateDialog"
          >
            <template v-slot:activator="{ on }">
              <ValidationProvider
                rules="required"
                name="日にち"
                v-slot="{ errors }"
              >
                <v-text-field
                  v-model="comment_date"
                  label="追加する日を選択"
                  readonly
                  v-on="on"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
            </template>
            <v-date-picker
              :day-format="(date) => new Date(date).getDate()"
              locale="jp-ja"
              style="width: 100%"
              v-model="comment_date"
              no-title
              scrollable
            >
              <v-btn
                :disabled="invalid"
                text
                @click="selectCommentDateDialog = false"
                >キャンセル</v-btn
              >
              <v-btn text @click="$refs.menuDate.save(comment_date)"
                >決定</v-btn
              >
            </v-date-picker>
          </v-menu>
          <v-btn
            :disabled="invalid"
            color="primary"
            @click="
              handleSubmit();
              addGoalCommentDialog = false;
            "
            >コメントを追加</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  props: ["goal"],
  data() {
    return {
      addGoalCommentDialog: false,
      selectCommentDateDialog: false,
      goal_comment: [],
      content: "",
      comment_date: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    handleSubmit() {
      const comment = new FormData();
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[goal_id]", this.goal.id);
      comment.append("comment[content]", this.content);
      comment.append("comment[comment_date]", this.comment_date);
      this.$emit("submit", comment);
      this.content = "";
      this.comment_date = "";
      this.$refs.addGoalCommentObserver.reset();
    },
  },
};
</script>