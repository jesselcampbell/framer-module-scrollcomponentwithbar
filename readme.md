# ScrollComponent with Scroll Bar
Demo: [https://framer.cloud/hYCvI](https://framer.cloud/hYCvI)

## Use
Place `scrollcomponentwithbar.coffee` into `myproject.framer/modules`
```coffee
ScrollComponentWithBar = require 'scrollcomponentwithbar'
myScroller = new ScrollComponentWithBar
  # options inherited from ScrollComponent
```

## Options
**ScrollComponentWithBar** is an extension of **ScrollComponent**, and all options are inherited from that class. Documentation for that can be found [here](https://framer.com/docs/#scroll.scrollcomponent). The scroll bar currently doesn't have any options itself.

## Features
- The scroll bar automatically hides if the content is shorter than the component height (ie. if there is no scrollable content).
- The scroll bar height and y-position automatically update as the ScrollComponentWithBar content updates.
