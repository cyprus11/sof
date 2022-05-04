import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected: function() {
    this.perform("follow")
  },

  received(data) {
    $('.questions').append(data)
  }
});
