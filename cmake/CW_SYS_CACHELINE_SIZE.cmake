# CW_SYS_CACHLINE_SIZE cmake function -- this file is part of cmake-aicxx.
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

# CW_SYS_CACHELINE_SIZE
#
# Set CW_CACHELINE_SIZE to the size of a cache line, in bytes.
#
# To use this, add the following line in config.h.in:
#
#     static constexpr int cacheline_size_c = @CW_CACHELINE_SIZE@;
#

set(CW_SYS_CACHELINE_SIZE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

function(CW_SYS_CACHELINE_SIZE)
  if (NOT DEFINED CACHE{CW_CACHELINE_SIZE})
    set(CMAKE_TRY_COMPILE_CONFIGURATION "Release")
    try_run(run_works
        compile_works
        ${CMAKE_CURRENT_BINARY_DIR}/cw_utils_sys_cacheline_size
        ${CW_SYS_CACHELINE_SIZE_MODULE_PATH}/CW_SYS_CACHELINE_SIZE.c
        COMPILE_OUTPUT_VARIABLE compile_output
        RUN_OUTPUT_VARIABLE run_output)
    if (NOT compile_works)
      message(FATAL_ERROR "Failed to compile test program CW_SYS_CACHELINE_SIZE.c: ${compile_output}")
    elseif (NOT run_works EQUAL 0)
      message(FATAL_ERROR "Failed to run test program CW_SYS_CACHELINE_SIZE.c: ${run_output}")
    else ()
      set(CW_CACHELINE_SIZE ${run_output} CACHE INTERNAL "")
    endif ()
  endif ()
endfunction()
