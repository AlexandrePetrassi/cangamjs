//=============================================================================
//  Author  : CaRaCrAzY_Petrassi
//  Version : 0.01
//  Script  : CanGam
//=============================================================================
//  ► DESCRIPTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  This script acts as a loader, Initializing a CanGam instance and thereafter
//  loading all its dependencies while forwarding info into them.
//=============================================================================
//  ► IIFE PARAMETERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//    modules  : Script paths which will be loaded as CanGam Modules.
//=============================================================================
//  ► SCRIPT TAG'S ADDITIONAL ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  This script will also forward every attribute declared alongside the
//  original <script> tag which called this CanGam instance.
//  Each CanGam dependency may require some extra attributes to function
//  properly. Please, refer to their documentation to find what each module
//  requires.
//  The following attributes are mandatory:
//    target_id : The ID of the div where the CanGam will be inserted.
//    config    : The configuration script's path. (without extension)
//		
//  Example
//    <script src='CanGam.js' targetID='CanGam' config='Config'></script>
//=============================================================================
!function CanGam (
  // List of script paths which are going to be loaded by this CanGam instance
  modules = [
    'Canvas',
    'Main',
  ],
){
  //---------------------------------------------------------------------------
  // private fields declaration
  //---------------------------------------------------------------------------
  let attributes, sources, cangam;
  //---------------------------------------------------------------------------
  // * initialize
  //---------------------------------------------------------------------------
  //  Initializes the private fields
  //---------------------------------------------------------------------------
  function initialize() {
    attributes    = extractAttributes();
    cangam        = {attributes : attributes};
    sources       = [attributes.config].concat(modules);
  }
  //---------------------------------------------------------------------------
  // * loadScripts : callback(DOMContentLoaded)
  //---------------------------------------------------------------------------
  //  Loads the configuration script and every other script required for the
  //  CanGam to work.
  //---------------------------------------------------------------------------
  document.addEventListener('DOMContentLoaded', function loadScripts() {
    sources
      .map(source => createScriptElement(source))
      .map(script => runScript(script));
  })
  //---------------------------------------------------------------------------
  // * createScriptElement
  //---------------------------------------------------------------------------
  //  Creates a non appended script element and initializes its attributes,
  //  then returns it.
  //	source : The script's source path.
  //
  //	returns : The script element node.
  //---------------------------------------------------------------------------
  function createScriptElement(source) {
    let script    = document.createElement('script');
    script.src    = source + '.js';
    script.async  = false;
    script.cangam = cangam;
    script.self   = (cangam[source] = {cangam : cangam})
    return script;
  }
  //---------------------------------------------------------------------------
  // * runScript
  //---------------------------------------------------------------------------
  //  Runs a script element by appending and instantly de-appending it to the
  //  page's body.
  //    script : The script element node
  //---------------------------------------------------------------------------
  function runScript(script) {
    document.head.appendChild(script);
    document.head.removeChild(script);
  }
  //---------------------------------------------------------------------------
  // * extractAttributes
  //---------------------------------------------------------------------------
  //  Extracts the attributes nodeList from the script tag and converts it to
  //  a plain object notation which can be passed as additional arguments to
  //  the other modules of this script
  //
  //    returns : object mapping attribute name => attribute value
  //---------------------------------------------------------------------------
  function extractAttributes(node = document.currentScript) {
    let list = {};
    let attributes = Array.prototype.slice.call(node.attributes);
    let pair;
    while(pair = attributes.pop()) list[pair.nodeName] = pair.nodeValue;
    return list;
  }
  //---------------------------------------------------------------------------
  // * cleanup
  //---------------------------------------------------------------------------
  //  Performs cleanup operations, such as deleting the original script node.
  //---------------------------------------------------------------------------
  function cleanup() {
    document.currentScript.parentNode.removeChild(document.currentScript);
  }
  //---------------------------------------------------------------------------
  // * autoStart
  //---------------------------------------------------------------------------
  //  Automatically starts this script, such as invoking the initialize method.
  //---------------------------------------------------------------------------
  !function autoStart() {
    initialize();
    cleanup();
  }()
}()
//=============================================================================
// END OF SCRIPT
//=============================================================================