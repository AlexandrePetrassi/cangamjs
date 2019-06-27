//=============================================================================
//  ► Events
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Namespace for managing events.
//=============================================================================
!function(
  self = document.currentScript.self
) {
  //===========================================================================
  //  ** Event
  //---------------------------------------------------------------------------
  //  Prototype class which manages simple event objects
  //===========================================================================
  self.Event = class Event {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    #callbacks;              // List of callback functions listening to event
    //-------------------------------------------------------------------------
    //  * Object Initialization
    //-------------------------------------------------------------------------
    constructor() {
      this.#callbacks = [];
    }
    //-------------------------------------------------------------------------
    //  * Adds a callback to the invocation list of this event.
    //
    //    callback : The callback function which will be added to the list.
    //-------------------------------------------------------------------------
    addEventListener(callback) {
      this.#callbacks.push(callback);
    }
    //-------------------------------------------------------------------------
    //  * Removes a callback from the invocation list of this event.
    //
    //    callback : The callback function which will be removed from the list.
    //-------------------------------------------------------------------------
    removeEventListener(callback) {
      this.#callbacks.pop(callback);
    }
    //-------------------------------------------------------------------------
    //  * Alias to addEventListener
    //
    //    callback : The callback function which will be added to the list.
    //-------------------------------------------------------------------------
    add(callback) {
      this.addEventListener(callback);
    }
    //-------------------------------------------------------------------------
    //  * Alias to removeEventListener
    //
    //    callback : The callback function which will be removed from the list.
    //-------------------------------------------------------------------------
    remove(callback) {
      this.removeEventListener(callback);
    }
    //-------------------------------------------------------------------------
    //  * Invokes every callback function listening to this event.
    //
    //    eventData : Optional event data to be passed as argument.
    //-------------------------------------------------------------------------
    invoke(eventData = {}) {
      this.#callbacks.forEach(callback => callback(eventData));
    }
  }
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================