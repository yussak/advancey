<template>
  <div>
    <h1>
      <span>{{ user.name }}</span
      >の目標一覧
    </h1>

    <v-row>
      <v-col cols="6">
        <v-form>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  counter="100"
                  label="達成したいことを決めましょう！"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  counter="100"
                  label="なぜ達成したいかを書いてみましょう！"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  counter="100"
                  label="やること"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  counter="100"
                  label="期間（日）"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="8">
                <v-file-input
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-btn>目標を立てる</v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-form>
      </v-col>
    </v-row>

    <ul>
      <li>
        <nuxt-link :to="`/goals/1`"
          >バーピーを１日８セットを３０日続ける！！</nuxt-link
        >
      </li>
      <li>
        <nuxt-link :to="`/goals/1`">音読を最低五分続ける</nuxt-link>
      </li>
      <li>
        <nuxt-link :to="`/goals/1`">英語を毎日10分リスニングする</nuxt-link>
      </li>
    </ul>
  </div>
</template>

<script>
// import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "目標一覧", //ユーザー名＋さんの目標一覧としたい
      // title: this.user.name + "の目標一覧", //ユーザー名＋さんの目標一覧としたい
      // →ここに書くと一瞬undefinedの目標一覧」になる
    };
  },
  data() {
    return {
      //
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    //
  },
  methods: {
    //
  },
};
</script>
