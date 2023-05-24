#!/bin/bash -eu
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

git apply $SRC/emscripten-patch.diff

# Install dependencies.
npm install
npm install uglify-js -g

# Combine needed js and the fuzzers
uglifyjs $SRC/base64Decode-fuzzer-base.js \
         $SRC/emscripten/src/base64Decode.js \
         -o $SRC/base64Decode-fuzzer.js -c -m

uglifyjs $SRC/base64Utils-fuzzer-base.js \
         $SRC/emscripten/src/URIUtils.js \
         $SRC/emscripten/src/base64Utils.js \
         -o $SRC/base64Utils-fuzzer.js -c -m

# Build Fuzzers.
compile_javascript_fuzzer emscripten ./src/base64Decode-fuzzer.js
compile_javascript_fuzzer emscripten ./src/base64Utils-fuzzer.js
cp $SRC/*-fuzzer.js $OUT/emscripten/src/
