{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const self   = document.currentScript.self;
  const events = self.cangam.events;
  //===========================================================================
  //  ► Main
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Initializes and Manages the Main Loop of this CanGam instance.
  //===========================================================================
  self.Main = new class {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    baseFrameRate;         // Main loop refresh rate
    onUpdate;              // Update event called every frame
    onDraw;                // Draw event called every frame
    //-------------------------------------------------------------------------
    //  * Initializes the private fields
    //-------------------------------------------------------------------------
    constructor() {
      this.baseFrameRate = 1/60;
      this.onUpdate      = new events.Event;
      this.onDraw        = new events.LayeredEvent;
      window.setInterval(() => this.mainLoop(), this.baseFrameRate);
    }
    //-------------------------------------------------------------------------
    //  * Executes the main events at every frame
    //-------------------------------------------------------------------------
    mainLoop() {
      this.onUpdate.invoke();
      this.onDraw  .invoke();
    }
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================