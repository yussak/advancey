<template>
  <div>
    <h1>目標詳細</h1>
    <p>ここでカレンダーにメモ書く</p>
    <p>{{ goal.content }}</p>
    <p>{{ goal.reason }}</p>
    <p>{{ goal.todo }}</p>
    <p>{{ goal.period }}</p>
    <nuxt-link :to="`/goals/`">目標一覧に戻る</nuxt-link>
    <v-icon v-if="goal.user_id === user.id" @click="deleteGoal">delete</v-icon>

    <v-dialog v-model="addGoalCommentDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" dark v-bind="attrs" v-on="on">
          コメントを追加
        </v-btn>
      </template>
      <v-card>
        <v-card-title>
          <span>コメントを追加</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field label="コメント" v-model="content"></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col>
                <v-menu
                  ref="menuDate"
                  v-model="selectCommentDateDialog"
                  :close-on-content-click="false"
                  :return-value.sync="selectCommentDateDialog"
                >
                  <template v-slot:activator="{ on }">
                    <v-text-field
                      v-model="comment_date"
                      label="追加する日を選択"
                      readonly
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    :day-format="(date) => new Date(date).getDate()"
                    locale="jp-ja"
                    style="width: 100%"
                    v-model="comment_date"
                    no-title
                    scrollable
                  >
                    <v-btn text @click="selectCommentDateDialog = false"
                      >キャンセル</v-btn
                    >
                    <v-btn text @click="$refs.menuDate.save(comment_date)"
                      >決定</v-btn
                    >
                  </v-date-picker>
                </v-menu>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="addGoalCommentDialog = false">閉じる</v-btn>
          <v-btn text @click="addGoalComment(), (addGoalCommentDialog = false)"
            >コメントを追加</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>

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
            type="month"
            :events="events"
            @click:event="showEvent"
          >
          </v-calendar>

          <v-menu
            v-model="goalTodoComment"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card color="grey lighten-4" min-width="350px" flat>
              <v-card-text>
                <span v-html="selectedEvent.name"></span>
              </v-card-text>
              <v-card-actions>
                <v-btn text @click="goalTodoComment = false">閉じる</v-btn>
              </v-card-actions>
            </v-card>
          </v-menu>
        </v-sheet>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
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
      goalTodoComment: false,
      events: [], //name startが必要
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
  mounted() {
    this.fetchGoalInfo();
    this.fetchGoalCommentList();
  },
  methods: {
    fetchGoalCommentList() {
      const url = `/v1/goals/${this.$route.params.id}/goal_comments`;
      axios
        .get(url)
        .then((res) => {
          this.comments = res.data;
          const events = [];
          this.comments.forEach((comment) => {
            events.push({
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
    addGoalComment() {
      const url = `/v1/goals/${this.$route.params.id}/goal_comments`;
      axios
        .post(url, {
          goal_comment: {
            user_id: this.user.id,
            goal_id: this.goal.id,
            content: this.content,
            comment_date: this.comment_date,
          },
        })
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
      this.content = "";
      this.comment_date = "";
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
          requestAnimationFrame(() => (this.goalTodoComment = true))
        );
      };
      if (this.goalTodoComment) {
        this.goalTodoComment = false;
        requestAnimationFrame(() => requestAnimationFrame(() => open()));
      } else {
        open();
      }
      nativeEvent.stopPropagation();
    },
  },
};
</script>