<template>
  <div>
    <h2 class="text-center">
      <span class="orange--text">{{ community.name }}</span
      >のチャットルーム
    </h2>
    <v-card class="mb-4">
      <v-card-title>概要</v-card-title>
      <v-card-text class="br-content">{{ community.description }}</v-card-text>
      <v-card-actions>
        <v-icon @click="$router.back()"
          >mdi-arrow-left-bottom</v-icon
        ></v-card-actions
      >
    </v-card>
    <h2 class="text-center">チャット</h2>
    <div class="chat_area">
      <v-row v-for="message in messages" :key="message.id">
        <v-col class="d-flex chat-myself" v-if="user.id === message.user_id">
          <v-chip class="ma-2 blue lighten-3 br-content">{{
            message.content
          }}</v-chip>
          <UserCard :user="message.user" class="ml-2" />
          <v-icon
            v-if="user.id === message.user_id"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
        <v-col class="d-flex chat-others" v-else>
          <UserCard :user="message.user" />
          <v-chip class="ma-2 grey lighten-3">{{ message.content }}</v-chip>
          <v-icon
            v-if="user.id === message.user_id || user.admin"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
      </v-row>
    </div>
    <ValidationObserver v-slot="{ invalid }" ref="addMessageObserver">
      <v-form class="chat_form grey lighten-2">
        <v-container>
          <ValidationProvider rules="required|max:100" name="メッセージ">
            <v-textarea
              v-model="message"
              counter="100"
              rows="2"
              label="メッセージを追加"
            ></v-textarea>
          </ValidationProvider>
          <v-btn
            :disabled="invalid"
            color="primary"
            @click="addMessage(message)"
            >送信</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import ActionCable from "actioncable";

export default {
  head() {
    return {
      title: "チャットルーム",
    };
  },
  data() {
    return {
      community: [],
      messages: [],
      message: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    const websocketUrl =
      process.env.NODE_ENV === "production"
        ? "wss://back.pf-advancey.com/cable"
        : "ws://localhost:3000/cable";
    const cable = ActionCable.createConsumer(websocketUrl);
    this.messageChannel = cable.subscriptions.create(
      { channel: "ChatChannel" },
      {
        connected: () => {
          this.getMessageList();
        },
        received: () => {
          this.getMessageList();
        },
      }
    );
    this.fetchCommunity();
  },
  beforeUnmount() {
    this.messageChannel.unsubscribe();
  },
  methods: {
    fetchCommunity() {
      axios
        .get(`/v1/communities/${this.$route.params.id}`)
        .then((res) => {
          this.community = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async getMessageList() {
      try {
        const res = await axios.get(`/v1/communities/${this.$route.params.id}`);
        if (!res) {
          console.log("メッセージ一覧を取得できませんでした");
        }
        this.messages = res.data.messages;
      } catch (err) {
        console.log(err);
      }
    },
    addMessage(message) {
      this.messageChannel.perform("receive", {
        message: message,
        user_id: this.user.id,
        community_id: this.community.id,
      });
      this.message = "";
      this.$refs.addMessageObserver.reset();
      this.$store.dispatch("notification/setNotice", {
        status: true,
        message: "メッセージを送信しました",
      });
      setTimeout(() => {
        this.$store.dispatch("notification/setNotice", {});
      }, 3000);
    },
    deleteMessage(message) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        this.messageChannel.perform("destroy", {
          message_id: message.id,
        });
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メッセージを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      }
    },
  },
};
</script>

<style>
.chat-myself {
  justify-content: flex-end;
}
.chat-others {
  justify-content: flex-start;
}
.chat_area {
  height: 600px;
  margin: 0 auto;
  max-width: 600px;
  width: 95%;
  background: #fff;
  overflow: auto;
  /* メッセージが隠れないよう対策 */
  padding-bottom: 200px;
}
.chat_form {
  max-width: 600px;
  width: 95%;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  /* 吹き出しの矢印対策 */
  z-index: 2;
}
.v-chip.v-size--default {
  border-radius: 40px;
  min-width: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100% !important;
  padding: 15px;
}
/* 改行 Vuetify上書き */
.v-chip .v-chip__content {
  white-space: pre-wrap !important;
  word-wrap: break-word !important;
}
</style>