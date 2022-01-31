import { createApp } from "vue";
import Index from "../../components/Users/Index.vue";

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("userIndex"); //id="userIndex"の要素（＝content_tagで作ったdiv）を取得してnodeとする
  const initialData = JSON.parse(node.getAttribute("data")); //そのnodeのdataの中身を取得してinitialDataとする

  const app = createApp(Index, { initialData: initialData }); //createAppでアプリインスタンスを作成、IndexコンポーネントにinitialData を渡し初期化
  app.mount("#userIndex"); //div #userIndexにappを追加
  console.log(initialData)
});