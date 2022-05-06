<template>
  <div>
    <h2 class="text-center">目標詳細</h2>
    <v-row>
      <v-col>
        <v-card class="mb-4">
          <v-card-actions>
            <UserCard v-if="goal.user" :user="goal.user" />
            <p v-if="goal.created_at">
              {{
                $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm")
              }}に投稿
            </p>
            <v-spacer></v-spacer>
            <EditGoalDialog
              v-if="user.id === goal.user_id"
              :goal="goal"
              @submitEditGoal="updateGoal"
            />
            <v-icon @click="deleteGoal">delete</v-icon>
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
          <v-card-title>達成したいこと</v-card-title>
          <v-card-text>{{ goal.content }}</v-card-text>
          <v-card-title>理由</v-card-title>
          <v-card-text>{{ goal.reason }}</v-card-text>
          <v-card-title>そのためにやること</v-card-title>
          <v-card-text>{{ goal.todo }}</v-card-text>
          <v-card-title>達成状況</v-card-title>
          <v-card-text
            v-if="goal.achieve_status"
            class="green--text font-weight-bold"
            >達成</v-card-text
          >
          <v-card-text v-else class="red--text font-weight-bold"
            >未達成</v-card-text
          >
          <v-card-text>
            <img
              v-if="goal.image_url"
              :src="goal.image_url"
              alt="目標の画像"
              style="width: 100%; max-height: 500px; height: 100%"
            />
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <EditGoalDialog
              v-if="user.id === goal.user_id"
              :goal="goal"
              @submitEditGoal="updateGoal"
            />
            <v-icon @click="deleteGoal">delete</v-icon>
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <h3 class="text-center">コメントを追加する</h3>
    <GoalCommentForm
      v-if="user.id === goal.user_id"
      :goal="goal"
      @submit="addGoalComment"
    />
    <h3 class="text-center">コメント一覧</h3>
    <!-- カレンダー -->
    <v-row class="fill-height">
      <v-col>
        <v-sheet height="64">
          <v-toolbar flat>
            <v-btn text color="grey darken-2" @click="prev">
              <v-icon> mdi-chevron-left </v-icon>
            </v-btn>
            <v-btn text color="grey darken-2" @click="next">
              <v-icon> mdi-chevron-right </v-icon>
            </v-btn>
            <v-toolbar-title v-if="$refs.calendar">
              {{ $refs.calendar.title }}
            </v-toolbar-title>
          </v-toolbar>
        </v-sheet>
        <v-sheet height="600">
          <v-calendar
            ref="calendar"
            v-model="focus"
            color="primary"
            :events="events"
            @click:event="showEvent"
            type="month"
          >
          </v-calendar>
          <!-- コメントダイアログ -->
          <v-menu
            v-model="goalCommentDialog"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card color="grey lighten-4">
              <v-card-text>
                <span v-html="selectedEvent.name"></span>
              </v-card-text>
              <v-card-actions>
                <v-btn text @click="goalCommentDialog = false">閉じる</v-btn>
                <v-icon
                  v-if="user.id === goal.user_id || user.admin"
                  @click="deleteGoalComment(selectedEvent.id)"
                  >delete</v-icon
                >
                <v-icon
                  v-if="user.id === goal.user_id"
                  @click="openEditGoalCommentDialog(selectedEvent)"
                  >edit</v-icon
                >
              </v-card-actions>
            </v-card>
          </v-menu>
        </v-sheet>
      </v-col>
    </v-row>
    <!-- コメント編集ダイアログ -->
    <v-dialog v-model="editGoalCommentDialog" max-width="700">
      <v-card>
        <v-card-title>
          <span>コメントを編集</span>
        </v-card-title>
        <v-form>
          <v-container>
            <v-text-field label="コメント" v-model="content"></v-text-field>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn text @click="editGoalCommentDialog = false">閉じる</v-btn>
          <v-btn
            text
            @click="
              updateGoalComment();
              editGoalCommentDialog = false;
            "
            >コメントを編集</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import GoalCommentForm from "@/components/GoalCommentForm";
import EditGoalDialog from "@/components/EditGoalDialog";

export default {
  components: {
    GoalCommentForm,
    EditGoalDialog,
  },
  head() {
    return {
      title: "目標詳細",
    };
  },
  data() {
    return {
      goal: [],
      focus: "", //月移動に必要
      selectedEvent: [],
      selectedElement: null,
      goalCommentDialog: false,
      events: [],
      goal_comment: [],
      content: "",
      comment_date: "",
      editGoalCommentDialog: false,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchGoal();
    this.fetchGoalCommentList();
  },
  methods: {
    // 目標
    fetchGoal() {
      axios
        .get(`/v1/goals/${this.$route.params.id}`)
        .then((res) => {
          this.goal = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteGoal() {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${this.$route.params.id}`)
          .then(() => {
            this.$router.push("/goals");
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "目標を削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    async updateGoal(goal) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .put(`/v1/goals/${this.$route.params.id}`, goal, config)
        .then(() => {
          this.fetchGoal();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "目標を編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // コメント
    fetchGoalCommentList() {
      axios
        .get(`/v1/goals/${this.$route.params.id}`)
        .then((res) => {
          this.comments = res.data.goal_comments;
          const events = [];
          this.comments.forEach((comment) => {
            events.push({
              id: comment.id,
              user_id: comment.user_id,
              name: comment.content,
              start: comment.comment_date,
            });
            this.events = events;
          });
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addGoalComment(comment) {
      await axios
        .post(`/v1/goals/${this.$route.params.id}/goal_comments`, comment)
        .then(() => {
          this.fetchGoalCommentList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteGoalComment(id) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${this.$route.params.id}/goal_comments/${id}`)
          .then((res) => {
            const selectedComment = this.events.find(
              (comment) => comment.id === res.data.id
            );
            const index = this.events.indexOf(selectedComment);
            this.events.splice(index, 1);
            this.goalCommentDialog = false;
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "コメントを削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    openEditGoalCommentDialog(selectedEvent) {
      this.editGoalCommentDialog = true;
      this.id = selectedEvent.id;
      this.user_id = selectedEvent.user_id;
      this.content = selectedEvent.name;
      this.start = selectedEvent.comment_date;
    },
    async updateGoalComment() {
      await axios
        .put(`/v1/goals/${this.$route.params.id}/goal_comments/${this.id}`, {
          comment: {
            user_id: this.user_id,
            content: this.content,
            comment_date: this.start,
          },
        })
        .then(() => {
          this.fetchGoalCommentList();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    prev() {
      this.$refs.calendar.prev();
    },
    next() {
      this.$refs.calendar.next();
    },
    showEvent({ nativeEvent, event }) {
      const open = () => {
        this.selectedEvent = event;
        this.selectedElement = nativeEvent.target;
        requestAnimationFrame(() =>
          requestAnimationFrame(() => (this.goalCommentDialog = true))
        );
      };
      if (this.goalCommentDialog) {
        this.goalCommentDialog = false;
        requestAnimationFrame(() => requestAnimationFrame(() => open()));
      } else {
        open();
      }
      nativeEvent.stopPropagation();
    },
  },
};
</script>