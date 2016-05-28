class Post.Dropdown
  constructor: (@dropdown, @keep_open = '.keep-open') ->
    $(@dropdown + @keep_open).on
      'shown.bs.dropdown': ->
        @closeable = false
      'hide.bs.dropdown': ->
        @closeable
      click: (e) ->
        @closeable = $(e.target).is('a[data-toggle=dropdown]')
        true

$(document).on 'page:change', ->
  new Post.Dropdown('li.dropdown')
