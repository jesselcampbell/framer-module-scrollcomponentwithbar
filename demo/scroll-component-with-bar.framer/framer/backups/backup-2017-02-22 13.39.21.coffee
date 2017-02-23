data = Utils.domLoadJSONSync('http://beta.json-generator.com/api/json/get/VJ-_NT8KG')
ScrollComponentWithBar = require 'scrollcomponentwithbar'

# listItem Class
class listItem extends Layer
	constructor: (options={}) ->
# 		options.width ||= Screen.width
		options.height ||= 240
		options._text ||= ""
		options.backgroundColor ||= ""
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
		print @width
		print @parent
	@define "text",
		get: -> return @_text
		set: (value) -> @_text = value

bg = new BackgroundLayer
	backgroundColor: "white"

sc = new ScrollComponentWithBar
	name: "ScrollComponent"
	width: Screen.width
	height: Screen.height
	scrollHorizontal: false
	mouseWheelEnabled: true
	backgroundColor: ""
	contentInset:
		right: 60
		left: 60

sc.childrenWithName("content")[0].backgroundColor = 

for item, index in data
	li = new listItem
		parent: sc.content
		y: 200 * index
		text: item.city
		backgroundColor: "red"
	li.sendToBack()
	sc.updateContent()
