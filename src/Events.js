//=============================================================================
//  ► DESCRIPTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Prototype class which manages event objects
//=============================================================================
!function CanGamEvent(
  self = document.currentScript.self
) {
  self.Event = class Event {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    #callbacks; #count;
    //-------------------------------------------------------------------------
    // * constructor
    //-------------------------------------------------------------------------
    //  Object Initialization
    //-------------------------------------------------------------------------
    constructor() {
      this.#callbacks = [];
      this.#count     = 0;
    }
    //-------------------------------------------------------------------------
    // * addEventListener
    //-------------------------------------------------------------------------
    //  Adds a callback to the invocation list of this event.
    //    callback : The callback function which will be added to the list.
    //-------------------------------------------------------------------------
    addEventListener(callback) {
      this.#callbacks.push(callback);
    }
    //-------------------------------------------------------------------------
    // * removeEventListener
    //-------------------------------------------------------------------------
    //  Removes a callback from the invocation list of this event.
    //    callback : The callback function which will be removed from the list.
    //-------------------------------------------------------------------------
    removeEventListener(callback) {
      this.#callbacks.pop(callback);
    }
    //-------------------------------------------------------------------------
    // * add
    //-------------------------------------------------------------------------
    //  Alias to addEventListener
    //    callback : The callback function which will be added to the list.
    //-------------------------------------------------------------------------
    add(callback) {
      this.addEventListener(callback);
    }
    //-------------------------------------------------------------------------
    // * remove
    //-------------------------------------------------------------------------
    //  Alias to removeEventListener
    //    callback : The callback function which will be removed from the list.
    //-------------------------------------------------------------------------
    remove(callback) {
      this.removeEventListener(callback);
    }
    //-------------------------------------------------------------------------
    // * invoke
    //-------------------------------------------------------------------------
    //  Invokes every callback function listening to this event.
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