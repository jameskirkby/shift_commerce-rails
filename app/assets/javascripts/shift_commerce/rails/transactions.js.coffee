$(document).on 'ready page:load', (event) ->
  # Here, we hide the spreedly and secure trading forms until the user wants them
  # If JS is disabled then they will both then naturally show
  # Although how far anyone would get with JS disabled is questionable.
  $('[data-behavior="spreedly_form"]').hide()
  $('[data-behavior="secure_trading_form"]').hide()

  $('[data-action="select_spreedly"]').on 'click', (event) ->
    $('[data-behavior="spreedly_form"]').toggle()
  $('[data-action="select_secure_trading"]').on 'click', (event) ->
    $('[data-behavior="secure_trading_form"]').toggle()

