<template>
  <div>
    <h1>コミュニティ一覧</h1>
    <!-- 全て・参加中と分けたい -->
    <!-- 検索もしたい -->
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="name"
              counter="100"
              label="コミュニティ名（必須）"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-textarea
              v-model="description"
              counter="200"
              label="詳細を入力（必須）"
              required
            ></v-textarea>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-btn @click="createCommunity">コミュニティを作成</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>

    <div v-for="community in communities" :key="community.id">
      <!-- 作成者名も表示可能にしたい -->
      <p>コミュニティ名:{{ community.name }}</p>
      <!-- 有無判定、出来ることは出来るけどリロードしたら表示されなくなる -->
      <v-btn @click="joinCommunity(community)" v-if="!isJoined">参加する</v-btn>
      <p style="color: red" v-if="community.isJoined">参加済み</p>
      <!-- 判定できたら参加済みのときだけの条件を追加する -->
      <v-btn color="blue" @click="showCommunity(community)">入る</v-btn>
      <!-- 自分が作った場合と条件追加する -->
      <v-icon @click="deleteCommunity(community)">delete</v-icon>
      <v-divider></v-divider>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "コミュニティ一覧",
    };
  },
  data() {
    return {
      community: [],
      communities: [],
      name: "",
      description: "",
      isJoined: false,
    };
  },
  mounted() {
    this.fetchCommunityList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    joinCommunity(community) {
      const url = `/v1/communities/${community.id}/belongings`;
      axios
        .post(url, {
          community_id: community.id,
          user_id: this.user.id,
        })
        .then(() => {
          this.fetchCommunityList();
          // フラッシュ追加する
          // this.isJoined = true; //全部変わってしまう
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchCommunityList() {
      const url = `/v1/communities`;
      axios.get(url).then((res) => {
        this.communities = res.data;
        this.communities.forEach((community) => {
          // observerを配列に変換
          const parsedObj = JSON.parse(JSON.stringify(community));
          // その配列からidの中身だけ取り出して配列を作る
          const userIdList = parsedObj.users.map((obj) => obj.id);
          // その配列に現在のユーザーのidが含まれているかどうか
          if (userIdList.includes(this.user.id)) {
            community.isJoined = true;
            console.log(community.isJoined);
          }
          // else {
          //   // this.isJoined = false;
          //   // console.log(this.isJoined);
          //   community.isJoined = false;
          //   console.log(community.isJoined);
          // }
        });
      });
    },
    createCommunity() {
      const url = "/v1/communities";
      axios
        .post(url, { name: this.name, description: this.description })
        .then((res) => {
          this.community = res.data;
          this.fetchCommunityList();
          (this.name = ""),
            (this.description = ""),
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "質問を削除しました",
            });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async showCommunity(community) {
      this.$router.push(`/communities/${community.id}`);
    },
    async deleteCommunity(community) {
      const url = `/v1/communities/${community.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchCommunityList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コミュニティを削除しました",
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
