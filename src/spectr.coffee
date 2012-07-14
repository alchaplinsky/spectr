Spectr = {}
@Spectr = Spectr
Spectr.VERSION = '0.0.1'

class Spectr.Object
  
  events: {}
  resource: ''
  
  constructor: (params = document) ->
    if typeof params is 'object'
      if params instanceof jQuery || params is document
        @el = params
      else
        @el = params.root || document
        @attributes = params.attr || {}
    for event, callback of @events
      if event.match(/:/)
        bind = event.split(':')
        $(@el).on bind[0], bind[1], (event) =>
          data = $(event.target).data()
          data.target = event.target
          @[callback](data)
      else
        @subscribe(event, callback)
    @initialize if @initialize?
    
  escape: (string) =>
    escapes =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      "'": '&#x27;'
      '/': '&#x2F;'
    "#{string}".replace /[&<>"'\/]/g,  (match) =>
      escapes[match]
    
  get: (name) =>
    @attributes[name]
    
  set: (name, value) =>
    if typeof name is 'object' || name is null
      for key, val of name
        @attributes[key] = @escape(val)
    else
      @attributes[name] = @escape(value)
      
  isNew: =>
    @get('id') is undefined
    
  url: =>
    if @isNew() then @resource else "#{@resource}/#{@get('id')}"
    
  fetch: =>
    $.ajax
      url: @url()
      type: "GET"
      success: (json) =>
        @set(json)
      
  save: =>
    type = if @isNew() then "POST" else "PUT"
    $.ajax
      url: @url()
      type: type
      success: (json) =>
        @set(json)
  
  subscribe: (event, callback) =>
    $(document).on event, (event) =>
      @[callback](collectEventData(event))

  publish: (event, data = null) =>
    $(document).trigger(event, data)