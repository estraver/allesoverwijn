class App.Form
  constructor: (@form_selector) ->
    $(document)
      .on 'ajax:before', @form_selector, $.proxy(@handle_before, @)
      .on 'ajax:complete', @form_selector, $.proxy(@handle_complete, @)
      .on 'ajax:success', @form_selector, $.proxy(@handle_success, @)
      .on 'ajax:error', @form_selector, $.proxy(@handle_error, @)

  form: ->
    $(@form_selector)

  handle_error: (evt, xhr, status, error) ->
    $form = $(evt.target)
    errors = try
      # Populate errorText with the comment errors
      $.parseJSON(xhr.responseText);
    catch err
      # If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
      {error: "Please reload the page and try again"}

    @set_form_errors $form ,attr, errText for own attr, errText of errors.errors

    @flash $form, 'error', errors.error

  handle_success: (evt, response, status) ->
    $form = $(evt.target)
    @flash $form, 'success', response.success if response.success && status == 'success'
    @set_form_ids $form, response
    if $form.attr('method') == 'post'
      $form.attr 'method', 'patch'
      $form.attr 'url', $form.attr('url') + '/' + repsonse.id
    @fire($form, 'form:success', response)

  handle_complete: (evt) ->
    @toggle_spinner($(evt.target))

  handle_before: (evt) ->
    return if $(evt.target).is('a.add-relation')
    $form = $(evt.target)
    @toggle_spinner($form)
    @clear_form_errors($form)
    @clear_flash()

  clear_form_errors: ($form) ->
    $form.find('.has-error').removeClass 'has-error'
    $form.find('span.form-control-feedback').remove()
    $form.find('span.help-block').remove()

  set_form_errors: ($form, attr, errText) ->
    $input = @input($form, attr)
    $input.parents('div.form-group').addClass('has-error')
    if @fire($input, 'form:error', {error: errText})
      $("<span>").addClass('glyphicon glyphicon-remove form-control-feedback').appendTo $input.parent()
      $("<span>").addClass('help-block').html(errText.join(', ')).appendTo $input.parent()

  set_form_ids: ($form, response) ->
    $(input).val(@get_value_from_response(input, response)) for input in $form.find(':input[name*=id]')

  get_value_from_response: (input, response) ->
    name = $(input).attr('name').replace(/_attributes/g, '').replace(/]/g,'').replace(/\[/g, '.')
    list = name.split('.').splice 1
    value = response
    for key in list
      do (key) ->
        value=value[key] if value != undefined
    value

  toggle_spinner: ($form) ->
    $form.find('.fa-spinner').toggleClass 'invisible'

  flash: ($form, type, message) ->
    $placeholder = $form.find('.alert-message')

    new App.Flash(type, message).render($placeholder)

  clear_flash: ->
    App.Flash.clear()

  input: ($form, attr) ->
    attr = attr.replace(/(.*)\.(.*)/,'[\$1_attributes][\$2]')
    $form.find(":input[name*='" + attr + "']")

  fire: (input, name, data) ->
    event = $.Event(name);
    input.trigger event, data
    event.result != false

$(document).ready ->
  new App.Form('form[data-remote]')