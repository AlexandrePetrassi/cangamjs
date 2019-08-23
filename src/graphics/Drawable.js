{
  //---------------------------------------------------------------------------
  // imports
  //---------------------------------------------------------------------------
  const self = document.currentScript.self;
  const main = self.cangam.Main.Main;
  //===========================================================================
  //  ► Drawable
  //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  //  Abstract class which manages every drawable object
  //===========================================================================
  self.Drawable = class {
    _isEnabled;
    _layer;

    constructor (layer = 0) {
      this.layer = layer;
    }

    draw () {
      throw new Exception("Abstract Method");
    }

    get layer () {
      return this._layer;
    }

    set layer (value) {
      if (value === this._layer) return;
      this.unregister()
      this._layer = value;
      this.register();
    }

    get isEnabled () {
      return this._isEnabled;
    }

    set isEnabled (value) {
      value ? this.register() : this.unregister();
    }

    register () {
      main.onDraw.add(this.draw, this.layer);
      this._isEnabled = true;
    }

    unregister () {
      main.onDraw.remove(this.draw, this.layer);
      this._isEnabled = false;
    }
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================