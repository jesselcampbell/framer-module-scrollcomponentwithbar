class ScrollComponentWithBar extends ScrollComponent
  @define "scrollBar", get: -> return @_scrollBar

  # Using @proxyProperty here, which is undocumented, but is used in some Framer components.
  # Defined in BaseClass: https://github.com/koenbok/Framer/blob/6c8224f651c00d9c21db5f954090cc44d947fb4d/framer/BaseClass.coffee#L73
  # Used in the ScrollComponent: https://github.com/koenbok/Framer/blob/ebdd729648203abd7ae33f026a256667cc1c00f3/framer/Components/ScrollComponent.coffee#L56
  @define "scrollVisible", @proxyProperty("scrollBar.visibility")
  @define "scrollTrackColor", @proxyProperty("scrollBar.trackColor")
  @define "scrollThumbColor", @proxyProperty("scrollBar.thumbColor")

  constructor: (options={}) ->
    super options

    @_scrollBar = new ScrollBar
      parent: @
      name: "scrollbar"

    # Based on its use in the ScrollComponent documentation:
    # Only at this point we can set all the proxy properties, because before this the scrollBar layer did not exist. So we have to apply those again.
    @_applyProxyDefaults(options)

    @content.on("change:size", @scrollBar.updateScrollBar)
    @on("change:size", @scrollBar.updateScrollBar)

    # Debounce so it doesn't get called multiple times in succession
    scrollEndHandler = Utils.debounce 2.5, =>
      Utils.delay 2.5, => @_scrollBar.animate("hidden")

    if @scrollVisible is "autohide"
      @on Events.ScrollStart, (e,l) => if @content.height > @height then @_scrollBar.stateSwitch("default")
      @on Events.ScrollEnd, (e,l) => scrollEndHandler()
      scrollEndHandler()

    # Hide by default
    unless @scrollVisible is "visible" then @_scrollBar.stateSwitch("hidden")



class ScrollBar extends Layer
  @define "visibility",
    get: -> return @_visibility
    set: (value) -> @_visibility = value

  @define "trackColor",
    get: -> return @_trackColor
    set: (value) -> @_trackColor = value

  @define "thumbColor",
    get: -> return @_thumbColor
    set: (value) -> @_thumbColor = value


  constructor: (options={}) ->
    options.width ||= 16
    options.height ||= options.parent.height - 8
    options.x ||= Align.right
    options.y ||= Align.top
    options.backgroundColor ||= null
    @_visibility ||= "autohide"
    @_trackColor ||= null
    @_thumbColor ||= "rgba(0,0,0,0.5)"
    super options

    @scrollComponent = @parent
    @scrollContent = @parent.childrenWithName("content")[0]
    @height = @scrollComponent.height
    @thumbInset = 4

    @track = new Layer
      parent: @
      name: "track"
      x: Align.center
      y: @thumbInset / 2
      width: @width - 8
      height: @height - @thumbInset
      borderRadius: (@width * 0.6) / 2
      backgroundColor: @_trackColor

    @thumb = new Layer
      parent: @
      name: "thumb"
      x: Align.center
      y: @thumbInset / 2
      width: @width - 8
      height: (@height - @thumbInset) * (@scrollComponent.height / @scrollContent.height)
      borderRadius: (@width * 0.6) / 2
      backgroundColor: @_thumbColor
      shadowColor: "rgba(255,255,255,0.5)"
      shadowBlur: 2

    @thumb.draggable.enabled = true
    @thumb.draggable.horizontal = false
    @thumb.draggable.constraints = @
    @thumb.draggable.overdrag = false
    @thumb.draggable.momentum = false
    @thumb.draggable.bounce = false

    @states.hidden =
      opacity: 0
      animationOptions:
        curve: Bezier(0.4, 0, 0.2, 1)
        time: 0.4


  updateScrollBar: =>
    @height = @scrollComponent.height
    @thumb.height = @height * (@scrollComponent.height / @scrollContent.height)

    trackPiece = @height - @thumb.height - @thumbInset
    overflowHeight = @scrollContent.height - @scrollComponent.height

    if @_visibility is "hidden"
      @stateSwitch("hidden")
    else if @visibility is "visible" or @scrollContent.height > @scrollComponent.height
      @stateSwitch("default")

    @thumb.on "change:frame", =>
      if @thumb.draggable.isDragging
        yPos = Utils.modulate(@thumb.y, [0, trackPiece], [0, overflowHeight], false)
        @scrollComponent.scrollY = yPos

    @scrollContent.on "change:frame", =>
      if !@thumb.draggable.isDragging
        yPos = Utils.modulate(@scrollComponent.scrollY, [0, overflowHeight], [0, trackPiece], false)
        @thumb.y = yPos

        if @scrollComponent.scrollY <= 0
          overScrollPerc = Math.abs(@scrollComponent.scrollY) / @scrollComponent.height
          @thumb.height = (@height * (@scrollComponent.height / @scrollContent.height)) * (1 - overScrollPerc)
          @thumb.y = Align.top(@thumbInset / 2)

        if @scrollComponent.scrollY >= @scrollContent.height - @scrollComponent.height
          overScrollPerc = (Math.abs(@scrollComponent.scrollY) - overflowHeight) / @scrollComponent.height
          @thumb.height = (@height * (@scrollComponent.height / @scrollContent.height)) * (1 - overScrollPerc)
          @thumb.y = Align.bottom(-@thumbInset / 2)



module.exports = ScrollComponentWithBar
