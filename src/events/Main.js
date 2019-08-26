{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const cangam   = document.currentScript.self.cangam;
  const events   = cangam.events;
  //===========================================================================
  //  ► Main
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Initializes and Manages the Main Loop of this CanGam instance.
  //===========================================================================
  document.currentScript.self = new class {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    baseFrameRate;           // Main loop refresh rate
    onUpdate;                // Update event called every frame
    onDraw;                  // Draw event called every frame
    //-------------------------------------------------------------------------
    //  * Initializes the private fields
    //-------------------------------------------------------------------------
    constructor () {
      this.baseFrameRate = 1/60;
      this.onUpdate      = new events.Event;
      this.onDraw        = new events.LayeredEvent;
      window.setInterval(() => this.loop(), this.baseFrameRate);
    }
    //-------------------------------------------------------------------------
    //  * Executes the main events at every frame
    //-------------------------------------------------------------------------
    loop () {
      this.onUpdate.invoke();
      this.onDraw  .invoke();
    }
  }


}
//=============================================================================
// END OF SCRIPT
//=============================================================================