data = Utils.domLoadJSONSync('data/cities.json')
ScrollComponentWithBar = require 'scrollcomponentwithbar'

# listItem Class
class listItem extends Layer
	@define "text",
		get: -> return @_text
		set: (value) -> @_text = value

	constructor: (options={}) ->
		options.width ||= Screen.width
		options.height ||= 240
		options._text ||= ""
		options.backgroundColor ||= null
		@_text = options._text
		super options

		textLayer = new Layer
			parent: @
			name: @text
			html: @text
			backgroundColor: ""
			x: Align.center
			y: Align.center
			width: @parent.width - 120
			height: 60
			style:
				"fontFamily"	:	"Roboto"
				"fontSize"		:	"48px"
				"lineHeight"	:	"60px"
				"color"			:	"#333"

bg = new BackgroundLayer
	backgroundColor: "white"

sc = new ScrollComponentWithBar
	name: "ScrollComponentWithBar"
	width: Screen.width
	height: Screen.height
	scrollHorizontal: false
	mouseWheelEnabled: true
	backgroundColor: ""

for item, index in data
	li = new listItem
		parent: sc.content
		y: 200 * index
		text: item.city
		backgroundColor: ""

	li.sendToBack()
	li.on Events.Click, (e,l) ->
		@destroy()
		updateList()

	sc.updateContent()

updateList = () ->
	items = sc.content.children

	for item, index in items
		item.y = 200 * index

	sc.updateContent()
