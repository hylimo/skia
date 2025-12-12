/*
 * Copyright 2019 Google LLC
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef WasmCommon_DEFINED
#define WasmCommon_DEFINED

#include <emscripten.h>
#include <emscripten/bind.h>
#include "include/core/SkRefCnt.h"

using namespace emscripten;

// Self-documenting types
using JSString = emscripten::val;
using SkPathOrNull = emscripten::val;

#endif
