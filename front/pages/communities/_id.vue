<template>
  <div>
    <h2 class="text-center">コミュニティ名：{{ community.name }}</h2>
    <p v-if="community.users">
      <span class="font-weight-bold green--text"
        >{{ community.users.length }}人</span
      >が参加中
    </p>

    <p><span class="font-weight-bold">2人</span>がオンライン</p>
    <v-row justify="center">
      <v-dialog v-model="communityDetailDialog">
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            color="primary"
            dark
            v-bind="attrs"
            v-on="on"
            @click="communityDetailDialog = true"
            >概要
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
              {{ community.description }}
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

    <nuxt-link :to="`/communities/`">コミュニティ一覧に戻る</nuxt-link>

    <ValidationObserver v-slot="{ invalid }" ref="addMessageObserver">
      <v-form>
        <v-container>
          <v-row>
            <v-col>
              <ValidationProvider
                v-slot="{ errors }"
                rules="required|max:100"
                name="メッセージ"
              >
                <v-text-field
                  v-model="message"
                  counter="100"
                  label="メッセージを追加"
                  required
                  name="メッセージ"
                ></v-text-field>
                <p v-if="errors" class="error-message">{{ errors[0] }}</p>
              </ValidationProvider>
            </v-col>
            <v-col>
              <v-file-input accept="image/*" hide-input></v-file-input>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="4">
              <v-btn :disabled="invalid" @click="connectCable(message)"
                >メッセージを送信</v-btn
              >
            </v-col>
          </v-row>
        </v-container>
      </v-form>
    </ValidationObserver>

    <v-divider></v-divider>
    <h2 class="text-center">チャット</h2>
    <div v-for="message in messages" :key="message.id" class="d-flex">
      <UserCard :user="message.user" />
      <p class="ml-2">>{{ message.content }}</p>
      <v-icon v-if="message.user_id === user.id" @click="deleteMessage(message)"
        >delete</v-icon
      >
    </div>
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