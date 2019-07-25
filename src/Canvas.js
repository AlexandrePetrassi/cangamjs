//=============================================================================
//  ► Canvas
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Canvas inside the CanGam instance.
//=============================================================================
{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const self   = document.currentScript.self;
  const cangam = self.cangam;
  const Config = cangam.Config;
  //---------------------------------------------------------------------------
  //  private fields declaration
  //---------------------------------------------------------------------------
  let targetID;              // id attribute for the div to receive the canvas
  let parentNode;            // div which will receive the canvas
  let canvas;                // canvas element that will be inserted in the div
  //---------------------------------------------------------------------------
  //  * Initializes the private fields
  //---------------------------------------------------------------------------
  const initialize = () => {
    targetID   = cangam.attributes.target_id;
    parentNode = document.getElementById(targetID);
    canvas     = createCanvas(Config.canvas.style);
    parentNode.appendChild(canvas);
  }
  //---------------------------------------------------------------------------
  //  * Creates a stylized Canvas element using the Config file data.
  //---------------------------------------------------------------------------
  const createCanvas = (style = {}) => {
    let canvasElement = document.createElement('canvas');
    let styles        = Object.entries(style);
    let styleMapping  = (key, value) => canvasElement.style[key] = value;
    styles.map(pair => styleMapping(...pair));
    return canvasElement;
  }
  //---------------------------------------------------------------------------
  //  * Automatically starts the script, such as invoking the initialize method
  //---------------------------------------------------------------------------
  { initialize() }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================