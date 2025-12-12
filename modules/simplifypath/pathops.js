Module['onRuntimeInitialized'] = function() {
  // Add the simplify method to Path prototype
  if (Module.Path && Module.Path.prototype) {
    Module.Path.prototype.simplify = function() {
      const result = this._makeSimplified();
      if (result) {
        return result;
      }
      return null;
    };
  }

  // Store the original simplifySvgPath function
  const _originalSimplifySvgPath = Module.simplifySvgPath;

  // Override simplifySvgPath to support fillType parameter
  if (_originalSimplifySvgPath) {
    Module.simplifySvgPath = function(svgPath, fillType) {
      if (fillType !== undefined) {
        return Module._simplifySvgPathWithFillType(svgPath, fillType);
      }
      return _originalSimplifySvgPath(svgPath);
    };
  }
};
