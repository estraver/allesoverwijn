class App.AutoDialog
  constructor: (@link) ->
    $(document).on 'click', @link, $.proxy(@onClick, @)

  onClick: (evt) ->
    url = $(@link).data('dialog-url')
    title = $(@link).data('dialog-title')

    $.ajax
      url: url
      method: 'GET'
      dataType: 'html'
      context: @
    .done (data)->
      confirmFn = (e)->
        @dialog.find('form').submit()

      @dialog = new App.Dialog(title, $(data), confirmFn, ->).render
        classes: 'form-dialog'
        afterRender: ->
          new App.Form.Select('select.form-control')

      $(@dialog).on 'form:success', 'form', $.proxy(@onFormSuccess, @)

  onFormSuccess: (data) ->
    if @fire($(@link), 'dialog:confirmed', data)
      @dialog.modal('hide')
#      @dialog.remove()

  fire: ($el, name, data) ->
    event = $.Event(name)
    $el.trigger event, data
    event.result != false

$(document).ready ->
  new App.AutoDialog('a[data-dialog="auto"]')