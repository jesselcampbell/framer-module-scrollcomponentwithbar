# ScrollComponent with Scroll Bar
Demo: [https://framer.cloud/hYCvI](https://framer.cloud/hYCvI)

## Use
Place `scrollcomponentwithbar.coffee` into `myproject.framer/modules`
```coffee
ScrollComponentWithBar = require 'scrollcomponentwithbar'
myScroller = new ScrollComponentWithBar
  scrollVisible: "visible"
  scrollTrackColor: "rgba(0,0,0,0.1)"
  scrollTrackColor: "rgba(0,0,0,0.6)"
  # properties inherited from ScrollComponent
```

## Options
**ScrollComponentWithBar** is an extension of **ScrollComponent**, and all options are inherited from that class. Documentation for that can be found [here](https://framer.com/docs/#scroll.scrollcomponent).

- `scrollVisible` — Accepts `"visible"`, `"hidden"`, or `"auto"`. Defaults to `"auto"`
- `scrollTrackColor` — Accepts a Color object. Defaults to `null`
- `scrollThumbColor` — Accepts a Color object. Defaults to `"rgba(0,0,0,0.5)"`

## Features
- The scroll bar automatically hides if the content is shorter than the component height (ie. if there is no scrollable content).
- The scroll bar height and y-position automatically update as the ScrollComponentWithBar content updates.
