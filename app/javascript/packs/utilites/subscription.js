$(document).on('turbolinks:load', function() {
  $('a.subscribe-link').on('ajax:success', function(e) {
    var body = e.detail[0]
    var subscribeLink = $('a.subscribe-link')

    subscribeLink.attr('href', body['link'])
    if (subscribeLink.attr('data-method') == 'post') {
      subscribeLink.attr('data-method', 'delete')
      subscribeLink.text('Unsubscribe')
    } else {
      subscribeLink.attr('data-method', 'post')
      subscribeLink.text('Subscribe')
    }
  })
})
