<template>
  <div>
    <h2 class="text-center">質問詳細</h2>
    <v-row>
      <v-col>
        <p
          v-if="topic.solve_status === true"
          style="
            text-align: center;
            background: aliceblue;
            border: 1px solid black;
          "
        >
          この質問は投稿者によって解決済みとなっためクローズされました
        </p>
      </v-col>
    </v-row>
    <!-- 編集しても反映されない気がする -->
    <!-- 編集ボタン 自分の質問だけで表示 -->
    <v-row
      v-if="$store.state.auth.currentUser.id === topic.user_id"
      justify="center"
    >
      <v-dialog v-model="dialog" scrollable fullscreen hide-overlay>
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
            <v-btn color="blue darken-1" text @click="dialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="(dialog = false), updateTopic()"
            >
              保存する
            </v-btn>
          </v-card-actions>
          <v-card-text style="height: 300px">
            <form>
              <v-text-field
                v-model="title"
                label="title"
                data-vv-name="title"
                required
              ></v-text-field>
              <v-text-field
                v-model="content"
                label="content"
                data-vv-name="content"
                required
              ></v-text-field>
              <p style="color: red; font-weight: bold">
                チェックをつけると解決済になり、コメントの受付ができなくなります
              </p>
              <p>チェックを外せばまた受け付けられます</p>
              <v-checkbox
                v-model="solve_status"
                label="解決済みにする"
              ></v-checkbox>
            </form>
          </v-card-text>
          <v-card-actions>
            <v-btn color="blue darken-1" text @click="dialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="(dialog = false), updateTopic()"
            >
              保存する
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row>
      <v-col>
        <p>
          <v-avatar>
            <!-- アイコン設定がないとき→条件は後で追加 -->
            <img
              src="~assets/default-user-icon.png"
              style="width: 45px; height: 45px"
            />
          </v-avatar>
        </p>
        <!-- この条件がないと表示できない -->
        <p v-if="topic.user">ユーザー名：{{ topic.user.name }}</p>
        <p>タイトル：{{ topic.title }}</p>
        <div>
          <!-- contentが存在するならと書きたい。それか「なし」と書くかも -->
          <!-- ifが動かん -->
          <!-- <p v-if="topic.content !== ''">詳細：有{{ topic.content }}</p> -->
          <!-- <p v-if="topic.content !== null">詳細：有{{ topic.content }}</p> -->
          <!-- <p v-else>詳細なし</p> -->
        </div>
        <div v-if="topic.image_url !== null">
          <p>画像</p>
          <img :src="topic.image_url" alt="test" style="max-width: 600px" />
        </div>
        <a @click="$router.back()">もどる</a>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-form v-if="topic.solve_status !== true">
          <v-container>
            <v-row>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="topic_comment_content"
                  counter="100"
                  label="質問へのコメント"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="8">
                <v-file-input
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="4">
                <v-btn @click="addTopicComment">コメントする</v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-form>
      </v-col>
    </v-row>
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
          <p>
            <v-avatar>
              <!-- アイコン設定がないとき→条件は後で追加 -->
              <img
                src="~assets/default-user-icon.png"
                style="width: 45px; height: 45px"
              />
            </v-avatar>
          </p>

          <p v-if="item.user">{{ item.user.name }}さん</p>
          <!-- </p> -->
        </template>
        <!-- コメント詳細は作る予定無いので、この一覧で画像見やすくしたい -->
        <template v-slot:[`item.image_url`]="{ item }">
          <img
            v-if="item.image_url"
            :src="item.image_url"
            alt="test"
            width="30"
            height="30"
          />
        </template>
        <template v-slot:[`item.created_at`]="{ item }">
          {{ $dateFns.format(new Date(item.created_at), "yyyy/MM/dd HH:mm") }}
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 自分の投稿だけに表示したい -->
          <v-icon small @click="deleteTopicComment(item)">delete</v-icon>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "質問詳細",
    };
  },
  data() {
    return {
      imageFile: null,
      image: [], //topic,topic_comment用で分けたほうがいいかも
      dialogm1: "",
      dialog: false,
      topic: [],
      title: "",
      content: "",
      topic_comments: [],
      topic_comment_content: "",
      solve_status: false,
      headers: [
        {
          text: "コメント",
          value: "topic_comment_content",
        },
        {
          text: "ユーザー名",
          value: "username",
          //ユーザー名を変更しても反映されない
          // →編集の方でまだやるべきことある？
          // →Vuexなにかやる必要ありそう
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
    topic_comment_params() {
      return {
        topic_comment: {
          topic_comment_content: this.topic_comment_content,
        },
      };
    },
    count() {
      return this.topic_comments.length;
    },
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    addTopicComment() {
      let formData = new FormData();
      formData.append(
        "topic_comment[topic_comment_content]",
        this.topic_comment_content
      );
      formData.append("topic_comment[user_id]", this.user.id);
      formData.append("topic_comment[topic_id]", this.topic.id);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      if (this.imageFile !== null) {
        formData.append("topic_comment[image]", this.imageFile);
      }
      axios
        .post(
          `/v1/topics/${this.$route.params.id}/topic_comments`,
          formData,
          config
        )
        .then(() => {
          this.fetchTopicComments();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
      this.topic_comment_content = "";
      this.image = [];
    },
    openEditTopicDialog() {
      this.title = this.topic.title;
      this.content = this.topic.content;
      this.solve_status = this.topic.solve_status;
    },
    updateTopic() {
      const url = `/v1/topics/${this.$route.params.id}`;
      axios
        .put(url, this.topic_params)
        .then((res) => {
          this.fetchTopicContents();
          console.log(res);
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "編集しました",
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
      // const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
      axios.get(url).then((res) => {
        // this.topic_comments = res.data;
        this.topic_comments = res.data.topic_comments;
        console.log(res.data.topic_comments);
      });
    },
    async addTopicComment() {
      const url = `/v1/topics/${this.$route.params.id}/topic_comments`;
      await axios
        .post(url, this.topic_comment_params)
        .then((res) => {
          this.fetchTopicComments(); //これあるせいで重い＆重複してるかも。後で消して検証(他の所も見る)
          // でもこれ書かないと追加されないので一旦書く
          // pushとかどう？後で試す
          this.topic_comment_content = "";
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          alert("failed");
          console.log(err);
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
