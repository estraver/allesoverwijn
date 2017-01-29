class Post.Close
  constructor: (@form) ->
    @closeBtn = $(@form).find('button[formaction=close]')

#    $(document).off 'click', @form + ' button[formaction=close]'
    $(document).on 'click', @form + ' button[formaction=close]', $.proxy(@onClick, @)


  onClick: (evt) ->
    url = $(@form).prop('action') + '/' + @closeBtn.attr('formaction')
    params = $(@form).serialize()

    params = params + '&' + $.param(@closeBtn.data('params')) if @closeBtn.data('params')

    $.ajax
      url: url
      data: params
      method: 'GET'
      dataType: 'json'
    .done (data)->
      switch data.status
        when 'confirm'
          confirmFn = (e)->
            $closeBtn= $('form').find('button[formaction=close]');
            $closeBtn.data
              params:
                confirmed: true
            @dialog.modal('hide')
            $closeBtn.click()

          new App.Dialog(data.title, data.message, confirmFn, ->).render();
        when 'redirect'
          window.location.href = data.location
        else
          new App.Flash('error', 'Please reload the page and try again').render()
#          FIXME: Default messages in message class

$(document).on 'app:init', ->
  new Post.Close('form')