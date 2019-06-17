//=============================================================================
//  ► DESCRIPTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Canvas inside the CanGam instance.
//=============================================================================
!function Canvas(
  self   = document.currentScript.self,
  cangam = self.cangam,
  Config = cangam.Config
){
  //---------------------------------------------------------------------------
  // private fields declaration
  //---------------------------------------------------------------------------
  let targetID;              // id attribute for the div to receive the canvas
  let parentNode;            // div which will receive the canvas
  let canvas;                // canvas element that will be inserted in the div
  //---------------------------------------------------------------------------
  // * initialize
  //---------------------------------------------------------------------------
  //  Initializes the private fields
  //---------------------------------------------------------------------------
  function initialize() {
    targetID   = cangam.attributes.target_id;
    parentNode = document.getElementById(targetID);
    canvas     = createCanvas(Config.canvas.style);
    parentNode.appendChild(canvas);
  }
  //---------------------------------------------------------------------------
  // * createCanvas
  //---------------------------------------------------------------------------
  //  Creates a stylized Canvas element using the Config file data.
  //---------------------------------------------------------------------------
  function createCanvas(style = {}) {
    let canvasElement = document.createElement('canvas');
    let styles        = Object.entries(style);
    let styleMapping  = (key, value) => canvasElement.style[key] = value;
    styles.map(pair => styleMapping(...pair));
    return canvasElement;
  }
  //---------------------------------------------------------------------------
  // * autoStart
  //---------------------------------------------------------------------------
  //  Automatically starts this script, such as invoking the initialize method.
  //---------------------------------------------------------------------------
  !function autoStart() {
    initialize();
  }()
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================