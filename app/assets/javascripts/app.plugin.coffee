class App.EventRegistration
  instance = null

  class Register
    constructor: ->
      @instances = {}
    add: (selectors, controller) ->
    delete: (selectors, controller) ->

  @init: ->
    instance ?= new Register()

  @register: (selectors, controller) ->

  @unregister: (selectors, controller) ->
