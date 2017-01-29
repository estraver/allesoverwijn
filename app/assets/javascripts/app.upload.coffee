class App.Upload
  constructor: (@el, @form_selector = 'form') ->
    $(document).on 'click', @el, $.proxy(@onClick, @)
    @input = $('<input>').attr type: 'file'
    @input_retained = $('<input>').attr type: 'hidden'

    @form = $(@form_selector)

  onClick: (evt) ->
    evt.preventDefault()
    $target  = $(evt.currentTarget)
    @input.attr name: $target.data('upload-field')
    @input_retained.attr name: $target.data('retained-field')

    image_field = $target.data('image-field')
    image_thumb = $target.data('image-thumb')

    $form_input_retained = $(':input[name*="retained_' + image_field + '"]')

    @input.fileupload
      dataType: 'json'
      url: $target.data('url')
      formData: @input_retained.serializeArray()
      context: @
      done: (e, data) ->
        $target
          .find('img').attr 'src', data.result[image_thumb + '_url']
        $target
          .find('.progress').hide()

        $form_input_retained.val data.result['retained']
        data.context.input_retained.val data.result['retained']

      fail: (e, data) ->
        errors = try
          $.parseJSON(data.jqXHR.responseText);
        catch err
          {error: "Please reload the page and try again"}

        $target
          .find('.progress').hide()

        new App.Flash('error', errors.error).render()

      start: (e) ->
        $target.find('.progress').show()

      progress: (e, data) ->
        progress = data.loaded / data.total * 100
        $target
          .find('.progress-bar')
            .attr('aria-valuenow', progress)
            .css('width', progress + '%')
            .html(progress + '%')

    @input.click()


$(document).on 'app:init', ->
  new App.Upload('a[data-upload]')