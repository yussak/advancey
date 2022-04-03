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
                  v-model="menuStartDate"
                  :close-on-content-click="false"
                  :return-value.sync="menuStartDate"
                >
                  <template v-slot:activator="{ on }">
                    <v-text-field
                      v-model="date"
                      label="追加する日を選択"
                      readonly
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    locale="jp-ja"
                    :day-format="(date) => new Date(date).getDate()"
                    style="width: 100%"
                    v-model="date"
                    no-title
                    scrollable
                  >
                    <v-btn text @click="menuStartDate = false"
                      >キャンセル</v-btn
                    >
                    <v-btn text @click="$refs.menuDate.save(date)">決定</v-btn>
                  </v-date-picker>
                </v-menu>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="addGoalCommentDialog = false">閉じる</v-btn>
          <v-btn text @click="addGoalComment">コメントを追加</v-btn>
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
      selectedEvent: [], //これをcommentにするかも
      selectedElement: null,
      goalTodoComment: false,
      // events: [
      //   {
      //     name: "てｓｔ",
      //     start: "2022-3-1",
      //   },
      //   {
      //     name: "５セットやった",
      //     start: "2022-4-1",
      //   },
      //   {
      //     name: "疲れたけど3セットだけやった",
      //     start: "2022-4-2",
      //   },
      //   {
      //     // 折り返させたい
      //     name: "testtesttesttesttesttesttesttest",
      //     start: "2022-4-3",
      //   },
      // ],
      events: [],
      addGoalCommentDialog: false,
      menuStartDate: false,
      goal_comment: [],
      // goal_comment: [content:"",date:""としたい→マイグレする],
      content: "",
      date: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchGoalInfo();
    // this.$refs.calendar.checkChange();
  },
  methods: {
    addGoalComment() {
      // ,
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
        // this.goalTodoComment = true;
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
    //   updateRange({ start, end }) {
    //     const events = [];

    //     const min = new Date(`${start.date}T00:00:00`);
    //     const max = new Date(`${end.date}T23:59:59`);
    //     const days = (max.getTime() - min.getTime()) / 86400000;
    //     const eventCount = this.rnd(days, days + 20);

    //     for (let i = 0; i < eventCount; i++) {
    //       const allDay = this.rnd(0, 3) === 0;
    //       const firstTimestamp = this.rnd(min.getTime(), max.getTime());
    //       const first = new Date(firstTimestamp - (firstTimestamp % 900000));
    //       const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000;
    //       const second = new Date(first.getTime() + secondTimestamp);

    //       events.push({
    //         name: this.names[this.rnd(0, this.names.length - 1)],
    //         start: first,
    //         end: second,
    //         timed: !allDay,
    //       });
    //     }

    //     this.events = events;
    //   },
    //   rnd(a, b) {
    //     return Math.floor((b - a + 1) * Math.random()) + a;
    //   },
  },
};
</script>

<style>
</style>