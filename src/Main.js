//=============================================================================
//  ► Main
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Initializes and Manages the Main Loop of this CanGam instance.
//=============================================================================
{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const self   = document.currentScript.self;
  const events = self.cangam.events;
  //---------------------------------------------------------------------------
  // private fields declaration
  //---------------------------------------------------------------------------
  let baseFrameRate;         // Main loop refresh rate
  let onUpdate;              // Update event called every frame
  let onDraw;                // Draw event called every frame
  //---------------------------------------------------------------------------
  //  * Initializes the private fields
  //---------------------------------------------------------------------------
  const initialize = () => {
    baseFrameRate = 1/60;
    onUpdate      = new events.Event;
    onDraw        = new events.LayeredEvent;
    window.setInterval(mainLoop, baseFrameRate);
  }
  //---------------------------------------------------------------------------
  //  * Executes the main events at every frame
  //---------------------------------------------------------------------------
  const mainLoop = () => {
    onUpdate.invoke();
    onDraw  .invoke();
  }
  //---------------------------------------------------------------------------
  //  * Automatically starts the script, such as invoking the initialize method
  //---------------------------------------------------------------------------
  { initialize() }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================