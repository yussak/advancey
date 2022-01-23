import Vue from 'vue';
import * as VueRouter from 'vue-router';
import { createRouter, createWebHistory } from 'vue-router'

import Hoge from './components/Spa/Hoge.vue';
import Fuga from './components/Spa/Fuga.vue';

const routes = [
  {
    path: '/hoge',
    component: Hoge
  },
  {
    path: '/fuga',
    component: Fuga
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;