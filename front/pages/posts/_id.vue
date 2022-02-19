<template>
  <div>
    <h1>投稿詳細ページです</h1>
    {{ post.content }}
    <a @click="$router.back()">もどる</a>

    <div id="app">
      <v-app id="inspire">
        <v-row justify="center">
          <v-dialog v-model="dialog" scrollable max-width="300px">
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                color="primary"
                dark
                v-bind="attrs"
                v-on="on"
                @click="openModal()"
              >
                投稿を編集する
              </v-btn>
            </template>
            <v-card>
              <v-card-title>投稿編集</v-card-title>
              <v-divider></v-divider>
              <v-card-text style="height: 300px">
                <form>
                  <v-text-field
                    v-model="content"
                    label="content"
                    data-vv-name="content"
                    required
                  ></v-text-field>
                </form>
              </v-card-text>
              <v-divider></v-divider>
              <v-card-actions>
                <v-btn color="blue darken-1" text @click="dialog = false">
                  Close
                </v-btn>
                <v-btn
                  color="blue darken-1"
                  text
                  @click="(dialog = false), update()"
                >
                  Save
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-row>
      </v-app>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      content: "", //編集のため追加してみる
      // content: this.content,
      // content: content,
      // content: this.post.content,
      // content: "aaaa",// formにaaaaと表示される
      // content: post.content,
      post: [],
      dialogm1: "",
      dialog: false,
    };
  },
  mounted() {
    this.fetchContent();
  },
  //編集のため追加してみる
  computed: {
    params() {
      return {
        post: {
          content: this.content,
        },
      };
    },
  },
  methods: {
    fetchContent() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.post = res.data;
      });
    },
    openModal() {
      this.content = this.post.content;
    },
    update() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios
        .put(url, this.params)
        .then((res) => {
          this.fetchContent();
          // console.log("成功");
          // alert("success");
        })
        .catch((err) => {
          console.log("失敗");
        });
    },
  },
};
</script>
