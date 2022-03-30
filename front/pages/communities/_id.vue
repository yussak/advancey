<template>
  <div>
    <h2>トークルーム</h2>
    <p>ここでチャットする</p>
    <p v-if="community.users">
      <span style="font-weight: bold; color: green"
        >{{ community.users.length }}人</span
      >が参加中
    </p>

    <p><span style="font-weight: bold">2人</span> がオンライン</p>
    <v-row justify="center">
      <v-dialog v-model="communityDetailDialog">
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            color="primary"
            dark
            v-bind="attrs"
            v-on="on"
            @click="communityDetailDialog = true"
          >
            コミュニティ概要
          </v-btn>
        </template>
        <v-card>
          <v-card-title>コミュニティ概要</v-card-title>
          <v-card-actions>
            <v-btn
              color="blue darken-1"
              text
              @click="communityDetailDialog = false"
            >
              閉じる
            </v-btn>
          </v-card-actions>
          <v-card-text style="height: 300px">
            <p>
              コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示コミュ概要をここに表示
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="blue darken-1"
              text
              @click="communityDetailDialog = false"
            >
              閉じる
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>

    <nuxt-link :to="`/communities/`">一覧に戻る</nuxt-link>

    <v-form>
      <v-container>
        <v-row>
          <v-col>
            <v-text-field
              v-model="message"
              counter="100"
              label="メッセージを追加"
              required
            ></v-text-field>
          </v-col>
          <v-col>
            <v-file-input accept="image/*" hide-input></v-file-input>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="4">
            <v-btn @click="connectCable(message)">メッセージを送信</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>

    <v-divider></v-divider>
    <h2>チャット</h2>
    <!-- <ul>
      <li v-for="m in messages" :key="m.id">a:{{ m }}</li>
    </ul> -->
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import ActionCable from "actioncable";

export default {
  head() {
    return {
      title: "トークルーム",
      // title: this.community.name + "トークルーム", //試しだが動的に変えられた
    };
  },
  data() {
    return {
      communityDetailDialog: false,
      community: [],
      messages: [],
      message: "",
    };
  },
  mounted() {
    const cable = ActionCable.createConsumer("ws://localhost:3000/cable");
    this.messageChannel = cable.subscriptions.create(
      { channel: "ChatChannel", community_id: this.community.id },
      {
        connected: () => {
          this.getMessages();
        },
        received: () => {
          this.getMessages();
        },
      }
    );
    this.fetchCommunityInfo();
  },
  // ページ遷移＋リロードしたら止められる（なくても行けるかもしれん）
  // beforeUnmount() {
  //   this.messageChannel.unsubscribe();
  // },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async getMessages() {
      const url = `/v1/communities/${this.$route.params.id}/messages`;
      try {
        const res = await axios.get(url);
        if (!res) {
          console.log("メッセージ一覧を取得できませんでした");
        }
        this.messages = res.data;
        // console.log(res.data);
        const test = JSON.parse(JSON.stringify(res.data));
        console.log(test);
      } catch (err) {
        console.log(err);
      }
    },
    connectCable(message) {
      this.messageChannel.perform("receive", {
        message: message,
        user_id: this.$store.state.auth.currentUser.id,
      });
    },
    fetchCommunityInfo() {
      const url = `/v1/communities/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.community = res.data;
      });
    },
  },
};
</script>