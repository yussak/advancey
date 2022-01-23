import { createApp } from "vue";
import App from "../app.vue";
import router from './router';

document.addEventListener("DOMContentLoaded", () => {
createApp(App).use(router).mount('#vue-app')
});