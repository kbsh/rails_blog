ready = ->
  # Hatena
  loadHatenaSDK()

  # Facebook
  loadFacebookSDK()
  bindFacebookEvents() unless fb_events_bound

  # Twitter
  loadTwitterSDK()
  bindTwitterEventHandlers() unless twttr_events_bound

# For turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)

# ----------------------------------------- #
# Facebook
# ----------------------------------------- #
fb_root = null
fb_events_bound = false

bindFacebookEvents = ->
  $(document)
  .on('page:fetch', saveFacebookRoot)
  .on('page:change', restoreFacebookRoot)
  .on('page:load', ->
    FB?.XFBML.parse()
  )
  fb_events_bound = true

saveFacebookRoot = ->
  fb_root = $('#fb-root').detach()

restoreFacebookRoot = ->
  if $('#fb-root').length > 0
    $('#fb-root').replaceWith fb_root
  else
    $('body').append fb_root

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/ja_JP/all.js#xfbml=1")

initializeFacebookSDK = ->
  FB.init
    appId     : 858240187558951
    channelUrl: 'http://sk-create.biz/'
    status    : true
    cookie    : true
    xfbml     : true

# ----------------------------------------- #
# Twitter
# ----------------------------------------- #
twttr_events_bound = false

bindTwitterEventHandlers = ->
  $(document).on 'page:load', renderTweetButtons
  twttr_events_bound = true

renderTweetButtons = ->
  $('.twitter-share-button').each ->
    button = $(this)
    button.attr('data-url', document.location.href) unless button.data('url')?
    button.attr('data-text', document.title) unless button.data('text')?
  twttr.widgets.load()

loadTwitterSDK = ->
  $.getScript("//platform.twitter.com/widgets.js")

# ----------------------------------------- #
# Hatena
# ----------------------------------------- #
loadHatenaSDK = ->
  $.getScript("//b.st-hatena.com/js/bookmark_button_wo_al.js")

# ----------------------------------------- #
# Google Analytics
# ----------------------------------------- #
$(document).on 'page:load page:restore', ->
  if window.ga?
    ga('set', 'location', location.href.split('#')[0])
    ga('send', 'pageview')

# ----------------------------------------- #
# Google+
# ----------------------------------------- #
loadGoogleSDK = ->
  $.getScript("https://apis.google.com/js/plusone.js")

# ----------------------------------------- #
# Hatena
# ----------------------------------------- #
loadHatenaSDK = ->
  $.getScript("//b.st-hatena.com/js/bookmark_button_wo_al.js")

# ----------------------------------------- #
# Pocket
# ----------------------------------------- #
loadPocketSDK = ->
  $.getScript("https://widgets.getpocket.com/v1/j/btn.js?v=1")

# ----------------------------------------- #
# Google Analytics
# ----------------------------------------- #
class @GoogleAnalytics

  @load: ->
    # Google Analytics depends on a global _gaq array. window is the global scope.
    window._gaq = []
    window._gaq.push ["_setAccount", GoogleAnalytics.analyticsId()]

    # Create a script element and insert it in the DOM
    ga = document.createElement("script")
    ga.type = "text/javascript"
    ga.async = true
    ga.src = ((if "https:" is document.location.protocol then "https://ssl" else "http://www")) + ".google-analytics.com/ga.js"
    firstScript = document.getElementsByTagName("script")[0]
    firstScript.parentNode.insertBefore ga, firstScript

    # If Turbolinks is supported, set up a callback to track pageviews on page:change.
    # If it isn't supported, just track the pageview now.
    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener "page:change", (->
        GoogleAnalytics.trackPageview()
      ), true
    else
      GoogleAnalytics.trackPageview()

  @trackPageview: (url) ->
    unless GoogleAnalytics.isLocalRequest()
      if url
        window._gaq.push ["_trackPageview", url]
      else
        window._gaq.push ["_trackPageview"]
      window._gaq.push ["_trackPageLoadTime"]

  @isLocalRequest: ->
    GoogleAnalytics.documentDomainIncludes "local"

  @documentDomainIncludes: (str) ->
    document.domain.indexOf(str) isnt -1

  @analyticsId: ->
    # your google analytics ID(s) here...

GoogleAnalytics.load()
