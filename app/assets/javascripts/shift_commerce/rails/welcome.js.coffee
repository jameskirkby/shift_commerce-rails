# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stringStartsWith = (string, prefix) ->
  string.slice(0, prefix.length) == prefix

# The Bloodhoud code is poorly documented and not intuitive
$(document).on 'ready page:load', (event) ->
  proxyForBackend = new Bloodhound(
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.isim
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/suggestive_search/search'
      ajax:
        type: 'GET'
      replace: (url, query) ->
        url + '?field_name=title&suggestion=' + query
  )
  proxyForBackend.initialize()

  items = document.location.search.substr(1).split("&");
  index = 0
  while index < items.length
    tmp = items[index].split('=')
    if stringStartsWith tmp[0], '_facet_'
      document.getElementById(decodeURI(tmp[0])).checked = true
      document.getElementById(decodeURI(tmp[0])).value = tmp[1]

    index++

  $('.typeahead').typeahead {
      hint: false
      highlight: true
      minLength: 1
    },
    name: 'proxyForBackend'
    source: proxyForBackend.ttAdapter()

$ ->
  $('a, button').click ->
    $(this).toggleClass 'active'
    return
  return
