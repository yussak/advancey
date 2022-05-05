<template>
  <div>
    <h2 class="text-center">目標詳細</h2>
    <UserCard v-if="goal.user" :user="goal.user" />
    <p>{{ goal.content }}</p>
    <p>{{ goal.reason }}</p>
    <p>{{ goal.todo }}</p>
    <p v-if="goal.achieve_status">達成</p>
    <p v-else>未達成</p>
    <div v-if="goal.image_url !== null">
      <p>画像</p>
      <img
        :src="goal.image_url"
        alt="test"
        style="max-width: 600px; max-height: 400px"
      />
    </div>
    <a @click="$router.back()">戻る</a>
    <v-icon v-if="goal.user_id === user.id || user.admin" @click="deleteGoal"
      >delete</v-icon
    >
    <AddGoalCommentDialog
      v-if="goal.user_id === user.id"
      @submit="addGoalComment"
      :goal="goal"
    />
    <EditGoalDialog
      v-if="user.id === goal.user_id"
      :goal="goal"
      @submitEditGoal="updateGoal"
    />
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
                  v-if="goal.user_id === user.id || user.admin"
                  @click="deleteGoalComment(selectedEvent.id)"
                  >delete</v-icon
                >
                <v-icon
                  v-if="goal.user_id === user.id"
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
    <v-dialog v-model="editGoalCommentDialog">
      <v-card>
        <v-card-title>
          <span>コメントを編集</span>
        </v-card-title>
        <v-form>
          <v-container>
            <v-text-field
              label="コメント"
              v-model="content"
              data-vv-name="content"
            ></v-text-field>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn text @click="editGoalCommentDialog = false">閉じる</v-btn>
          <v-btn text @click="updateGoalComment">コメントを編集</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import AddGoalCommentDialog from "@/components/AddGoalCommentDialog";
import EditGoalDialog from "@/components/EditGoalDialog";

export default {
  components: {
    AddGoalCommentDialog,
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
      focus: "", //これがないと月移動できない
      selectedEvent: [],
      selectedElement: null,
      goalCommentDialog: false,
      events: [], //name startが必要＋削除のためidも追加
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
    // 違うものが削除されるので要修正
    async deleteGoalComment(id) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/goals/${this.$route.params.id}/goal_comments/${id}`)
          .then((res) => {
            // これをしないとgoal_commentsからは消せるがeventsには残ってしまうので必要
            this.events.pop({
              id: res.data.id,
              user_id: res.data.user_id,
              name: res.data.content,
              start: res.data.comment_date,
            });
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
          goal_comment: {
            user_id: this.user_id,
            content: this.content,
            comment_date: this.start,
          },
        })
        .then(() => {
          this.editGoalCommentDialog = false;
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