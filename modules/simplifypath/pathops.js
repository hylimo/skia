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

  // Store the original simplifySvgPath function
  const _originalSimplifySvgPath = SimplifySvgPath.simplifySvgPath;

  // Override simplifySvgPath to support fillType parameter
  SimplifySvgPath.simplifySvgPath = function(svgPath, fillType) {
    if (fillType !== undefined) {
      return SimplifySvgPath._simplifySvgPathWithFillType(svgPath, fillType);
    }
    return _originalSimplifySvgPath(svgPath);
  };
};

}(Module)); // When this file is loaded in, the high level object is "Module";

