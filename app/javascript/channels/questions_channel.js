import consumer from "./consumer"


document.addEventListener('turbolinks:load', function() {
  let questions = document.querySelector('.questions')

  if (questions) {
    consumer.subscriptions.create("QuestionsChannel", {
      connected: function() {
        this.perform("follow")
      },

      received(data) {
        $('.questions').append(data)
      }
    });
  }
})

