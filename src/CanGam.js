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
//    config    : The configuration script's path. (without .js extension)
//		
//  Example
//    <script src='CanGam.js' target_id='CanGam' config='Config'></script>
//
//=============================================================================
{
  // List of script paths which are going to be loaded by this CanGam instance
  const modules = [
    'events/Event',
    'events/LayeredEvent',
    'events/Main',
    'graphics/Drawable',
    'graphics/Canvas',
    'graphics/Square',
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
  const createScriptElement = (source, namespace = undefined) => {
    let script    = document.createElement('script');
    script.src    = source + '.js';
    script.async  = false;
    script.cangam = cangam;
    script.self   = createNamespaceStructure(namespace || source);
    return script;
  }
  //---------------------------------------------------------------------------
  //  * Creates a namespace structure by following the folder structure of a
  //  file's hierarchy.
  //
  //    path : The file path separated by "/". The last folder is ignored due
  //           to the fact that it must be a filename instead a folder.
  //
  //    returns : The namespace, which is the last node in the generated tree.
  //---------------------------------------------------------------------------
  const createNamespaceStructure = (path) =>
    path.split("/").reduce(createNamespaceNode, cangam);
  //---------------------------------------------------------------------------
  //  * Removes the last element from an array with size greater than one.
  //  If the array has only one element or is empty, then this method does
  //  nothing and simply returns the unaltered array.
  //
  //    array : The array which will have its last element removed.
  //
  //    returns : The array without its last element, or the array itself if
  //              it has only one or no elements.
  //---------------------------------------------------------------------------
  const removeLast = (array) =>
    array.length > 1 ? array.slice(0, -1) : array;
  //---------------------------------------------------------------------------
  //  * Creates a "namespace" node, that is, an object used to hold references
  //  to other objects. Every node contains a reference to the root namespace
  //  node, the cangam.
  //
  //    parentNode:  A base namespace node object which will hold a sub node
  //    childName  : A string representing the child node's name.
  //
  //    returns : The child node object of name 'childName' in the 'parentNode'
  //---------------------------------------------------------------------------
  const createNamespaceNode = (parentNode, childName) =>
    parentNode[childName] || (parentNode[childName] = {cangam : cangam});
  //---------------------------------------------------------------------------
  //  * Runs a script element by appending and instantly de-appending it to the
  //  page's body.
  //    script : The script element node
  //
  //    returns : The script element node
  //---------------------------------------------------------------------------
  const runScript = (script, node = document.head) =>
    node.appendChild(script) && node.removeChild(script);
  //---------------------------------------------------------------------------
  //  * Extracts the attributes nodeList from the script tag and converts it to
  //  a plain object notation which can be passed as additional arguments to
  //  the other modules of this script
  //
  //    returns : object mapping attribute name => attribute value
  //---------------------------------------------------------------------------
  const extractAttributes = () =>
   [...document.currentScript.attributes]
      .reduce((list, pair) => (list[pair.nodeName] = pair.nodeValue) && list);
  //---------------------------------------------------------------------------
  //  * Performs cleanup operations, such as deleting the original script node.
  //---------------------------------------------------------------------------
  const cleanup = () =>
    document.currentScript.parentNode.removeChild(document.currentScript);
  //---------------------------------------------------------------------------
  //  * Automatically starts the script, such as invoking the initialize method
  //---------------------------------------------------------------------------
  {
    initialize();
    cleanup();
  }
}
//=============================================================================
// END OF SCRIPT
//=============================================================================