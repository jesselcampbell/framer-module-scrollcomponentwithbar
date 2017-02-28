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

    # Make the scroll bar elements
    @_inset = 4

    @_scrollBar = new Layer
      parent: @
      name: "scrollbar"
      width: 16
      height: @height
      x: Align.right
      backgroundColor: null

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
    @_thumb.draggable.overdrag = false
    @_thumb.draggable.constraints = @_track

    @_fadeOut = new Animation @_scrollBar,
      opacity: 0
      animationOptions:
        curve: Bezier(0.4, 0, 0.2, 1)
        time: 0.4

    @_autohideCount = 2500
    Utils.interval 0.5, =>
      @_autohideCount = @_autohideCount - 500
      if @_autohideCount <= 0 then @_fadeOut.start()

    @updateScrollBar()
    @on "change:size", @updateScrollBar
    @content.on "change:size", @updateScrollBar


  updateScrollBar: =>
    if @_scrollVisible is "visible" then @_scrollBar.opacity = 1
    else if @_scrollVisible is "hidden" then @_scrollBar.opacity = 0
    else
      if @content.height > @height
        @_fadeOut.stop()
        @_scrollBar.opacity = 1
        @_autohideCount = 2500

        @on Events.Scroll, (e,l) =>
          @_fadeOut.stop()
          @_scrollBar.opacity = 1
          @_autohideCount = 2500

      else @_scrollBar.opacity = 0


    # Size elements
    @_scrollBar.height = @height
    @_track.height = @_scrollBar.height - @_inset
    @_thumb.height = @_track.height * (@height / @content.height)
    @_thumb.draggable.constraints = @_track

    trackPieceHeight = @_track.height - @_thumb.height
    overflowHeight = @content.height - @height


    @_content.on "change:y", =>
      if @content.height > @height then @_scrollBar.opacity = 1

      # Change the thumb position when dragging the content
      if !@_thumb.draggable.isDragging
        yPos = Utils.modulate(@scrollY, [0, overflowHeight], [0, trackPieceHeight], false)
        @_thumb.y = yPos

        # Squeeze the thumb on overscroll (top)
        if @scrollY <= 0
          overScrollPerc = Math.abs(@scrollY) / @_track.height
          @_thumb.height = (@_track.height * (@_scrollBar.height / @content.height)) * (1 - overScrollPerc)
          @_thumb.y = Align.top(@_inset / 2)

        # Squeeze the thumb on overscroll (bottom)
        else if @scrollY >= @content.height - @_scrollBar.height
          overScrollPerc = (Math.abs(@scrollY) - overflowHeight) / @_scrollBar.height
          @_thumb.height = (@_track.height * (@_scrollBar.height / @content.height)) * (1 - overScrollPerc)
          @_thumb.y = Align.bottom(-@_inset / 2)


    @_thumb.on "change:y", =>
      # Change the scroll position when dragging the thumb
      if @_thumb.draggable.isDragging
        yPos = Utils.modulate(@_thumb.y, [0, trackPieceHeight], [0, overflowHeight], false)
        @scrollY = yPos



module.exports = ScrollComponentWithBar
