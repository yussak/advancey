// Appコンポーネントをマウントしたい
// ＝app.vueで表示される要素を#vue-appに追加したい

import { createApp } from "vue";
import App from "../app.vue";

document.addEventListener("DOMContentLoaded", () => {
  const app = createApp(App);
  app.mount("#vue-app");
});