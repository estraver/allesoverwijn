class App.Upload
  constructor: (@el, @form_selector = 'form') ->
    $(document).on 'click', @el, $.proxy(@onClick, @)
    @input = $('<input>').attr type: 'file'
    @form = $(@form_selector)

  onClick: (evt) ->
    $target  = $(evt.currentTarget)
    @input.attr name: $target.data('upload-field')

    image_field = $target.data('image-field')
    meta_data = @form.find(':input[name*=' + image_field + '_meta_data' + ']')

    @input.fileupload
      dataType: 'json'
      url: $target.data('url')
      formData:  $.map $target.data('sizes'), (resize) ->
        { name: '[sizes][' + Object.keys(resize)[0] + ']', value: resize[Object.keys(resize)[0]] }
      done: (e, data) ->
        model = $.parseJSON(data.result.model)
        $target
          .find('img').attr 'src', model.sidebar_url
        $target
          .find('.progress').hide()

        meta_data.val JSON.stringify(model.image_meta_data)

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
    evt.preventDefault()

$(document).on 'turbolinks:load', ->
  new App.Upload('a[data-upload]')