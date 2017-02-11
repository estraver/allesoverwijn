window.App ||= {}

class App.Main
  instance = null

  class AppInit
    constructor: ->
      @event_registration = new App.EventRegistration()

    event_registration: ->
      @event_registration

  @init: ->
    unless instance
      instance = new AppInit()

      event = $.Event('app:init');
      $(document).trigger(event, @)

  @register: (selectors, controller) ->
    instance.event_registration.register(selectors, controller);

  @unregister: (selectors, controller) ->
    instance.event_registration.unregister(selectors, controller);

  @dialog: () ->

$(document).ready ->
  app = App.Main.init()