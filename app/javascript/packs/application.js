import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "../stylesheets/application.scss"
import "../js/hoge.js"

import '@fortawesome/fontawesome-free/js/all'
import "jquery"

const images = require.context('../images/', true)

