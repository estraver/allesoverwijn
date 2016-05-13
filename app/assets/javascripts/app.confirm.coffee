class App.Confirm
  templates:
    dialog:  "<div class='modal fade' tabindex='-1' role='dialog'>" +
             "<div class='modal-dialog'>" +
             "<div class='modal-content'>" +
             "<div class='modal-body'><div class='bootbox-body'></div></div>" +
             "</div>" +
             "</div>" +
             "</div>"
    header: "<div class='modal-header'>" +
            "<h4 class='modal-title'></h4>" +
            "</div>"
    footer: "<div class='modal-footer'></div>",
    closeBtn: "<button type='button' class='bootbox-close-button close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
    cancelBtn: "<button type='button' class='btn btn-default' data-dismiss='modal'>Cancel</button>"
    confirmBtn: "<button type='button' class='btn btn-primary'>Confirm</button>"

  constructor: (@title, @message, @confirmFn, @cancelFn) ->

  render: ->
    @dialog = @create_confirm_dialog()

    @dialog.modal('show')

    @dialog.on 'hidden.bs.modal', (evt) ->
      $(@).remove()

  create_confirm_dialog: ->
    $dialog= $(@templates.dialog)
    $header= $(@templates.header)
    $footer= $(@templates.footer)
    $cancelBtn= $(@templates.cancelBtn)
    $confirmBtn= $(@templates.confirmBtn)

    $cancelBtn.on 'click', $.proxy(@cancelFn, @)
    $confirmBtn.on 'click', $.proxy(@confirmFn, @)

    $innerDialog = $dialog.find '.modal-dialog'
    $body = $dialog.find '.modal-body'

    $body.find('.bootbox-body').html(@message);

    $header.find('.model-header').prepend(@templates.closeBtn)
    $header.find('.modal-title').html(@title)

    $body.before $header

    $footer
      .append $confirmBtn
      .append $cancelBtn

    $body.after($footer)

    $dialog