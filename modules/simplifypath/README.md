# simplifypath Module

A minimal Skia WASM module that provides only path simplification functionality.

## Overview

This module is a stripped-down version of CanvasKit, containing only the essential functions for path manipulation:

- `Path.MakeFromSVGString()` - Parse SVG path strings
- `path.toSVGString()` - Convert paths to SVG strings  
- `path.simplify()` - Simplify paths using PathOps

## Building

```bash
./compile.sh
```

Output files will be in `../../out/simplifypath_wasm/`:
- `simplifypath.js` - JavaScript loader
- `simplifypath.wasm` - WebAssembly binary

## Files

- `BUILD.gn` - GN build configuration
- `compile.sh` - Build script
- `path_simplify_bindings.cpp` - C++ bindings
- `pathops.js` - JavaScript wrapper
- `WasmCommon.h` - Common type definitions

## Build Configuration

The build disables all non-essential Skia features:
- No GPU support (Ganesh/Graphite)
- No image codecs (JPEG, PNG, WebP)
- No text rendering (fonts, paragraphs, shaping)
- No effects or filters
- No serialization (except PathOps)

Only core path functionality and PathOps are included.

## Integration

The module is registered in the main Skia build at `//:modules` group for WASM targets.

See `../../BUILD.gn` line ~1965.
