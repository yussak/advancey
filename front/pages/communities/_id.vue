<template>
  <div>
    <h2 class="text-center">コミュニティ名：{{ community.name }}</h2>
    <p>概要：{{ community.description }}</p>
    <nuxt-link :to="`/communities`">コミュニティ一覧に戻る</nuxt-link>

    <v-divider></v-divider>
    <h2 class="text-center">チャット</h2>
    <div class="chat_area">
      <v-row v-for="message in messages" :key="message.id">
        <v-col class="d-flex chat-myself" v-if="message.user_id === user.id">
          <UserCard :user="message.user" />
          <p class="ml-2">>{{ message.content }}</p>
          <v-icon
            v-if="message.user_id === user.id"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
        <v-col class="d-flex chat-others" v-else>
          <UserCard :user="message.user" />
          <p class="ml-2">>{{ message.content }}</p>
          <v-icon
            v-if="message.user_id === user.id"
            @click="deleteMessage(message)"
            >delete</v-icon
          >
        </v-col>
      </v-row>
    </div>
    <!-- コンポーネント化したい -->
    <ValidationObserver v-slot="{ invalid }" ref="addMessageObserver">
      <v-form class="chat_form blue-grey lighten-4">
        <v-container>
          <v-row>
            <ValidationProvider rules="required|max:100" name="メッセージ">
              <v-text-field
                v-model="message"
                label="メッセージを追加"
                required
                name="メッセージ"
              ></v-text-field>
            </ValidationProvider>
            <v-col cols="1">
              <v-file-input accept="image/*" hide-input></v-file-input>
            </v-col>
            <v-icon v-if="invalid" small :disabled="invalid">sendaa</v-icon>
            <v-icon small v-else color="blue" @click="connectCable(message)"
              >sendbb</v-icon
            >
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
      title: "トークルーム",
      // title: this.community.name + "トークルーム", //試しだが動的に変えられた
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
    this.fetchCommunityInfo();
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
      const url = `/v1/communities/${this.$route.params.id}/`;
      try {
        const res = await axios.get(url);
        if (!res) {
          console.log("メッセージ一覧を取得できませんでした");
        }
        this.messages = res.data.messages;
      } catch (err) {
        console.log(err);
      }
    },
    connectCable(message) {
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
    fetchCommunityInfo() {
      const url = `/v1/communities/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.community = res.data;
      });
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
  background: white;
  overflow: auto;
}
.chat_form {
  position: fixed;
  bottom: 0;
  width: 100%;
  max-width: 1000px;
}
</style>