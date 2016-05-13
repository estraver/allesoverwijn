class App.Form.Select
  constructor: (@el) ->
    $(@el).select2
      theme: 'bootstrap',
      minimumResultsForSearch: Infinity,
      templateResult: (el) ->
        return if !el.id
        $('<span><i class="fa fa-' + el.id + ' fa-fw"></i>' + el.id + '</span>')
      templateSelection: (data, container) ->
        $('<span><i class="fa fa-' + data.text + ' fa-fw"></i>' + data.text + '</span>')

#  template: (el) ->
#    console.dir(el)

$(document).on 'page:change', ->
  new App.Form.Select('select.form-control')