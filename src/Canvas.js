{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const self   = document.currentScript.self;
  const cangam = self.cangam;
  const Config = cangam.Config;
  //===========================================================================
  //  ► Canvas
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Initializes and Manages the Canvas inside the CanGam instance.
  //===========================================================================
  self.Canvas = new class {
    //-------------------------------------------------------------------------
    //  private fields declaration
    //-------------------------------------------------------------------------
    targetID;                // id attribute for the div to receive the canvas
    parentNode;              // div which will receive the canvas
    canvas;                  // canvas element that will be inserted in the div
    //-------------------------------------------------------------------------
    //  * Initializes the private fields
    //-------------------------------------------------------------------------
    constructor() {
      this.targetID   = cangam.attributes.target_id;
      this.parentNode = document.getElementById(this.targetID);
      this.canvas     = this.createCanvas(Config.canvas.style);
      this.parentNode.appendChild(this.canvas);
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
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================