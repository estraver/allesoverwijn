class App.Upload
  constructor: (@el, @form_selector = 'form') ->
    $(document).on 'click', @el, $.proxy(@onClick, @)
    @input = $('<input>').attr type: 'file'
    @form = $(@form_selector)

  onClick: (evt) ->
    $target  = $(evt.currentTarget)
    @input.attr name: $target.data('upload-field')

    image_field = $target.data('image-field')
    image_thumb = $target.data('image-thumb')

    @input.fileupload
      dataType: 'json'
      url: $target.data('url')
      done: (e, data) ->
        $target
          .find('img').attr 'src', data.result[image_thumb + '_url']
        $target
          .find('.progress').hide()

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