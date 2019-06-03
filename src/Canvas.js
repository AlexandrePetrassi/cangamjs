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
  let targetID, parentNode, canvas;
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
  //  Initializes the private fields
  //---------------------------------------------------------------------------
  function createCanvas(style = {}) {
    let canvas        = document.createElement('canvas');
    let styles        = Object.entries(style);
    let styleMapping  = (key, value) => canvas.style[key] = value;
    styles.map(pair => styleMapping(...pair));
    return canvas;
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