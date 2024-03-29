<template>
  <div>
    <v-card>
      <v-card-actions>
        <v-card-actions>
          <v-icon @click="$router.back()" class="mr-4">mdi-arrow-left</v-icon
          >目標
        </v-card-actions>
      </v-card-actions>
      <v-divider></v-divider>
      <v-card-actions>
        <UserCard v-if="goal.user" :user="goal.user" />
        <!-- <p v-if="goal.created_at">
          {{ $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm") }}
        </p> -->
        <v-spacer></v-spacer>
        <!-- ドロップダウン -->
        <v-menu v-if="user.id === goal.user_id" v-model="goalMenu">
          <template v-slot:activator="{ on, attrs }">
            <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
          </template>
          <v-list>
            <v-list-item>
              <EditGoalDialog
                v-if="user.id === goal.user_id"
                :goal="goal"
                @submitEditGoal="updateGoal"
              />
            </v-list-item>
            <v-list-item>
              <v-btn text>
                <v-icon @click="deleteGoal">delete</v-icon>削除</v-btn
              >
            </v-list-item>
          </v-list>
        </v-menu>
      </v-card-actions>
      <v-card-title class="subtitle-1 pb-2">達成したいこと</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.content }}</v-card-text>
      <v-card-title class="subtitle-1 pb-2">理由</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.reason }}</v-card-text>
      <v-card-title class="subtitle-1 pb-2">そのためにやること</v-card-title>
      <v-card-text class="br-content body-1">{{ goal.todo }}</v-card-text>
      <v-card-text v-if="goal.image_url" class="text-center">
        <img
          :src="goal.image_url"
          alt="目標の画像"
          style="max-width: 100%; max-height: 200px"
        />
      </v-card-text>
      <v-divider></v-divider>
      <v-card-text>
        <span v-if="goal.achieve_status" class="green--text font-weight-bold"
          >達成</span
        >
        <span v-else class="red--text font-weight-bold">未達成</span>
        <span v-if="goal.privacy" class="red--text font-weight-bold ml-4"
          >Private</span
        >
      </v-card-text>
    </v-card>
    <h3 v-if="user.id === goal.user_id" class="text-center my-4">
      コメントを追加する
    </h3>
    <GoalCommentForm
      v-if="user.id === goal.user_id"
      :goal="goal"
      @submit="addGoalComment"
    />
    <h3 class="text-center my-4">コメント一覧</h3>
    <!-- カレンダー -->
    <v-row class="fill-height">
      <v-col>
        <v-sheet height="64">
          <v-toolbar flat style="z-index: 1">
            <v-btn text color="grey darken-2" @click="prev">
              <v-icon> mdi-chevron-left </v-icon>
            </v-btn>
            <v-btn text color="grey darken-2" @click="next">
              <v-icon> mdi-chevron-right </v-icon>
            </v-btn>
            <v-toolbar-title v-if="$refs.calendar">
              {{ $refs.calendar.title }}
            </v-toolbar-title>
            <v-spacer></v-spacer>
            <v-menu bottom right>
              <template v-slot:activator="{ on, attrs }">
                <v-btn outlined color="grey darken-2" v-bind="attrs" v-on="on">
                  <span>{{ typeToLabel[type] }}</span>
                  <v-icon right> mdi-menu-down </v-icon>
                </v-btn>
              </template>
              <v-list>
                <v-list-item @click="type = 'month'">
                  <v-list-item-title>月ごと</v-list-item-title>
                </v-list-item>
                <v-list-item @click="type = 'day'">
                  <v-list-item-title>日ごと</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </v-toolbar>
        </v-sheet>
        <v-sheet height="600">
          <v-calendar
            ref="calendar"
            v-model="focus"
            color="primary"
            :events="events"
            @click:event="showEvent"
            @click:more="viewDay"
            :type="type"
          >
          </v-calendar>
          <!-- コメントダイアログ -->
          <v-dialog
            v-model="goalCommentDialog"
            :activator="selectedElement"
            max-width="700"
          >
            <v-card color="grey lighten-4">
              <v-card-title v-if="selectedEvent.start">
                {{
                  $dateFns.format(new Date(selectedEvent.start), "yyyy/MM/dd")
                }}
              </v-card-title>
              <v-card-text class="br-content"
                >{{ selectedEvent.name }}
              </v-card-text>
              <v-card-actions>
                <v-btn text @click="goalCommentDialog = false"
                  >キャンセル</v-btn
                >
                <v-icon
                  v-if="user.id === goal.user_id"
                  @click="openEditGoalCommentDialog(selectedEvent)"
                  >edit</v-icon
                >
                <v-icon
                  v-if="user.id === goal.user_id || user.admin"
                  @click="deleteGoalComment(selectedEvent.id)"
                  >delete</v-icon
                >
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-sheet>
      </v-col>
    </v-row>
    <!-- コメント編集ダイアログ -->
    <v-dialog v-model="editGoalCommentDialog" max-width="700">
      <v-card>
        <v-card-title>
          <span>コメント編集</span>
        </v-card-title>
        <v-form>
          <v-container>
            <v-textarea
              v-model="content"
              counter="200"
              rows="1"
              row-height="1"
              auto-grow
              label="コメント"
            ></v-textarea>
          </v-container>
        </v-form>
        <v-card-actions>
          <v-btn text @click="editGoalCommentDialog = false">キャンセル</v-btn>
          <v-btn
            text
            @click="(editGoalCommentDialog = false), updateGoalComment()"
            >編集</v-btn
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
  head() {
    return {
      title: "目標詳細",
    };
  },
  components: {
    GoalCommentForm,
    EditGoalDialog,
  },
  data() {
    return {
      goalCommentDialog: false,
      editGoalCommentDialog: false,
      goal: [],
      focus: "",
      type: "month",
      selectedEvent: [],
      selectedElement: null,
      events: [],
      goal_comment: [],
      content: "",
      comment_date: "",
      goalMenu: false,
      typeToLabel: {
        month: "月ごと",
        day: "日ごと",
      },
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
    viewDay({ date }) {
      this.focus = date;
      this.type = "day";
    },
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
          this.goalMenu = false;
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