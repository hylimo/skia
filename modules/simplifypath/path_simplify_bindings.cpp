/*
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "include/core/SkPath.h"
#include "include/core/SkString.h"
#include "include/utils/SkParsePath.h"
#include "include/pathops/SkPathOps.h"

#include <emscripten.h>
#include <emscripten/bind.h>
#include "modules/simplifypath/WasmCommon.h"

using namespace emscripten;

// =================================================================================
// Path Operations
// =================================================================================

SkPathOrNull MakeSimplified(const SkPath& path) {
    if (auto result = Simplify(path)) {
        return emscripten::val(result.value());
    }
    return emscripten::val::null();
}

JSString ToSVGString(const SkPath& path) {
    return emscripten::val(SkParsePath::ToSVGString(path).c_str());
}

SkPathOrNull MakePathFromSVGString(std::string str) {
    if (auto path = SkParsePath::FromSVGString(str.c_str())) {
        return emscripten::val(*path);
    }
    return emscripten::val::null();
}

// Helper function to simplify an SVG path string and return the simplified string
JSString SimplifySvgPathString(std::string str) {
    if (auto path = SkParsePath::FromSVGString(str.c_str())) {
        if (auto simplified = Simplify(*path)) {
            return emscripten::val(SkParsePath::ToSVGString(simplified.value()).c_str());
        }
    }
    return emscripten::val::null();
}

// =================================================================================
// Bindings
// =================================================================================

EMSCRIPTEN_BINDINGS(SimplifyPath) {
    function("simplifySvgPath", &SimplifySvgPathString);
    
    class_<SkPath>("Path")
            .constructor<>()
            .class_function("MakeFromSVGString", &MakePathFromSVGString)
            .function("toSVGString", &ToSVGString)
            .function("_makeSimplified", &MakeSimplified)
            ;
}
