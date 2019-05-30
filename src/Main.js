//=============================================================================
//  Script  : Main
//=============================================================================
//  ► DESCRIPTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Main Loop of this CanGam instance.
//=============================================================================
!function Main(
  self = document.currentScript.self,
  other = document.currentScript.cangam.Canvas
){
  let baseFrameRate, onUpdate, onDraw;
  function initialize() {
    baseFrameRate = 1/60;
    onUpdate      = [];
    onDraw        = [];
    document.setInterval(mainLoop, baseFrameRate);
  }
  function mainLoop() {
    onUpdate.map(callback => callback());
    onDraw  .map(callback => callback());
  }
  !function autoStart(){
    initialize();
  }()
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================