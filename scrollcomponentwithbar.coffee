class ScrollBar extends Layer
  constructor: (options={}) ->
    options.width ||= 16
    options.height ||= options.parent.height - 8
    options.x ||= Align.right
    options.y ||= Align.top
    options.backgroundColor ||= ""
    super options

    @scrollComponent = @parent
    @scrollContent = @parent.childrenWithName("content")[0]
    @height = @scrollComponent.height
    @thumbInset = 4

    @thumb = new Layer
      parent: @
      name: "thumb"
      x: Align.center
      y: @thumbInset / 2
      width: @width - 8
      height: @height * (@scrollComponent.height / @scrollContent.height)
      borderRadius: (@width * 0.6) / 2
      backgroundColor: "rgba(0,0,0,0.5)"
      shadowColor: "rgba(255,255,255,0.5)"
      shadowBlur: 2

    @thumb.draggable.enabled = true
    @thumb.draggable.horizontal = false
    @thumb.draggable.constraints = @
    @thumb.draggable.overdrag = false
    @thumb.draggable.momentum = false
    @thumb.draggable.bounce = false


  updateScrollBar: =>
    @height = @scrollComponent.height
    @thumb.height = @height * (@scrollComponent.height / @scrollContent.height)

    trackPiece = @height - @thumb.height - @thumbInset
    overflowHeight = @scrollContent.height - @scrollComponent.height

    if @scrollContent.height <= @scrollComponent.height then @visible = false else
      @visible = true

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


class ScrollComponentWithBar extends ScrollComponent
  constructor: (options={}) ->
    super options

    @scrollBar = new ScrollBar
      parent: @
      name: "scrollbar"
      visible: false

    @content.on("change:size", @scrollBar.updateScrollBar)
    @on("change:size", @scrollBar.updateScrollBar)


module.exports = ScrollComponentWithBar
