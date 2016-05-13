class App.DatePicker
  constructor: ->
    $(document).on 'changeDate', '.bootstrap-datepicker', (evt) ->
      rails_date = evt.date.getFullYear() + '-' + ('0' + (evt.date.getMonth() + 1)).slice(-2) + '-' + ('0' + evt.date.getDate()).slice(-2)
      $(this).next("input[type=hidden]").val(rails_date)

    $(document).on 'click', 'div.bootstrap_datepicker .input-group-addon', (evt) ->
      $('input.bootstrap_datepicker').datepicker 'show'

$(document).on 'page:change', ->
  new App.DatePicker()