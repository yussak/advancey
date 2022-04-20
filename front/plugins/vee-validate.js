import Vue from 'vue'
import { ValidationProvider, ValidationObserver, extend, localize } from 'vee-validate'
import { required, max } from 'vee-validate/dist/rules';
import ja from 'vee-validate/dist/locale/ja.json';

localize('ja',ja);

extend('required', required);
extend('max', max);

Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);