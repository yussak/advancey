import { createApp } from "vue";
import Index from "../../components/Users/Index.vue";
import router from '../router'

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("userIndex"); //idからdivを取得
  const initialData = JSON.parse(node.getAttribute("data")); //そのdivの中身をJSONに変換
  const app1 = createApp(Index, { initialData: initialData });
  // app1.use(router).mount("#userIndex");
  app1.use(router).mount("#spa-user-show");

  // createApp(Index).use(router).mount("#spa-user-show");
});