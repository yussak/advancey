<template>
  <div>
    <h1>目標詳細</h1>
    <p>ここでカレンダーにメモ書く</p>
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

    <a @click="$router.back()">目標一覧に戻る</a>
    <v-icon v-if="goal.user_id === user.id" @click="deleteGoal">delete</v-icon>

    <AddGoalCommentDialog
      v-if="goal.user_id === user.id"
      @submit="addGoalComment"
      :goal="goal"
    />
    <EditGoalDialog
      v-if="user.id === goal.user_id"
      :goal="goal"
      @submitEditGoal="editGoal"
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

          <!-- コメントダイアログ→コンポ化 -->
          <v-menu
            v-model="goalTodoCommentDialog"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card color="grey lighten-4">
              <v-card-text>
                <span v-html="selectedEvent.name"></span>
              </v-card-text>
              <v-card-actions>
                <v-btn text @click="goalTodoCommentDialog = false"
                  >閉じる</v-btn
                >
                <v-icon
                  v-if="goal.user_id === user.id"
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

    <!-- コメント編集後モーダル開くと編集前のが表示されるので直したい -->
    <!-- コメント編集ダイアログ→コンポ化したい -->
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
      goalTodoCommentDialog: false, //goalCommentDialogに変える？
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
    this.fetchGoalInfo();
    this.fetchGoalCommentList();
  },
  methods: {
    editGoal(goal) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const url = `/v1/goals/${this.$route.params.id}`;
      axios.put(url, goal, config).then(() => {
        this.fetchGoalInfo();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "目標を編集しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      });
    },
    openEditGoalCommentDialog(selectedEvent) {
      this.editGoalCommentDialog = true;
      this.id = selectedEvent.id;
      this.user_id = selectedEvent.user_id;
      this.content = selectedEvent.name;
      this.start = selectedEvent.comment_date;
    },
    updateGoalComment() {
      const url = `/v1/goals/${this.$route.params.id}/goal_comments/${this.id}`;
      axios
        .put(url, {
          goal_comment: {
            user_id: this.user_id,
            content: this.content,
            comment_date: this.start,
          },
        })
        .then(() => {
          this.editGoalCommentDialog = false;
          this.fetchGoalCommentList();
        });
    },
    deleteGoalComment(id) {
      const url = `/v1/goals/${this.$route.params.id}/goal_comments/${id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        axios.delete(url).then((res) => {
          // これをしないとgoal_commentsからは消せるがeventsには残ってしまうので必要
          this.events.pop({
            id: res.data.id,
            user_id: res.data.user_id,
            name: res.data.content,
            start: res.data.comment_date,
          });
          this.goalTodoCommentDialog = false;
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
    // pushはここじゃなくて別の作る？addのときだけpushするほうが良さそう
    fetchGoalCommentList() {
      const url = `/v1/goals/${this.$route.params.id}`;
      axios
        .get(url)
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
    async addGoalComment(goal_comment) {
      const url = `/v1/goals/${this.$route.params.id}/goal_comments`;
      await axios
        .post(url, goal_comment)
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
    fetchGoalInfo() {
      const url = `/v1/goals/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.goal = res.data;
      });
    },
    async deleteGoal() {
      const url = `/v1/goals/${this.$route.params.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.$router.push("/goals");
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "目標を削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
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
          requestAnimationFrame(() => (this.goalTodoCommentDialog = true))
        );
      };
      if (this.goalTodoCommentDialog) {
        this.goalTodoCommentDialog = false;
        requestAnimationFrame(() => requestAnimationFrame(() => open()));
      } else {
        open();
      }
      nativeEvent.stopPropagation();
    },
  },
};
</script>