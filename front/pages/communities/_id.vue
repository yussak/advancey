<template>
  <div>
    <h2 class="text-center">コミュニティ名：{{ community.name }}</h2>
    <p>概要：{{ community.description }}</p>
    <a @click="$router.back()">戻る</a>
    <v-divider></v-divider>
    <h2 class="text-center">チャット</h2>
    <div class="chat_area">
      <v-row v-for="message in messages" :key="message.id">
        <v-col class="d-flex chat-myself" v-if="message.user_id === user.id">
          <p class="ml-2 balloon_mine">{{ message.content }}</p>
          <UserCard :user="message.user" class="ml-2" />
          <v-icon
            v-if="message.user_id === user.id"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
        <v-col class="d-flex chat-others" v-else>
          <UserCard :user="message.user" />
          <p class="ml-2 balloon_others">{{ message.content }}</p>
          <v-icon
            v-if="message.user_id === user.id || user.admin"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
      </v-row>
    </div>
    <!-- コンポ化したい -->
    <ValidationObserver v-slot="{ invalid }" ref="addMessageObserver">
      <v-form class="chat_form grey lighten-2">
        <v-container>
          <v-row class="d-flex align-center">
            <v-col>
              <ValidationProvider rules="required|max:100" name="メッセージ">
                <v-text-field
                  v-model="message"
                  counter="100"
                  label="メッセージを追加"
                  name="メッセージ"
                ></v-text-field>
              </ValidationProvider>
            </v-col>
            <v-col>
              <v-btn :disabled="invalid" @click="addMessage(message)"
                >送信</v-btn
              >
            </v-col>
          </v-row>
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
  mounted() {
    const cable = ActionCable.createConsumer("ws://localhost:3000/cable");
    this.messageChannel = cable.subscriptions.create(
      { channel: "ChatChannel" },
      {
        connected: () => {
          this.getMessages();
        },
        received: () => {
          this.getMessages();
        },
      }
    );
    this.fetchCommunity();
  },
  beforeUnmount() {
    this.messageChannel.unsubscribe();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async getMessages() {
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
  },
};
</script>

<style lang="scss">
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
}
.chat_form {
  max-width: 600px;
  width: 95%;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  //吹き出しの矢印対策
  z-index: 2;
}
.balloon_mine {
  position: relative;
  display: inline-block;
  width: fit-content;
  color: #fff;
  padding: 20px;
  background: #4fc3f7;
  border-radius: 5px;
  &:before {
    content: "";
    position: absolute;
    display: block;
    z-index: 1;
    border-style: solid;
    border-color: transparent #4fc3f7;
    border-width: 10px 0 10px 10px;
    top: 50%;
    transform: translateY(-50%);
    right: -10px;
  }
}
.balloon_others {
  position: relative;
  display: inline-block;
  width: fit-content;
  color: #fff;
  padding: 20px;
  background: #bdbdbd;
  border-radius: 5px;
  &:before {
    content: "";
    position: absolute;
    display: block;
    z-index: 1;
    border-style: solid;
    border-color: transparent #bdbdbd;
    border-width: 10px 10px 10px 0;
    top: 50%;
    transform: translateY(-50%);
    left: -10px;
  }
}
</style>