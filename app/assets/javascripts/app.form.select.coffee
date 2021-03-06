class App.Form.Select
  constructor: (@el) ->
    @iconCls = $(@el).data('icon')
    $(@el).select2
      theme: 'bootstrap',
      minimumResultsForSearch: Infinity,
      templateResult: (el) ->
        return if !el.id
        $('<span><i class="' + $(el.element).data('icon') + '"></i>' + el.id + '</span>')
      templateSelection: (data, container) ->
        $('<span><i class="' + $(data.element).data('icon') + '"></i>' + data.text + '</span>')

$(document).ready ->
  new App.Form.Select('select.form-control:not([data-role])')