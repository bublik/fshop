$ ->
  SeachFilter = Backbone.View.extend(
    el: "#searchfilter"
    events:
      'click input': 'search'
      'slidechange #price_slider': 'search'
    initialize: ->
      @form = @$('#filter_form')
      return

    go: ()->
      $('.style-tips').html('')
      condition = @form.serialize()
      router.navigate("products/search/?" + condition);
      @form.submit()

    search: (e)->
      selected = []
      $('#selected_tags').html('')
      _.each @$('input').filter(':checked'), (checkbox)->
        _tag = $(checkbox).val()
        $('#selected_tags').append("<a href='/products/tag/" + _tag + "' class='selected_tag btn btn-default btn-xs'>" + _tag + "</a> ")
      @go()
  )

  TagsList = Backbone.View.extend(
    el: '#selected_tags'
    events:
      'click .selected_tag': 'removetag'
    initialize: ->
    removetag: (e)->
      $('#selected_tags h3').html('')
      _tag = $(e.target).html()
      _.each window.search.$('input').filter(':checked'), (checkbox)->
        if $(checkbox).val() is _tag
          $(checkbox).attr('checked', false)

      $(e.target).remove()
      window.search.go()
      e.preventDefault()
      return false
  )

  SearchRouter = Backbone.Router.extend(
    routes:
      "products/search/?:query": "search"
    search: (query) ->
      return
  )

  window.search = new SeachFilter()
  window.tags_list = new TagsList()
  window.router = new SearchRouter()

  Backbone.history.start
    pushState: true
  #root: "/products/"
  if window.location.hash.indexOf('!') > -1
    window.location = window.location.hash.substring(2)
