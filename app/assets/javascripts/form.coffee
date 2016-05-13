#onLoad ->
#  $("form[data-remote]")
#    .on "ajax:before", -> $(@).find('.fa-spinner').toggleClass 'invisible'
#    .on "ajax:complete", -> $(@).find('.fa-spinner').toggleClass 'invisible'