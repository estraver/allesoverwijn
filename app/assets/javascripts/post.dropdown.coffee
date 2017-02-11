class Post.Dropdown
  constructor: (@dropdown, @keep_open = '.keep-open') ->
#    $(document).on 'click', $(@dropdown + @keep_open), (e) ->
#      @closeable = $(e.target).is('a[data-toggle=dropdown]')
#      true
#
#    $(document).on 'shown.bs.dropdown', $(@dropdown + @keep_open), ->
#      @closeable = false
#      true
#
#    $(document).on 'hide.bs.dropdown', $(@dropdown + @keep_open), ->
#      @closeable

    $(@dropdown + @keep_open).on
      'shown.bs.dropdown': ->
        @closeable = false
        true
      'hide.bs.dropdown': ->
        @closeable
      click: (e) ->
        @closeable = $(e.target).is('a[data-toggle=dropdown]')
        true

$(document).ready ->
  new Post.Dropdown('li.dropdown')
