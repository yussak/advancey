import Vue from 'vue';
import * as VueRouter from 'vue-router';
import { createRouter, createWebHistory } from 'vue-router'

import Hoge from './components/Spa/Hoge.vue';
import About from './components/Spa/About.vue';

const routes = [
  {
    path: '/about',
    component: About
  },
  {
    path: '/hoge',
    component: Hoge
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;