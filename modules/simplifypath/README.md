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

The module is built once per target environment, because emscripten bakes the environment
detection and the matching module loading code into the generated JS glue. Output files
will be in `../../out/simplifypath_wasm/<environment>/`, one directory per entry of
`VARIANTS` in `compile.sh`:

- `simplifypath.js` - JavaScript loader, specific to the environment
- `simplifypath.wasm` - WebAssembly binary, identical across environments

The environment is passed to the build through the `simplifypath_environment` GN argument.

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
