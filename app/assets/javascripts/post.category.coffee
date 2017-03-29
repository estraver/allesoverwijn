class Post.Category
  constructor: (@link) ->
    $(document).on 'dialog:confirmed', @link, $.proxy(@onConfirmed, @)

  onConfirmed: (evt) ->
    url = $('form').attr('url') + '/' + $(@link).data('dialog-confirmed')

    $.ajax
      url: url
      method: 'GET'
      dataType: 'html'
      context: @
    .done (data) ->
      $categories = $(data).find('div.categories')
      $('div.categories').replaceWith($categories)
      true
#      $(@link).parents('li.dropdown').replaceWith($(data))
#      $(@link).toggleClass 'open'

$(document).ready ->
  new Post.Category('a.categories-edit[data-dialog="auto"]')
