$(document).on('turbolinks:load', function() {
  $('a.vote').on('ajax:success', function(e) {
    let body = e.detail[0]
    let answerBlock = $('.answer-' + body['vote']['votable_id'])

    answerBlock.find('b.user-choice').text(body['vote']['vote_plus'] == 1 ? '+' : '-')
    answerBlock.find('div.vote-res').removeAttr('hidden')
    answerBlock.find('div.vote-answer').attr('hidden', 'hidden')
    answerBlock.find('b.votes-diff').text(body['vote_diff'])
  })

  $('a.unvote').on('ajax:success', function(e) {
    let body = e.detail[0]
    let answerBlock = $('.answer-' + body['vote']['votable_id'])

    answerBlock.find('div.vote-answer').removeAttr('hidden')
    answerBlock.find('div.vote-res').attr('hidden', 'hidden')
    answerBlock.find('b.votes-diff').text(body['vote_diff'])
  })
})
