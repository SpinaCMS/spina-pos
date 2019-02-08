addValue = (value) ->
  $keypad = $('.cash-keypad')
  $output = $keypad.find('.cash-keypad-price')
  currentValue = $output.attr('data-keypad-value')
  value = "#{currentValue}#{value}"

  num = numeral(parseInt(value) / 100).format("0,0.00")

  $output.attr('data-keypad-value', parseInt(value))
  $output.text(num)

  treshold = parseFloat($keypad.find(".cash-keypad-treshold").attr('data-keypad-treshold'))
  if (parseInt(value) / 100) >= treshold
    $output.removeClass('text-muted')

  $('#payment_received').val(num)

removeOne = ->
  $keypad = $('.cash-keypad')
  $output = $keypad.find('.cash-keypad-price')
  currentValue = $output.attr('data-keypad-value')
  value = currentValue.substring(0, currentValue.length - 1)

  if value == ''
    $output.attr('data-keypad-value', 0)
    $output.text('0,00')
    $output.addClass('text-muted')
  else
    num = numeral(parseInt(value) / 100).format("0,0.00")
    $output.attr('data-keypad-value', parseInt(value))
    $output.text(num)

  treshold = parseFloat($keypad.find(".cash-keypad-treshold").attr('data-keypad-treshold'))
  if (parseInt(value) / 100) < treshold
    $output.addClass('text-muted')

  $('#payment_received').val(num)

setValue = (value) ->
  $keypad = $('.cash-keypad')
  $output = $keypad.find('.cash-keypad-price')
  num = numeral(parseInt(value)).format("0.00")
  $output.attr('data-keypad-value', value * 100)
  $output.text(num)

  treshold = parseFloat($keypad.find(".cash-keypad-treshold").attr('data-keypad-treshold'))
  if parseInt(value) >= treshold
    $output.removeClass('text-muted')
  else
    $output.addClass('text-muted')

  $('#payment_received').val(num)

$(document).on 'touchstart', '.cash-keypad-input-button', (e) ->
  $button = $(this)
  
  if value = $button.attr('data-keypad-input-value')
    if value == 'delete'
      removeOne()
    else
      addValue(value)
  else if value = $button.attr('data-keypad-input-exact-value')
    setValue(value)
