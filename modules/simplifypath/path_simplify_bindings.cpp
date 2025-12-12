/*
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "include/core/SkPath.h"
#include "include/core/SkPathTypes.h"
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

JSString SimplifySvgPathString(std::string str, SkPathFillType fillType) {
    if (auto path = SkParsePath::FromSVGString(str.c_str())) {
        path->setFillType(fillType);
        if (auto simplified = Simplify(*path)) {
            return emscripten::val(SkParsePath::ToSVGString(simplified.value()).c_str());
        }
    }
    return emscripten::val::null();
}

JSString SimplifySvgPathStringDefault(std::string str) {
    return SimplifySvgPathString(str, SkPathFillType::kWinding);
}

// =================================================================================
// Bindings
// =================================================================================

EMSCRIPTEN_BINDINGS(SimplifyPath) {
    function("simplifySvgPath", &SimplifySvgPathStringDefault);
    function("_simplifySvgPathWithFillType", &SimplifySvgPathString);
    
    class_<SkPath>("Path")
            .constructor<>()
            .class_function("MakeFromSVGString", &MakePathFromSVGString)
            .function("toSVGString", &ToSVGString)
            .function("_makeSimplified", &MakeSimplified)
            .function("setFillType", &SkPath::setFillType)
            .function("getFillType", &SkPath::getFillType)
            ;

    enum_<SkPathFillType>("FillType")
            .value("Winding", SkPathFillType::kWinding)
            .value("EvenOdd", SkPathFillType::kEvenOdd);
}
