<template>
  <div>
    <h2 class="text-center">質問詳細</h2>
    <p
      v-if="topic.solve_status"
      style="text-align: center; background: aliceblue; border: 1px solid black"
    >
      この質問は投稿者によって解決済みとなっためクローズされました
    </p>
    <!-- コンポ化したい -->
    <v-dialog
      v-if="user.id === topic.user_id"
      v-model="editTopicDialog"
      scrollable
      fullscreen
      hide-overlay
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
          @click="openEditTopicDialog()"
        >
          質問を編集する
        </v-btn>
      </template>
      <v-card>
        <v-card-title>質問編集</v-card-title>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="editTopicDialog = false">
            戻る
          </v-btn>
          <v-btn color="blue darken-1" text @click="updateTopic()">
            保存する
          </v-btn>
        </v-card-actions>
        <v-card-text style="height: 300px">
          <v-form>
            <v-container>
              <v-text-field
                v-model="title"
                label="title"
                data-vv-name="title"
              ></v-text-field>
              <v-text-field
                v-model="content"
                label="content"
                data-vv-name="content"
              ></v-text-field>
              <p style="color: red; font-weight: bold">
                チェックをつけると解決済になり、コメントの受付ができなくなります
              </p>
              <p>チェックを外せばまた受け付けられます</p>
              <v-checkbox
                v-model="solve_status"
                label="解決済みにする"
              ></v-checkbox>
            </v-container>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="editTopicDialog = false">
            戻る
          </v-btn>
          <v-btn color="blue darken-1" text @click="updateTopic()">
            保存する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-row>
      <v-col>
        <UserCard v-if="topic.user" :user="topic.user" />
        <p>タイトル：{{ topic.title }}</p>
        <p v-if="topic.content">詳細：{{ topic.content }}</p>
        <div v-if="topic.image_url !== null">
          <p>画像</p>
          <img
            :src="topic.image_url"
            alt="質問の画像"
            style="max-width: 600px"
          />
        </div>
        <a @click="$router.back()">質問一覧に戻る</a>
      </v-col>
    </v-row>
    <!-- コンポ化したい -->
    <ValidationObserver v-slot="{ invalid }" ref="addTopicCommentObserver">
      <v-form v-if="!topic.solve_status">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="コメント"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="comment_content"
              counter="100"
              label="質問へのコメント"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加（任意）"
            @change="setImage"
          ></v-file-input>
          <v-btn :disabled="invalid" @click="addTopicComment"
            >コメントする</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
    <h2 class="text-center">
      <span style="color: green">{{ count }}</span
      >件のコメント
    </h2>
    <v-card>
      <v-data-table
        :headers="headers"
        :items="topic_comments"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <template v-slot:[`item.username`]="{ item }">
          <UserCard :user="item.user" />
        </template>
        <template v-slot:[`item.image_url`]="{ item }">
          <img
            v-if="item.image_url"
            :src="item.image_url"
            alt="質問コメントの画像"
            width="30"
            height="30"
          />
        </template>
        <template v-slot:[`item.created_at`]="{ item }">
          {{ $dateFns.format(new Date(item.created_at), "yyyy/MM/dd HH:mm") }}
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 編集済みとしたい -->
          <v-icon
            v-if="item.user_id === user.id"
            @click="openChildElement(item)"
            >edit</v-icon
          >
          <v-icon
            v-if="item.user_id === user.id"
            small
            @click="deleteTopicComment(item)"
            >delete</v-icon
          >
        </template>
      </v-data-table>
    </v-card>
    <EditTopicCommentDialog
      ref="child"
      :topic="topic"
      @submitEditTopicComment="editTopicComment"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import EditTopicCommentDialog from "@/components/EditTopicCommentDialog";

export default {
  head() {
    return {
      title: "質問詳細",
    };
  },
  components: {
    EditTopicCommentDialog,
  },
  data() {
    return {
      editTopicDialog: false,
      topic: [],
      title: "",
      content: "",
      solve_status: false,
      topic_comments: [],
      image: [],
      imageFile: null,
      comment_content: "",
      headers: [
        {
          text: "コメント",
          value: "content",
        },
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "画像表示（試し）",
          value: "image_url",
        },
        {
          text: "コメント日時",
          value: "created_at",
        },
        {
          text: "",
          value: "action",
        },
      ],
    };
  },
  mounted() {
    this.fetchTopicContents();
    this.fetchTopicComments();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    topic_params() {
      return {
        topic: {
          title: this.title,
          content: this.content,
          solve_status: this.solve_status,
        },
      };
    },
    count() {
      return this.topic_comments.length;
    },
  },
  methods: {
    openChildElement(item) {
      this.$refs.child.openEditTopicCommentDialog(item);
    },
    editTopicComment(comment, commendId) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const url = `/v1/topics/${this.$route.params.id}/topic_comments/${commendId}`;
      axios.put(url, comment, config).then(() => {
        this.fetchTopicComments();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "コメントを編集しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      });
    },
    setImage(e) {
      this.imageFile = e;
    },
    addTopicComment() {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const comment = new FormData();
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[topic_id]", this.topic.id);
      comment.append("comment[content]", this.comment_content);
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      axios
        .post(
          `/v1/topics/${this.$route.params.id}/topic_comments`,
          comment,
          config
        )
        .then(() => {
          this.fetchTopicComments();
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
      this.comment_content = "";
      this.image = [];
      this.$refs.addTopicCommentObserver.reset();
    },
    openEditTopicDialog() {
      this.title = this.topic.title;
      this.content = this.topic.content;
      this.solve_status = this.topic.solve_status;
    },
    updateTopic() {
      const url = `/v1/topics/${this.$route.params.id}`;
      axios
        .put(url, this.topic_params) //goal_commentはparamsをここで定義してる(index.vue)→こっちも合わせる
        .then(() => {
          this.fetchTopicContents();
          this.editTopicDialog = false;
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchTopicContents() {
      const url = `/v1/topics/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.topic = res.data;
      });
    },
    fetchTopicComments() {
      const url = `/v1/topics/${this.$route.params.id}/`;
      axios.get(url).then((res) => {
        this.topic_comments = res.data.topic_comments;
      });
    },
    async deleteTopicComment(item) {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments/${item.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchTopicComments();
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
  },
};
</script>
