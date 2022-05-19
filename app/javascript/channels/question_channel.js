import consumer from "./consumer"


document.addEventListener('turbolinks:load', function() {
  let answersBlock = document.querySelector('.answers')

  if (answersBlock) {
    consumer.subscriptions.create( {channel: "QuestionChannel", question_id: answersBlock.dataset.channel}, {
      connected: function() {
        this.perform('follow')
      },

      received(data) {
        if (gon.user_id != data.user_id) {
          switch (data.type) {
            case 'answer':
              var template = require("../templates/answer.hbs")
              $('.answers').append(template({
                id: data.id,
                body: data.body,
                files: data.files,
                links: data.links,
                isAuthor: gon.user_id == data.question_author_id,
                canVote: gon.user_id != null && gon.user_id != data.question_author_id
              }))
              break
            case 'comment':
              var template = require("../templates/comment.hbs")
              var commentBlock = `.${data.commentable_type}-${data.commentable_id}-comments`
              $(commentBlock).append(template({ commentator: data.commentator, body: data.body }))
              if ($(commentBlock).css('display') === 'none') { $(commentBlock).toggle() }
              break
          }
        }
      }
    });
  }
})
