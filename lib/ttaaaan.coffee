$ = require("jquery")

{CompositeDisposable} = require 'atom'

module.exports = Ttaaaan =
    subscriptions: null
    active: false

    activate: (state) ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add 'atom-workspace', 'ttaaaan:toggle': => @toggle()

        @setup()
        @subscribeToActiveTextEditor()

    subscribeToActiveTextEditor: ->
        @canvas.style.display = "block" if @canvas

    setup: ->
        @editor = atom.workspace.getActiveTextEditor()
        @editor.getBuffer().onDidChange @onChange.bind(this)
        @editorElement = atom.views.getView @editor

        @enterimg = document.createElement "img"
        @enterimg.src = "atom://ttaaaan/img/1.png"
        @enterimg.width = 1037
        @enterimg.height = 418

        @canvas = document.createElement "canvas"
        @editorElement.parentNode.appendChild @canvas
        @context = @canvas.getContext "2d"
        @canvas.classList.add "ttaaaan-canvas"
        @w = @editorElement.offsetWidth
        @h = @editorElement.offsetHeight

        @canvas.width = @w
        @canvas.height = @h
        @canvasstate = false
        @otherkey = 0

    onChange: (e) ->
        return if not @active
        @canvas.style.display = "block" if @canvas
        newtext = escape(e.newText).replace(/%20|\s/g,"")
        if newtext is "%0A"
            r = -0.1
            @context.clearRect(0, 0, @w + 100, @h)
            @context.rotate(r)
            @context.translate(@w/2,@h/2)
            imgh = @enterimg.height * @w / @enterimg.width
            @context.drawImage @enterimg,-@w/2,-imgh/1.8,@w*0.9,imgh*0.9
            @context.translate(-@w/2,-@h/2)
            @context.rotate(-r)
            @canvasstate = true
        else if newtext != ""
            @otherkey++
            if @canvasstate
                @context.clearRect(0, 0, @w + 100, @h)
                @canvasstate = false
            if @otherkey > 2
                @otherkey = 0
                r = Math.random() * 0.05
                @context.rotate(r)
                ow = ( @w - 150 ) * Math.random()
                hw = ( @h - 150 ) - (50 * Math.random())
                @context.translate(ow, hw)
                @otherimg = document.createElement "img"
                @otherimg.src = "atom://ttaaaan/img/" + (Math.floor(Math.random() * 3) + 2) + ".png"
                @context.drawImage @otherimg,0,0
                @context.translate(-ow, -hw)
                @context.rotate(-r)
    toggle: ->
        @active = not @active
        unless @active
          @canvas.style.display = "none"
        console.log 'Ttaaaan was toggled!'
