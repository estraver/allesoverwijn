class Post.PublishedOn
  constructor: (selector) ->
    @input = $(selector).find('input[type="hidden"]')
    @date_picker = $(selector).find('[data-provide="datepicker"]')

    $(document).on 'click', selector + ' input[type="radio"]', $.proxy(@handle_click, @)
    $(document).on 'changeDate',  selector + ' [data-provide="datepicker"]', $.proxy(@changed_date, @)

  handle_click: (evt) ->
    if $(evt.target).val() == 'manual'
      @date_picker.attr('data-date', @input.val())
      @date_picker.datepicker()
    else
      @date_picker.datepicker('remove')

  changed_date: (evt) ->
    rails_date = evt.date.getFullYear() + '-' + ('0' + (evt.date.getMonth() + 1)).slice(-2) + '-' + ('0' + evt.date.getDate()).slice(-2)
    @input.val(rails_date)

#  @input.val @date_picker.datepicker('getFormattedDate')

$(document).on 'page:change', ->
  new Post.PublishedOn('#published_on')