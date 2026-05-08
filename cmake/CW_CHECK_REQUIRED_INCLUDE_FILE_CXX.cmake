# CW_CHECK_REQUIRED_INCLUDE_FILE_CXX cmake function -- this file is part of cmake-aicxx.
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
include(CheckIncludeFileCXX)

# CW_CHECK_REQUIRED_INCLUDE_FILE_CXX (<include_file> <error_message>)
#
# Check if the given <include_file> may be included in a CXX source file,
# if successful store the result in an internal cache entry named derived
# from <include_file>. Otherwise print a fatal error <error_message>.

function(CW_CHECK_REQUIRED_INCLUDE_FILE_CXX include_file error_message)
  string(MAKE_C_IDENTIFIER "HAVE_${include_file}" include_id)
  string(TOUPPER "${include_id}" upper_include_id)
  check_include_file_cxx("${include_file}" "${upper_include_id}")
  if (NOT ${upper_include_id})
    unset(${upper_include_id} CACHE)
    message(FATAL_ERROR "\n${error_message}\n")
  endif ()
endfunction ()
