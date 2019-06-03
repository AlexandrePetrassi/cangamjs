//=============================================================================
//  ► DESCRIPTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Main Loop of this CanGam instance.
//=============================================================================
!function Main(
  self   = document.currentScript.self,
  Events = self.cangam.Events
){
  let baseFrameRate, onUpdate, onDraw;
  function initialize() {
    baseFrameRate = 1/60;
    onUpdate      = new Events.Event;
    onDraw        = new Events.Event;
    window.setInterval(mainLoop, baseFrameRate);
  }
  function mainLoop() {
    onUpdate.invoke();
    onDraw  .invoke();
  }
  !function autoStart(){
    initialize();
  }()
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================