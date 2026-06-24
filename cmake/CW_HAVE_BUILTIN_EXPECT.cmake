# CW_HAVE_BUILTIN_EXPECT cmake function -- this file is part of cmake-aicxx..
#
# MIT License
#
# Copyright (c) 2026 Carlo Wood <carlo@alinoe.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include_guard(GLOBAL)
include(CheckCXXSourceCompiles)

# CW_HAVE_BUILTIN_EXPECT
#
# Test whether the compiler supports __builtin_expect() and store the result
# in the internal cache variable HAVE_BUILTIN_EXPECT (1 when supported, 0 otherwise).
#
# To make the result available to C++ source files, add the following to a
# CMake-configured config header (for example cmake-config.h.in):
#
#     #cmakedefine01 HAVE_BUILTIN_EXPECT
#
# which expands to `#define HAVE_BUILTIN_EXPECT 1` or `0` accordingly.

function(CW_HAVE_BUILTIN_EXPECT)
  # The source merely needs to compile and link; __builtin_expect is a
  # compiler builtin, so compilation success is sufficient to detect it.
  check_cxx_source_compiles(
    "int main() { return __builtin_expect(0, 0); }"
    HAVE_BUILTIN_EXPECT)
endfunction()
