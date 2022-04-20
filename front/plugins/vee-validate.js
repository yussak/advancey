import Vue from 'vue'
import { ValidationProvider, extend } from 'vee-validate'
 
// バリデーションルールを追加
extend('test', {
  validate: value => value === 'test',
  message: 'test 以外の入力はエラーになります。'
});
 
Vue.component('ValidationProvider', ValidationProvider);