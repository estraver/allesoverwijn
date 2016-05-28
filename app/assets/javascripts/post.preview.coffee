class Post.Preview
  constructor: (@form) ->
    @previewBtn = $(@form).find('button[formaction=preview]')

    $(document).off 'click', @form + ' button[formaction=preview]'
    $(document).on 'click', @form + ' button[formaction=preview]', $.proxy(@onClick, @)

  onClick: (evt) ->
    url = $(@form).prop('action') + '/' + @previewBtn.attr('formaction')
    params = $(@form).serialize()

    window.open(url + '?' + params)

#    $.ajax
#      url: url
#      data: params
#      method: 'GET'
#      async: false
#    .done (data) ->
#      w = window.open(@url)
#      w.document.open()
#      w.document.write(data)
#      w.document.close()

$(document).on 'page:change', ->
  new Post.Preview('form')