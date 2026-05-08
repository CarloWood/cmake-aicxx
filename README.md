# cmake-aicxx git submodule

This repository is a git submodule containing CMake utilities and helper scripts for building and maintaining CMake-based projects that use git submodules.

## Checking out a project that uses the cmake-aicxx submodule.

Please read [README_usage](README_usage.md).

## Adding the cmake-aicxx submodule to a project.

To add this submodule to a project, execute the following in the root of the project:

<pre>
git submodule add https://github.com/CarloWood/cmake-aicxx.git cmake/aicxx
</pre>

This should clone cmake-aicxx into the subdirectory cmake/aicxx, or if you already cloned it there, it should add it.
Note that if the directory `cmake` doesn't exist yet, it will be created.

Next run:

<pre>
cp cmake/aicxx/templates/autogen.sh .
./autogen.sh
</pre>

and follow the instructions (if any).

Finally add <tt>autogen.sh</tt> to your project:

<pre>
git add autogen.sh
</pre>

And commit your changes.

Note that aicxx submodules are discovered by `AICxxSubmodules.cmake`.
That file contains the ordered list of all AICxx module directories.
When `include(AICxxSubmodules)` is used, each listed directory that exists and
contains a `CMakeLists.txt` is automatically added to the project with `add_subdirectory()`.

## Cloning this project.

If you make your own clone of cmake-aicxx, make sure to set the environment variables <tt>GIT_COMMITTER_EMAIL</tt> and <tt>GIT_COMMITTER_NAME</tt>
(and likely you also want to set <tt>GIT_AUTHOR_EMAIL</tt> and <tt>GIT_AUTHOR_NAME</tt>)
and edit <tt>cmake/aicxx/templates/autogen.sh</tt> to use the md5 hash of your <tt>GIT_COMMITTER_EMAIL</tt>.

<pre>
echo "$GIT_COMMITTER_EMAIL" | md5sum
</pre>
