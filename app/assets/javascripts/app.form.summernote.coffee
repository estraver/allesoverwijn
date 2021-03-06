#TODO: Add Mentions (mention other users)
#TODO: Add hints voor emoji's
#TODO: Add links too other posts (like @ with users)
class App.Form.Summernote
  constructor: (@selector) ->
    $(document).on 'form:error', ':input:hidden' + @selector, $.proxy(@onError, @)
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

  summernote: ->
    $(@selector).siblings().find('.note-editable')

  onError: (evt, data) ->
    $("<span>").addClass('glyphicon glyphicon-remove form-control-feedback').appendTo @summernote()
    $("<span>").addClass('help-block').html(data.error.join(', ')).appendTo @summernote().parent().parent()
    false


$(document).ready ->
  new App.Form.Summernote('[data-provider="summernote"]')