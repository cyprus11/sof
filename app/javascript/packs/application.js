// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import gistLoader from "easy-gist-async"
require("@popperjs/core")

import "bootstrap"

import { Tooltip, Popover } from "bootstrap"

require("../stylesheets/application.scss")
require('jquery')
require("@nathanvda/cocoon")
require('./utilites/vote.js')

window.jQuery = $;
window.$ = $;

document.addEventListener('turbolinks:load', function() {
  gistLoader()
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new Tooltip(tooltipTriggerEl)
    })

    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
        return new Popover(popoverTriggerEl)
    })
})

Rails.start()
Turbolinks.start()
ActiveStorage.start()
