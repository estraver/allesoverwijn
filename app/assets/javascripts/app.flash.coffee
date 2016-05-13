class App.Flash
  flash_class: {success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info'}

  flash_icon: {
    success: 'glyphicon-ok-sign',
    error: 'glyphicon-exclamation-sign',
    alert: 'glyphicon-warning-sign',
    notice: 'glyphicon-info-sign'
  }

  placeholder: 'main'

  constructor: (@type, @msg) ->

  render: ->
    @create_msg_box().append($('<span>').addClass('message').text(@msg)).prependTo $(@placeholder)

  create_msg_box: ->
    msgbox = $('<div>').addClass('alert fade in ' + @flash_class[@type]).attr { 'data-alert': @type, role: 'alert' }
    icon = $('<span>').addClass('glyphicon ' + @flash_icon[@type])
    sr = $('<span>').addClass('sr-only').text if @type == 'error' then 'Error:' else 'Info:'
    closebtn = $('<button>').addClass('close').attr({type: 'button', 'data-dismiss': 'alert', 'aria-hidden': true }).html '&times;'

    msgbox
    .append icon
    .append sr
    .append closebtn

App.Flash.clear= ->
    $(@prototype.placeholder).find('div.alert').remove()