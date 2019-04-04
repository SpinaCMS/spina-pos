window.Spina = {}

class Spina.PosPrinter

  constructor: (ip, current_user = '', ssl = true) ->
    if ssl
      @url = "https://#{ip}:443/StarWebPRNT"
    else
      @url = "http://#{ip}:80/StarWebPRNT"
    @current_user = current_user
    @width = 48
    @builder = new StarWebPrintBuilder()
    @request = ""
    @order_items = []
    @tax_lines = []
    @payment_method = ""
    @received_at = ""
    @order_number = ""

  getStatus: (callback) ->
    trader = new StarWebPrintTrader({url: "#{@url}/SendMessage"})
    trader.onError = (response) ->
      callback({status: 'error', message: response.responseText, response: response})
      
    trader.onReceive = (response) ->
      if response.traderCode is '0'
        callback({status: 'ok'})
      else 
        if trader.isCoverOpen({traderStatus: response.traderStatus})
          callback({status: 'error', message: 'Cover is open'})
        else if trader.isOffline({traderStatus: response.traderStatus})
          callback({status: 'error', message: 'Printer is offline'})
        else if trader.isPaperEnd({traderStatus: response.traderStatus})
          callback({status: 'error', message: 'End of paper'})
        else
          callback({status: 'error', message: 'Unknown error'})

    trader.sendMessage({request: ''})

  sendMessage: ->
    trader = new StarWebPrintTrader({url: "#{@url}/SendMessage", papertype: "", blackmark_sensor: "front_side"})
    trader.sendMessage({request: @request})

  print: (options = {}) ->
    image = new Image()
    image.src = "/receipt-logo.svg"
    image.onload = =>
      # Logo!
      this.renderLogo(image)

      # Header details
      this.renderHeader()

      # Render order lines
      for line in @order_items
        this.renderJustifiedLine(line.description, line.total)

      # Render subtotal
      this.renderSubtotal()

      # Render tax lines
      for line in @tax_lines
        this.renderJustifiedLine(line.rate, line.total)

      # Render total
      this.renderTotal()

      # Payment
      this.renderPayment()

      # Footer
      this.renderFooter()

      # Cut
      this.cut()

      # Open drawer
      this.openDrawer() if options.openDrawer

      # Send the message
      this.sendMessage()

  addOrderItem: (quantity, description, total) ->
    @order_items.push {description: "#{quantity} x #{description}", total: total}

  addTaxLine: (rate, total) ->
    @tax_lines.push {rate: "#{rate}% btw", total: total}

  addGiftCard: (gift_card_amount, to_be_paid) ->
    @gift_card = gift_card_amount
    @to_be_paid = to_be_paid

  setTotals: (sub_total, total) ->
    @sub_total = sub_total
    @total = total

  setReceivedAt: (received_at) ->
    @received_at = received_at

  setOrderNumber: (order_number) ->
    @order_number = order_number

  setPaymentMethod: (method) ->
    @payment_method = method

  renderLogo: (image) ->
    canvas = document.createElement("canvas")
    canvas.width = 576
    canvas.height = 320

    context = canvas.getContext("2d")
    context.drawImage(image, 0, 0, 331, 237, 81, 0, 414, 296)

    @request += @builder.createBitImageElement({context: context, x: 0, y: 0, width: canvas.width, height: canvas.height})

  renderHeader: ->
    this.renderLineCenter('SmokeSmarter', true)
    this.renderLineCenter('Keizersveld 25B')
    this.renderLineCenter('5803 AM, Venray')
    this.renderBreak()
    this.renderBreak()

    this.renderJustifiedLine(@received_at, @order_number)
    this.renderLine("Geholpen door #{@current_user}")
    this.renderHorizontalLine('thin')

  renderSubtotal: ->
    this.renderBreak()
    this.renderJustifiedLine('Subtotaal', @sub_total, true)

  renderTotal: ->
    this.renderHorizontalLine('thick')

    if @gift_card
      this.renderJustifiedLine('Totaal', @total, true)
      this.renderJustifiedLine('Cadeaubon', "–" + @gift_card)
      this.renderJustifiedLine('Te betalen', @to_be_paid, true, 2)
    else
      this.renderJustifiedLine('Totaal', @total, true, 2)


  renderPayment: ->
    this.renderBreak()
    this.renderJustifiedLine('Betaalwijze', @payment_method)

  renderFooter: ->
    this.renderBreak()
    this.renderBreak()
    this.renderLineCenter('Koop onze producten ook online op')
    this.renderLineCenter('www.smokesmarter.nl', true, 2)

  renderHorizontalLine: (thickness = 'medium') ->
    @request += @builder.createRuledLineElement({thickness: (thickness)})

  renderBreak: ->
    @request += @builder.createTextElement({data:'\n', emphasis: false, width: 1})

  renderLine: (line, emphasis = false, width = 1) ->
    this.renderJustifiedLine(line, '', emphasis, width)

  renderLineRight: (line, emphasis = false, width = 1) ->
    this.renderJustifiedLine('', line, emphasis, width)

  renderLineCenter: (line, emphasis = false, width = 1) ->
    @request += @builder.createAlignmentElement({position: 'center'})
    @request += @builder.createTextElement({data: line + '\n', emphasis: emphasis, width: width})
    @request += @builder.createAlignmentElement({position: 'left'})

  renderJustifiedLine: (line, line_right, emphasis = false, width = 1) ->
    maxlength = @width / width - line_right.length - 2

    for i in [0..Math.floor(line.length / maxlength)]
      begin = i * maxlength
      end = begin + maxlength
      rendered_line = line[begin...end]
      if i is 0
        padding = @width / width - rendered_line.length - line_right.length
        if padding >= 0
          rendered_line += " "
          rendered_line += " " while padding -= 1
        @request += @builder.createTextElement({codepage: 'utf8', emphasis: emphasis, width: width, data: rendered_line + line_right})
      else
        @request += @builder.createTextElement({data: rendered_line})
      this.renderBreak()

  openDrawer: ->
    @request += @builder.createPeripheralElement({channel: 1, on: 200, off: 200})

  cut: (feed_lines = 1)->
    @request += @builder.createFeedElement({line: feed_lines});
    @request += @builder.createCutPaperElement({feed:true})
