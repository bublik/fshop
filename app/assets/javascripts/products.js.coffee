$ ->
  # ajax pagination endless page
  if $('.item-list .pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()

  # Search from  - Pricee slider
  if $("#price_slider").length
    window.max_price ||= 1000
    $price = $("#price_slider").slider(
      range: true
      max: max_price
      values: [
        enabled_price_min || 0
        enabled_price_max || max_price
      ]
      step: max_price * 0.10
    )
    $price.slider("pips").slider "float",
      rest: "label"
      prefix: "$"
      formatLabel: (value) ->
        value

    $price.on "slidechange", (event, ui) ->
      $('#min_price').val(ui.values[0])
      $('#max_price').val(ui.values[1])
      return

  #Show more coupons on the show page
  $('.show-more').on 'click', (e) ->
    $(e.target).hide()
    $('.coupons .coupon').removeClass('hidden')