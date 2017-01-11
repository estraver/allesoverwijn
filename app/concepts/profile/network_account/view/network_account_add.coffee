window.Profile ||= {}

class Profile.NetworkAccount
  constructor: (@el) ->
    $(document).on 'click', @el, $.proxy(@onClick, @)
    $(document).on 'ajax:success', 'form[id^="network_accounts"]', $.proxy(@onSuccess, @)

    @panel = $('#network_account_list')
    @form = $('form[id^="network_accounts"]')

  onClick: (evt) ->
    $target  = $(evt.currentTarget)
    evt.preventDefault()
    $.ajax
      url: $target.attr('href')
      context: @
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown ) ->
        errors = try
          $.parseJSON(jqXHR.responseText);
        catch err
          {error: "Please reload the page and try again"}

        new App.Flash('error', errors.error).render()

      success: (data, textStatus, jqXHR) ->
        $data = $(data)
        @panel.append $data
        new App.Form.Select($data.find('select.form-control'));
        @enableSaveButton()

  enableSaveButton: ->
    $submit = @form.find('input[type=submit]')
    $submit.toggleClass('hide') if !$submit.is(':visible')

  onSuccess: (evt, response, status) ->
    $response = $(response)
    @form.replaceWith $response
    new App.Form.Select($response.find('select.form-control'));

$(document).on 'turbolinks:load', ->
  new Profile.NetworkAccount('a.add-relation.network-account')