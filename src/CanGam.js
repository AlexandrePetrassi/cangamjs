//=============================================================================
//  ► CanGam
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  This script acts as a loader, Initializing a CanGam instance and thereafter
//  loading all its dependencies while forwarding info into them.
//=============================================================================
//  SCRIPT TAG'S ADDITIONAL ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  This script will also forward every attribute declared alongside the
//  original <script> tag which called this CanGam instance.
//  Each CanGam dependency may require some extra attributes to function
//  properly. Please, refer to their documentation to find what each module
//  requires.
//  Forwarded attributes can be referenced by cangam.attributes['attr'], where
//  'attr' is the attribute name in lowercase.
//
//  The following attributes are mandatory:
//    target_id : The ID of the div where the CanGam will be inserted.
//    config    : The configuration script's path. (without extension)
//		
//  Example
//    <script src='CanGam.js' target_id='CanGam' config='Config'></script>
//
//=============================================================================
{
  // List of script paths which are going to be loaded by this CanGam instance
  const modules = [
    'Events',
    'Canvas',
    'Main',
  ]
  //---------------------------------------------------------------------------
  // private fields declaration
  //---------------------------------------------------------------------------
  let attributes;            // Hash of attributes passed in the script tag
  let cangam;                // The cangam instance object holding every module
  //---------------------------------------------------------------------------
  //  * Initializes the private fields
  //---------------------------------------------------------------------------
  const initialize = () => {
    attributes = extractAttributes();
    cangam     = {attributes : attributes};
  }
  //---------------------------------------------------------------------------
  //  * Loads the configuration script and every other script required for the
  //  CanGam to work, including extra modules defined in the configuration file
  //---------------------------------------------------------------------------
  document.addEventListener('DOMContentLoaded', () =>
    loadConfigFile().addEventListener('load', loadModules));
  //---------------------------------------------------------------------------
  //  * Loads the configuration file while defining it to the Config namespace
  //  instead of attributing it to a namespace named after its filepath.
  //
  //    returns : The configuration script node
  //---------------------------------------------------------------------------
  const loadConfigFile = () =>
    runScript(createScriptElement(attributes.config, 'Config'));
  //---------------------------------------------------------------------------
  //  * Loads every module necessary for the cangam to work, including the
  //  extra modules defined in the Config file.
  //
  //    returns : List of loaded script nodes
  //---------------------------------------------------------------------------
  const loadModules = () =>
    modules.concat(cangam.Config.extraModules)
      .map(source => createScriptElement(source))
      .map(script => runScript(script));
  //---------------------------------------------------------------------------
  //  * Creates a non appended script element and initializes its attributes,
  //  then returns it.
  //
  //	source    : The script's source path.
  //    namespace : custom namespace name. Default value is the source name.
  //
  //	returns : The script element node.
  //---------------------------------------------------------------------------
  const createScriptElement = (source, namespace = source) => {
    let script    = document.createElement('script');
    script.src    = source + '.js';
    script.async  = false;
    script.cangam = cangam;
    script.self   = (cangam[namespace] = {cangam : cangam});
    return script;
  }
  //---------------------------------------------------------------------------
  //  * Runs a script element by appending and instantly de-appending it to the
  //  page's body.
  //    script : The script element node
  //
  //    returns : The script element node
  //---------------------------------------------------------------------------
  const runScript = (script, node = document.head) =>
    node.appendChild(script) && node.removeChild(script)
  //---------------------------------------------------------------------------
  //  * Extracts the attributes nodeList from the script tag and converts it to
  //  a plain object notation which can be passed as additional arguments to
  //  the other modules of this script
  //
  //    returns : object mapping attribute name => attribute value
  //---------------------------------------------------------------------------
  const extractAttributes = () =>
   [...document.currentScript.attributes]
      .reduce((list, pair) => (list[pair.nodeName] = pair.nodeValue) && list)
  //---------------------------------------------------------------------------
  //  * Performs cleanup operations, such as deleting the original script node.
  //---------------------------------------------------------------------------
  const cleanup = () =>
    document.currentScript.parentNode.removeChild(document.currentScript);
  //---------------------------------------------------------------------------
  //  * Automatically starts the script, such as invoking the initialize method
  //---------------------------------------------------------------------------
  !function autoStart() {
    initialize();
    cleanup();
  }()
}
//=============================================================================
// END OF SCRIPT
//=============================================================================