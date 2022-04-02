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
            @change="updateRange"
          ></v-calendar>
          <v-menu
            v-model="goalTodoComment"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card color="grey lighten-4" min-width="350px" flat>
              <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
              <v-card-actions>
                <v-btn text @click="goalTodoComment = false">Cancel</v-btn>
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
      events: [],
      names: [
        "８セットやりきった",
        "7セット 腕立ては深くなくていいかも",
        "6セット １セット５回出来た",
        "時間無かったが４セットだけやった",
        "サボりそうだったけど８セット完走！！",
        "５セット",
      ],
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
    updateRange({ start, end }) {
      const events = [];

      const min = new Date(`${start.date}T00:00:00`);
      const max = new Date(`${end.date}T23:59:59`);
      const days = (max.getTime() - min.getTime()) / 86400000;
      const eventCount = this.rnd(days, days + 20);

      for (let i = 0; i < eventCount; i++) {
        const allDay = this.rnd(0, 3) === 0;
        const firstTimestamp = this.rnd(min.getTime(), max.getTime());
        const first = new Date(firstTimestamp - (firstTimestamp % 900000));
        const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000;
        const second = new Date(first.getTime() + secondTimestamp);

        events.push({
          name: this.names[this.rnd(0, this.names.length - 1)],
          start: first,
          end: second,
          timed: !allDay,
        });
      }

      this.events = events;
    },
    rnd(a, b) {
      return Math.floor((b - a + 1) * Math.random()) + a;
    },
  },
};
</script>
