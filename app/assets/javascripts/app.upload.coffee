class App.Upload
  constructor: (@el) ->
    $(document).on 'click', @el, $.proxy(@onClick, @)
    @input = $('<input>').attr type: 'file'

  onClick: (evt) ->
    $target  = $(evt.currentTarget)
    @input.attr name: $target.data('upload-field')

    @input.fileupload
      dataType: 'json'
      url: $(evt.currentTarget).data('url')
      done: (e, data) ->
        model = $.parseJSON(data.result.model)
        $target
          .find('img').attr 'src', model.profile_picture_url
        $target
          .find('.progress').hide()

      fail: (e, data) ->
        errors = try
          $.parseJSON(data.jqXHR.responseText);
        catch err
          {error: "Please reload the page and try again"}

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

$(document).on 'page:change', ->
  new App.Upload('a[data-upload]')