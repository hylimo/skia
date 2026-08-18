#!/bin/bash
# simplifypath build script
#
# Builds one WASM module per target environment. The WASM binary is identical across
# variants, only the generated JS glue differs: emscripten bakes the environment
# detection and the matching module loading code into it, so a build that knows about
# Node.js pulls in `module`/`fs`/`path`/`url`, which browser bundlers cannot resolve.

set -ex

BASE_DIR=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
pushd $BASE_DIR/../..

./bin/fetch-gn
./bin/fetch-ninja

NINJA="third_party/ninja/ninja"

# The environments to build for, as "<variant name>:<emscripten ENVIRONMENT value>".
VARIANTS=(
  "web:web,webview,worker"
  "node:node"
)

build_variant() {
  local name="$1"
  local environment="$2"
  local build_dir="out/simplifypath_wasm/$name"

  echo "Building SimplifyPath for $name ($environment)"

  mkdir -p $build_dir
  rm -f $build_dir/*.a

  ./bin/gn gen ${build_dir} \
    --args="is_debug=false \
    is_official_build=true \
    is_component_build=false \
    is_trivial_abi=true \
    werror=false \
    target_cpu=\"wasm\" \
    \
    simplifypath_environment=\"$environment\" \
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

  echo "Configured $name build"

  $NINJA -C ${build_dir} simplifypath.js -k 10
}

for variant in "${VARIANTS[@]}"; do
  build_variant "${variant%%:*}" "${variant#*:}"
done

echo ""
echo "Build complete!"
echo "Output files:"
for variant in "${VARIANTS[@]}"; do
  ls -lh out/simplifypath_wasm/"${variant%%:*}"/simplifypath.{js,wasm}
done

popd
