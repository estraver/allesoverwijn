class App.Form.Input
  constructor: (@form) ->
    $(document).on 'change', @form + ' .has-error input:visible', $.proxy(@onChange, @)

  onChange: (evt) ->
    $input = $(evt.target)

    $input.parents('.has-error').find('span.form-control-feedback').remove()
    $input.parents('.has-error').find('span.help-block').remove()
    $input.parents('.has-error').removeClass('has-error')

$(document).ready ->
  new App.Form.Input('form')