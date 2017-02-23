require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"scrollcomponentwithbar":[function(require,module,exports){
var ScrollBar, ScrollComponentWithBar,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScrollBar = (function(superClass) {
  extend(ScrollBar, superClass);

  function ScrollBar(options) {
    if (options == null) {
      options = {};
    }
    this.updateScrollBar = bind(this.updateScrollBar, this);
    options.width || (options.width = 24);
    options.height || (options.height = Screen.height - 12);
    options.x || (options.x = Align.right);
    options.y || (options.y = Align.center);
    options.backgroundColor || (options.backgroundColor = "");
    ScrollBar.__super__.constructor.call(this, options);
    this.scrollComponent = this.parent;
    this.scrollContent = this.parent.childrenWithName("content")[0];
    this.thumb = new Layer({
      parent: this,
      name: "thumb",
      x: Align.center,
      width: this.width - 12,
      height: this.height * (this.scrollComponent.height / this.scrollContent.height),
      borderRadius: (this.width * 0.6) / 2,
      backgroundColor: "rgba(0,0,0,0.5)",
      shadowColor: "rgba(255,255,255,0.5)",
      shadowBlur: 2
    });
    this.thumb.draggable.enabled = true;
    this.thumb.draggable.horizontal = false;
    this.thumb.draggable.constraints = this;
    this.thumb.draggable.overdrag = false;
    this.thumb.draggable.momentum = false;
    this.thumb.draggable.bounce = false;
  }

  ScrollBar.prototype.updateScrollBar = function() {
    var overflowHeight, trackPiece;
    if (this.scrollContent.height <= this.scrollComponent.height) {
      return this.visible = false;
    } else {
      this.thumb.height = this.height * (this.scrollComponent.height / this.scrollContent.height);
      this.visible = true;
      trackPiece = this.height - this.thumb.height;
      overflowHeight = this.scrollContent.height - this.scrollComponent.height;
      this.thumb.on("change:y", (function(_this) {
        return function() {
          var yPos;
          if (_this.thumb.draggable.isDragging) {
            yPos = Utils.modulate(_this.thumb.y, [0, trackPiece], [0, overflowHeight], false);
            return _this.scrollComponent.scrollY = yPos;
          }
        };
      })(this));
      return this.scrollContent.on("change:frame", (function(_this) {
        return function() {
          var overScrollPerc, yPos;
          if (!_this.thumb.draggable.isDragging) {
            yPos = Utils.modulate(_this.scrollComponent.scrollY, [0, overflowHeight], [0, trackPiece], false);
            _this.thumb.y = yPos;
            if (_this.scrollComponent.scrollY < 0) {
              overScrollPerc = Math.abs(_this.scrollComponent.scrollY) / _this.scrollComponent.height;
              _this.thumb.height = (_this.height * (_this.scrollComponent.height / _this.scrollContent.height)) * (1 - overScrollPerc);
              _this.thumb.y = Align.top;
            }
            if (_this.scrollComponent.scrollY >= _this.scrollContent.height - _this.scrollComponent.height) {
              overScrollPerc = (Math.abs(_this.scrollComponent.scrollY) - overflowHeight) / _this.scrollComponent.height;
              _this.thumb.height = (_this.height * (_this.scrollComponent.height / _this.scrollContent.height)) * (1 - overScrollPerc);
              return _this.thumb.y = Align.bottom;
            }
          }
        };
      })(this));
    }
  };

  return ScrollBar;

})(Layer);

ScrollComponentWithBar = (function(superClass) {
  extend(ScrollComponentWithBar, superClass);

  function ScrollComponentWithBar(options) {
    if (options == null) {
      options = {};
    }
    ScrollComponentWithBar.__super__.constructor.call(this, options);
    this.scrollBar = new ScrollBar({
      parent: this,
      name: "scrollbar",
      visible: false
    });
    this._content.on("change:size", this.scrollBar.updateScrollBar);
  }

  return ScrollComponentWithBar;

})(ScrollComponent);

module.exports = ScrollComponentWithBar;


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uL21vZHVsZXMvc2Nyb2xsY29tcG9uZW50d2l0aGJhci5jb2ZmZWUiLCJub2RlX21vZHVsZXMvYnJvd3Nlci1wYWNrL19wcmVsdWRlLmpzIl0sInNvdXJjZXNDb250ZW50IjpbImNsYXNzIFNjcm9sbEJhciBleHRlbmRzIExheWVyXG4gIGNvbnN0cnVjdG9yOiAob3B0aW9ucz17fSkgLT5cbiAgICBvcHRpb25zLndpZHRoIHx8PSAyNFxuICAgIG9wdGlvbnMuaGVpZ2h0IHx8PSBTY3JlZW4uaGVpZ2h0IC0gMTJcbiAgICBvcHRpb25zLnggfHw9IEFsaWduLnJpZ2h0XG4gICAgb3B0aW9ucy55IHx8PSBBbGlnbi5jZW50ZXJcbiAgICBvcHRpb25zLmJhY2tncm91bmRDb2xvciB8fD0gXCJcIlxuICAgIHN1cGVyIG9wdGlvbnNcblxuICAgIEBzY3JvbGxDb21wb25lbnQgPSBAcGFyZW50XG4gICAgQHNjcm9sbENvbnRlbnQgPSBAcGFyZW50LmNoaWxkcmVuV2l0aE5hbWUoXCJjb250ZW50XCIpWzBdXG5cbiAgICBAdGh1bWIgPSBuZXcgTGF5ZXJcbiAgICAgIHBhcmVudDogQFxuICAgICAgbmFtZTogXCJ0aHVtYlwiXG4gICAgICB4OiBBbGlnbi5jZW50ZXJcbiAgICAgIHdpZHRoOiBAd2lkdGggLSAxMlxuICAgICAgaGVpZ2h0OiBAaGVpZ2h0ICogKEBzY3JvbGxDb21wb25lbnQuaGVpZ2h0IC8gQHNjcm9sbENvbnRlbnQuaGVpZ2h0KVxuICAgICAgYm9yZGVyUmFkaXVzOiAoQHdpZHRoICogMC42KSAvIDJcbiAgICAgIGJhY2tncm91bmRDb2xvcjogXCJyZ2JhKDAsMCwwLDAuNSlcIlxuICAgICAgc2hhZG93Q29sb3I6IFwicmdiYSgyNTUsMjU1LDI1NSwwLjUpXCJcbiAgICAgIHNoYWRvd0JsdXI6IDJcblxuICAgIEB0aHVtYi5kcmFnZ2FibGUuZW5hYmxlZCA9IHRydWVcbiAgICBAdGh1bWIuZHJhZ2dhYmxlLmhvcml6b250YWwgPSBmYWxzZVxuICAgIEB0aHVtYi5kcmFnZ2FibGUuY29uc3RyYWludHMgPSBAXG4gICAgQHRodW1iLmRyYWdnYWJsZS5vdmVyZHJhZyA9IGZhbHNlXG4gICAgQHRodW1iLmRyYWdnYWJsZS5tb21lbnR1bSA9IGZhbHNlXG4gICAgQHRodW1iLmRyYWdnYWJsZS5ib3VuY2UgPSBmYWxzZVxuXG5cbiAgdXBkYXRlU2Nyb2xsQmFyOiA9PlxuICAgIGlmIEBzY3JvbGxDb250ZW50LmhlaWdodCA8PSBAc2Nyb2xsQ29tcG9uZW50LmhlaWdodCB0aGVuIEB2aXNpYmxlID0gZmFsc2UgZWxzZVxuXG4gICAgICBAdGh1bWIuaGVpZ2h0ID0gQGhlaWdodCAqIChAc2Nyb2xsQ29tcG9uZW50LmhlaWdodCAvIEBzY3JvbGxDb250ZW50LmhlaWdodClcbiAgICAgIEB2aXNpYmxlID0gdHJ1ZVxuXG4gICAgICB0cmFja1BpZWNlID0gQGhlaWdodCAtIEB0aHVtYi5oZWlnaHRcbiAgICAgIG92ZXJmbG93SGVpZ2h0ID0gQHNjcm9sbENvbnRlbnQuaGVpZ2h0IC0gQHNjcm9sbENvbXBvbmVudC5oZWlnaHRcblxuICAgICAgQHRodW1iLm9uIFwiY2hhbmdlOnlcIiwgPT5cbiAgICAgICAgaWYgQHRodW1iLmRyYWdnYWJsZS5pc0RyYWdnaW5nXG4gICAgICAgICAgeVBvcyA9IFV0aWxzLm1vZHVsYXRlKEB0aHVtYi55LCBbMCwgdHJhY2tQaWVjZV0sIFswLCBvdmVyZmxvd0hlaWdodF0sIGZhbHNlKVxuICAgICAgICAgIEBzY3JvbGxDb21wb25lbnQuc2Nyb2xsWSA9IHlQb3NcblxuXG4gICAgICBAc2Nyb2xsQ29udGVudC5vbiBcImNoYW5nZTpmcmFtZVwiLCA9PlxuICAgICAgICBpZiAhQHRodW1iLmRyYWdnYWJsZS5pc0RyYWdnaW5nXG4gICAgICAgICAgeVBvcyA9IFV0aWxzLm1vZHVsYXRlKEBzY3JvbGxDb21wb25lbnQuc2Nyb2xsWSwgWzAsIG92ZXJmbG93SGVpZ2h0XSwgWzAsIHRyYWNrUGllY2VdLCBmYWxzZSlcbiAgICAgICAgICBAdGh1bWIueSA9IHlQb3NcblxuICAgICAgICAgIGlmIEBzY3JvbGxDb21wb25lbnQuc2Nyb2xsWSA8IDBcbiAgICAgICAgICAgIG92ZXJTY3JvbGxQZXJjID0gTWF0aC5hYnMoQHNjcm9sbENvbXBvbmVudC5zY3JvbGxZKSAvIEBzY3JvbGxDb21wb25lbnQuaGVpZ2h0XG4gICAgICAgICAgICBAdGh1bWIuaGVpZ2h0ID0gKEBoZWlnaHQgKiAoQHNjcm9sbENvbXBvbmVudC5oZWlnaHQgLyBAc2Nyb2xsQ29udGVudC5oZWlnaHQpKSAqICgxIC0gb3ZlclNjcm9sbFBlcmMpXG4gICAgICAgICAgICBAdGh1bWIueSA9IEFsaWduLnRvcFxuXG4gICAgICAgICAgaWYgQHNjcm9sbENvbXBvbmVudC5zY3JvbGxZID49IEBzY3JvbGxDb250ZW50LmhlaWdodCAtIEBzY3JvbGxDb21wb25lbnQuaGVpZ2h0XG4gICAgICAgICAgICBvdmVyU2Nyb2xsUGVyYyA9IChNYXRoLmFicyhAc2Nyb2xsQ29tcG9uZW50LnNjcm9sbFkpIC0gb3ZlcmZsb3dIZWlnaHQpIC8gQHNjcm9sbENvbXBvbmVudC5oZWlnaHRcbiAgICAgICAgICAgIEB0aHVtYi5oZWlnaHQgPSAoQGhlaWdodCAqIChAc2Nyb2xsQ29tcG9uZW50LmhlaWdodCAvIEBzY3JvbGxDb250ZW50LmhlaWdodCkpICogKDEgLSBvdmVyU2Nyb2xsUGVyYylcbiAgICAgICAgICAgIEB0aHVtYi55ID0gQWxpZ24uYm90dG9tXG5cblxuXG5jbGFzcyBTY3JvbGxDb21wb25lbnRXaXRoQmFyIGV4dGVuZHMgU2Nyb2xsQ29tcG9uZW50XG4gIGNvbnN0cnVjdG9yOiAob3B0aW9ucz17fSkgLT5cbiAgICBzdXBlciBvcHRpb25zXG5cbiAgICBAc2Nyb2xsQmFyID0gbmV3IFNjcm9sbEJhclxuICAgICAgcGFyZW50OiBAXG4gICAgICBuYW1lOiBcInNjcm9sbGJhclwiXG4gICAgICB2aXNpYmxlOiBmYWxzZVxuXG4gICAgQF9jb250ZW50Lm9uKFwiY2hhbmdlOnNpemVcIiwgQHNjcm9sbEJhci51cGRhdGVTY3JvbGxCYXIpXG5cblxuXG5tb2R1bGUuZXhwb3J0cyA9IFNjcm9sbENvbXBvbmVudFdpdGhCYXJcbiIsIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dmFyIGY9bmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKTt0aHJvdyBmLmNvZGU9XCJNT0RVTEVfTk9UX0ZPVU5EXCIsZn12YXIgbD1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwobC5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxsLGwuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQ0FBO0FEQUEsSUFBQSxpQ0FBQTtFQUFBOzs7O0FBQU07OztFQUNTLG1CQUFDLE9BQUQ7O01BQUMsVUFBUTs7O0lBQ3BCLE9BQU8sQ0FBQyxVQUFSLE9BQU8sQ0FBQyxRQUFVO0lBQ2xCLE9BQU8sQ0FBQyxXQUFSLE9BQU8sQ0FBQyxTQUFXLE1BQU0sQ0FBQyxNQUFQLEdBQWdCO0lBQ25DLE9BQU8sQ0FBQyxNQUFSLE9BQU8sQ0FBQyxJQUFNLEtBQUssQ0FBQztJQUNwQixPQUFPLENBQUMsTUFBUixPQUFPLENBQUMsSUFBTSxLQUFLLENBQUM7SUFDcEIsT0FBTyxDQUFDLG9CQUFSLE9BQU8sQ0FBQyxrQkFBb0I7SUFDNUIsMkNBQU0sT0FBTjtJQUVBLElBQUMs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
