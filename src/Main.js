//=============================================================================
//  ► Main
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Main Loop of this CanGam instance.
//=============================================================================
!function Main(
  self   = document.currentScript.self,
  Events = self.cangam.Events
){
  //---------------------------------------------------------------------------
  // private fields declaration
  //---------------------------------------------------------------------------
  let baseFrameRate;         // Main loop refresh rate
  let onUpdate;              // Update event called every frame
  let onDraw;                // Draw event called every frame
  //---------------------------------------------------------------------------
  //  * Initializes the private fields
  //---------------------------------------------------------------------------
  function initialize() {
    baseFrameRate = 1/60;
    onUpdate      = new Events.Event;
    onDraw        = new Events.Event;
    window.setInterval(mainLoop, baseFrameRate);
  }
  //---------------------------------------------------------------------------
  //  * Executes the main events at every frame
  //---------------------------------------------------------------------------
  function mainLoop() {
    onUpdate.invoke();
    onDraw  .invoke();
  }
  //---------------------------------------------------------------------------
  //  * Automatically starts the script, such as invoking the initialize method
  //---------------------------------------------------------------------------
  !function autoStart(){
    initialize();
  }()
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================