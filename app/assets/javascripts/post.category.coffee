class Post.Category
  constructor: (@link) ->
    $(document).on 'dialog:confirmed', @link, $.proxy(@onConfirmed, @)

  onConfirmed: (evt) ->
    url = $(@link).data('dialog-confirmed')

    $.ajax
      url: url
      method: 'GET'
      dataType: 'html'
      context: @
    .done (data) ->
      $categories = $(data).find('div.blog_post_category_ids')
      $('div.blog_post_category_ids').replaceWith($categories)
      true
#      $(@link).parents('li.dropdown').replaceWith($(data))
#      $(@link).toggleClass 'open'

$(document).ready ->
  new Post.Category('a.categories-edit[data-dialog="auto"]')
