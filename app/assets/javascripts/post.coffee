window.Post ||= {}

Post.init = ->
#  $("a, span, i, div").tooltip()

$(document).on "page:change", ->
  Post.init()