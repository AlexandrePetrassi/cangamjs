{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const cangam = document.currentScript.self.cangam;
  const Config = cangam.Config;
  //===========================================================================
  //  ► Canvas
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Initializes and Manages the Canvas inside the CanGam instance.
  //===========================================================================
  document.currentScript.self = class {
    //-------------------------------------------------------------------------
    //  private fields declaration
    //-------------------------------------------------------------------------
    _targetID;               // id attribute for the div to receive the canvas
    _parentNode;             // div which will receive the canvas
    _canvas;                 // canvas element that will be inserted in the div
    _context;
    //-------------------------------------------------------------------------
    //  * Initializes the private fields
    //-------------------------------------------------------------------------
    constructor() {
      this._targetID   = cangam.attributes.target_id;
      this._parentNode = document.getElementById(this._targetID);
      this._canvas     = this.createCanvas(Config.canvas.style);
      this._parentNode.appendChild(this._canvas);
      this._context    = this._canvas.getContext('2d');
    }
    //-------------------------------------------------------------------------
    //  * Creates a stylized Canvas element using the Config file data.
    //-------------------------------------------------------------------------
    createCanvas(style = {}) {
      let canvasElement = document.createElement('canvas');
      let styles        = Object.entries(style);
      let styleMapping  = (key, value) => canvasElement.style[key] = value;
      styles.map(pair => styleMapping(...pair));
      return canvasElement;
    }

    get context () {
      return this._context;
    }

    clear () {
      this.context.clearRect(0, 0, this._canvas.width, this._canvas.height)
    }
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================