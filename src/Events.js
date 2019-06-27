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
  self.Event = class {
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
  //===========================================================================
  //  ** LayeredEvent
  //---------------------------------------------------------------------------
  //  Prototype class which manages multiple events as an index list of events
  //===========================================================================
  self.LayeredEvent = class {
    //-------------------------------------------------------------------------
    // private fields declaration
    //-------------------------------------------------------------------------
    #layers;                 // List of events. Each Event is called a layer.
    //-------------------------------------------------------------------------
    //  * Object Initialization
    //-------------------------------------------------------------------------
    constructor() {
      this.#layers = [];
    }
    //-------------------------------------------------------------------------
    //  * Returns the event layer of index 'layer'
    //-------------------------------------------------------------------------
    #layer = (layer) =>
      this.#layers[layer] || (this.#layers[layer] = new self.Event());
    //-------------------------------------------------------------------------
    //  * Adds a callback to a layer's end.
    //
    //    callback : The callback function which will be added to the layer.
    //    layer    : The layer's index.
    //-------------------------------------------------------------------------
    addEventListener(callback, layer = 0) {
      this.#layer(layer).addEventListener(callback);
    }
    //-------------------------------------------------------------------------
    //  * Removes a callback from a layer
    //
    //    callback : The callback function which will be removed from the layer
    //    layer    : The layer's index.
    //-------------------------------------------------------------------------
    removeEventListener(callback, layer = 0) {
      this.#layer(layer).removeEventListener(callback);
    }
    //-------------------------------------------------------------------------
    //  * Alias to addEventListener
    //
    //    callback : The callback function which will be added to the layer.
    //    layer    : The layer's index.
    //-------------------------------------------------------------------------
    add(callback, layer = 0) {
      this.addEventListener(callback, layer);
    }
    //-------------------------------------------------------------------------
    //  * Alias to removeEventListener
    //
    //    callback : The callback function which will be removed from the layer
    //    layer    : The layer's index.
    //-------------------------------------------------------------------------
    remove(callback, layer = 0) {
      this.removeEventListener(callback, layer);
    }
    //-------------------------------------------------------------------------
    //  * Invokes every callback function listening to this layered event in
    //  each layer in order.
    //
    //    eventData : Optional event data to be passed as argument.
    //-------------------------------------------------------------------------
    invoke(eventData = {}) {
      this.#layers.forEach(layer => !layer || layer.invoke(eventData))
    }
  }
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================