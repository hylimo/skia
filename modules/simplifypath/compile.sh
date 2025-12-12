#!/bin/bash
# simplifypath build script

set -ex

BASE_DIR=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
pushd $BASE_DIR/../..

./bin/fetch-gn
./bin/fetch-ninja

BUILD_DIR="out/simplifypath_wasm"
mkdir -p $BUILD_DIR
rm -f $BUILD_DIR/*.a

NINJA="third_party/ninja/ninja"

echo "Building SimplifyPath"

./bin/gn gen ${BUILD_DIR} \
  --args="is_debug=false \
  is_official_build=true \
  is_component_build=false \
  is_trivial_abi=true \
  werror=false \
  target_cpu=\"wasm\" \
  \
  skia_enable_optimize_size=true \
  \
  skia_use_angle=false \
  skia_use_dng_sdk=false \
  skia_use_dawn=false \
  skia_use_webgl=false \
  skia_use_webgpu=false \
  skia_use_expat=false \
  skia_use_fontconfig=false \
  skia_use_freetype=false \
  skia_use_libjpeg_turbo_decode=false \
  skia_use_libjpeg_turbo_encode=false \
  skia_use_no_jpeg_encode=true \
  skia_use_libpng_decode=false \
  skia_use_libpng_encode=false \
  skia_use_no_png_encode=true \
  skia_use_libwebp_decode=false \
  skia_use_libwebp_encode=false \
  skia_use_no_webp_encode=true \
  skia_use_lua=false \
  skia_use_piex=false \
  skia_use_vulkan=false \
  skia_use_wuffs=false \
  skia_use_zlib=true \
  skia_use_system_zlib=false \
  \
  skia_enable_ganesh=false \
  skia_enable_graphite=false \
  skia_enable_skshaper=false \
  skia_enable_skottie=false \
  skia_enable_svg=false \
  skia_enable_pdf=false \
  skia_enable_skparagraph=false \
  skia_use_icu=false \
  skia_use_system_icu=false \
  skia_use_harfbuzz=false \
  skia_use_system_harfbuzz=false \
  skia_use_sfntly=false \
  skia_use_system_libpng=false \
  skia_use_system_libjpeg_turbo=false \
  skia_use_system_libwebp=false \
  \
  skia_enable_tools=false \
  skia_enable_fontmgr_empty=true \
  skia_enable_gpu_debug_layers=false"

echo "Configured build"

# Build the library
$NINJA -C ${BUILD_DIR} simplifypath.js -k 10

echo ""
echo "Build complete!"
echo "Output files:"
ls -lh ${BUILD_DIR}/simplifypath.{js,wasm}

popd
