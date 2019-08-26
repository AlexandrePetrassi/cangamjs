{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const cangam   = document.currentScript.self.cangam;
  const graphics = cangam.graphics;
  const Canvas   = graphics.Canvas;
  //===========================================================================
  //  ► Square
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Class which manages simple hollow squares to be drawn in the canvas
  //===========================================================================
  document.currentScript.self = class extends graphics.Drawable {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    left;                    // Square's starting left position in pixels
    top;                     // Square's starting top position in pixels
    right;                   // Square's ending right position in pixels
    bottom;                  // Square's ending bottom position in pixels
    //-------------------------------------------------------------------------
    //  * Initializes the private fields
    //-------------------------------------------------------------------------
    constructor(left, top, right, bottom, layer = 0) {
      super(layer);
      this.left   = left;
      this.top    = top;
      this.right  = right;
      this.bottom = bottom;
    }
    //-------------------------------------------------------------------------
    //  * Gets the Width
    //-------------------------------------------------------------------------
    get width () { return this.right - this.left }
    //-------------------------------------------------------------------------
    //  * Sets the Width
    //-------------------------------------------------------------------------
    set width (width) { this.right = this.left + width}
    //-------------------------------------------------------------------------
    //  * Gets the Height
    //-------------------------------------------------------------------------
    get height () { return this.bottom - this.top }
    //-------------------------------------------------------------------------
    //  * Sets the Height
    //-------------------------------------------------------------------------
    set height (height) { this.top = this.bottom - height }

    draw () {
      Canvas.context.fillRect(this.left, this.top, this.width, this.height);
    }
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================