// Adds compile-time JS functions to augment the SimplifySvgPath interface.
(function(SimplifySvgPath) {

// This intentionally dangles because we want the code in the same scope.
// It will be closed in the Module initialization.

SimplifySvgPath.onRuntimeInitialized = function() {
  // Add the simplify method to Path prototype
  SimplifySvgPath.Path.prototype.simplify = function() {
    const result = this._makeSimplified();
    if (result) {
      return result;
    }
    return null;
  };
};

}(Module)); // When this file is loaded in, the high level object is "Module";
