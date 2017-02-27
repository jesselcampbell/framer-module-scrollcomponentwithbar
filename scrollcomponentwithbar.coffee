class ScrollComponentWithBar extends ScrollComponent
  @define "scrollBar",
    importable: false
    exportable: false
    get: -> return @_scrollBar

  @define "scrollVisible",
    get: -> return @_scrollVisible
    set: (value) -> @_scrollVisible = value

  @define "scrollTrackColor",
    get: -> return @_scrollTrackColor
    set: (value) -> @_scrollTrackColor = value

  @define "scrollThumbColor",
    get: -> return @_scrollThumbColor
    set: (value) -> @_scrollThumbColor = value


  constructor: (options={}) ->
    @_scrollVisible ||= "auto"
    @_scrollTrackColor ||= null
    @_scrollThumbColor ||= "rgba(0,0,0,0.5)"
    super options

    if @_scrollVisible is "hidden" then return

    # Update scroll bar when content or component changes
    @content.on("change:size", @updateScrollBar)
    @on("change:size", @updateScrollBar)

    # Make a scroll bar
    @makeScrollBar()

    # This needs to be more of a timer function that gets reset on ScrollStart
    @_autoHideHandler = Utils.debounce 2.5, =>
      Utils.delay 2.5, => @_scrollBar.animate("hidden")

    # Add autohide functionality
    if @_scrollVisible is "auto"
      @_autoHideHandler()
      @on Events.ScrollStart, (e,l) => if @content.height > @height then @_scrollBar.stateSwitch("default")
      @on Events.ScrollEnd, (e,l) => @_autoHideHandler()


  makeScrollBar: () ->
    @_inset = 4

    @_scrollBar = new Layer
      parent: @
      name: "scrollbar"
      width: 16
      height: @height
      x: Align.right
      backgroundColor: null

    @_scrollBar.states.hidden =
      opacity: 0
      animationOptions:
        curve: Bezier(0.4, 0, 0.2, 1)
        time: 0.4

    @_track = new Layer
      parent: @_scrollBar
      name: "track"
      x: Align.center
      y: Align.center
      width: @_scrollBar.width - 8
      height: @_scrollBar.height - @_inset
      borderRadius: (@width * 0.6) / 2
      backgroundColor: @_scrollTrackColor

    @_thumb = new Layer
      parent: @_scrollBar
      name: "thumb"
      x: Align.center
      y: @_track.y
      width: @_track.width
      height: (@height - 4) * (@height / @content.height)
      borderRadius: (@width * 0.6) / 2
      backgroundColor: @_scrollThumbColor
      shadowColor: "rgba(255,255,255,0.5)"
      shadowBlur: 2

    @_thumb.draggable.enabled = true
    @_thumb.draggable.horizontal = false
    @_thumb.draggable.constraints = @
    @_thumb.draggable.overdrag = false
    @_thumb.draggable.momentum = false
    @_thumb.draggable.bounce = false


  updateScrollBar: =>
    if @_scrollVisible is "auto"
      if @content.height > @height then @_scrollBar.stateSwitch("default") else @_scrollBar.stateSwitch("hidden")
      @_autoHideHandler()

    @_scrollBar.height = @height
    @_track.height = @_scrollBar.height - @_inset
    @_track.y = Align.center
    @_thumb.height = @_track.height * (@_scrollBar.height / @content.height)

    trackPiece = @_scrollBar.height - @_thumb.height - @_inset
    overflowHeight = @content.height - @_scrollBar.height

    @_thumb.on "change:frame", =>
      if @_thumb.draggable.isDragging
        yPos = Utils.modulate(@thumb.y, [0, trackPiece], [0, overflowHeight], false)
        @scrollY = yPos

    @_content.on "change:frame", =>
      if !@_thumb.draggable.isDragging
        yPos = Utils.modulate(@scrollY, [0, overflowHeight], [0, trackPiece], false)
        @_thumb.y = yPos

        if @scrollY <= 0
          overScrollPerc = Math.abs(@scrollY) / @_track.height
          @_thumb.height = (@_track.height * (@_scrollBar.height / @content.height)) * (1 - overScrollPerc)
          @_thumb.y = Align.top(@_inset / 2)

        else if @scrollY >= @content.height - @_scrollBar.height
          overScrollPerc = (Math.abs(@scrollY) - overflowHeight) / @_scrollBar.height
          @_thumb.height = (@_track.height * (@_scrollBar.height / @content.height)) * (1 - overScrollPerc)
          @_thumb.y = Align.bottom(-@_inset / 2)



module.exports = ScrollComponentWithBar
