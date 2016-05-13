#TODO: Add Mentions (mention other users)
#TODO: Add hints voor emoji's
#TODO: Add links too other posts (like @ with users)
class App.Form.Summernote
  constructor: (@selector) ->
    $(@selector).each ->
      $(@).summernote
        toolbar: [
          ['style', ['style', 'bold', 'italic', 'underline', 'clear']]
          ['font', ['strikethrough', 'superscript', 'subscript']]
          ['edit', ['undo', 'redo']]
          ['para', ['ul', 'ol', 'paragraph']]
          ['insert', ['link', 'picture']]
          ['misc', ['fullscreen']]
        ]
        dialogsFade: true

$(document).on 'page:change', ->
  new App.Form.Summernote('[data-provider="summernote"]')