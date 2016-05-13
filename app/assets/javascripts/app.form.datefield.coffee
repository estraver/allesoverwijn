class App.Form.Datefield
  constructor: (@class) ->
    $(document).on 'focus', 'input.' + @class, $.proxy(@add_focus, @)
    $(document).on 'focus', 'input:not(.' + @class + ')', $.proxy(@clear_focus, @)
    $(document).on 'keyup', 'input.' + @class, $.proxy(@onKeyup, @)
    $(document).on 'change', 'input.' + @class, $.proxy(@onChange, @)
    $(document).on 'form:error', 'input.' + @class + '[type=hidden]', $.proxy(@onError, @)

  datefield: ->
    $('div.' + @class + ':not(.form-group)')

  add_focus: (evt) ->
    @datefield().addClass 'focus' if not @datefield().hasClass 'focus'

  clear_focus: (evt) ->
    @datefield().removeClass 'focus' if @datefield().hasClass 'focus'

  onKeyup: (evt) ->
    $target = $(evt.target)

    if $target.hasClass(@class)
      if $target.prop('maxlength') == $target.val().length
        return if $.inArray(evt.which, [9, 16, 37, 39]) != -1
        $next = $target.next('input.' + @class)
        if $next
          $next.focus()
          $next.select() if $next.val().length != 0
        else
          $target.blur()

  onChange: (evt) ->
    year = month = day = 0
    $hidden = @datefield().find(':input[type=hidden]')
    $('input.' + @class + ':not(input[type=hidden])').each ->
      year = $(this).val() if $(this).is('[data-date-component=year]')
      month = $(this).val() if $(this).is('[data-date-component=month]')
      day = $(this).val() if $(this).is('[data-date-component=day]')

    $hidden.val(year + '-' + month + '-' + day)

  onError: (evt, data) ->
    $("<span>").addClass('glyphicon glyphicon-remove form-control-feedback').appendTo @datefield()
    $("<span>").addClass('help-block').html(data.error.join(', ')).appendTo @datefield().parent()
    false

$(document).on 'page:change', ->
  new App.Form.Datefield('datefield')