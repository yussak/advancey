<template>
  <div>
    <h1>コミュニティ一覧</h1>

    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="name"
              counter="100"
              label="タイトル（必須）"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-btn @click="addCommunity">コミュニティを作成</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>

    <div>
      {{ community.name }}
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      community: "",
      name: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    addCommunity() {
      // axios.post(`/v1/communities/belongings`).then((res) => {
      // axios.post(`/v1/belongings`).then((res) => {
      axios.post(`/v1/communities`).then((res) => {
        this.community = res.data;
        alert("ok");
      });
    },
  },
};
</script>
