class App.Tabs
  constructor: (@tabs_selector) ->
    @tabs_selector += ' > li > a'
    $(document)
    .on 'click', @tabs_selector, @handle_click

  handle_click: (evt) ->
    evt.preventDefault()
    $target  = $(evt.currentTarget)

    $.ajax
      url: $target.data('url')
      context: @
#      contentType: 'text/javascript'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown ) ->
        errors = try
          $.parseJSON(jqXHR.responseText);
        catch err
          {error: "Please reload the page and try again"}

        new App.Flash('error', errors.error).render()

      success: (data, textStatus, jqXHR) ->
        panel = $($target.attr('href'))
        panel.html data
        $(@).tab('show')

$(document).on 'turbolinks:load', ->
  new App.Tabs('ul[data-toggle="tabs-remote"]')