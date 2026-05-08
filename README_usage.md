# Using an aicxx submodule

The root project should be using
[cmake](https://cmake.org/),
[cmake-aicxx](https://github.com/CarloWood/cmake-aicxx) and
[cwds](https://github.com/CarloWood/cwds).

## Checking out a project that uses the cmake-aicxx submodule.

To clone a project `example-project` that uses aicxx submodules simply clone the project using `--recurse-submodules` and then run `./autogen.sh`:

    git clone --recurse-submodules <URL-to-project>/example-project.git
    cd example-project
    ./autogen.sh

If you forget to use `--recurse-submodules` then `./autogen.sh` will fix that.

## Adding an aicxx submodule to your project

To add a submodule *XYZ* to a project, that project should already be set up to use [cmake-aicxx](https://github.com/CarloWood/cmake-aicxx).

Simply execute the following in a directory of that project
where you want to have the `XYZ` subdirectory:

    git submodule add https://github.com/CarloWood/XYZ.git

This should clone *XYZ* into the subdirectory `XYZ`, or
if you already cloned it there, it should add it.

Note that if *XYZ* starts with `ai-` then the required
subdirectory that it is cloned into needs to have that prefix removed!
Currently those submodules are `ai-utils`, `ai-statefultask` and `ai-xml`.
For example to add the submodule `ai-utils` to a project, execute the following in the root of the project:

    git submodule add https://github.com/CarloWood/ai-utils.git utils

### Using CMake

For most projects you probably also want to enable [gitache](https://github.com/CarloWood/gitache).
That project is self-installing and only requires that you set
another environment variable, pointing to a (large) directory that
you have write access to. For example,

    export GITACHE_ROOT="/opt/gitache"

where `/opt/gitache` is owned by you.

The typical `CMakeLists.txt` file, containing a single executable,
would look like

    include(AICxxProject)

    add_executable(some_test some_test.cxx)
    target_link_libraries(some_test PRIVATE ${AICXX_OBJECTS_LIST})

That is, `AICXX_OBJECTS_LIST` is, automatically, filled with all the
objects of all the aicxx submodules. Alternatively, you can list all
required aicxx submodules manually. For example,

    add_executable(some_test some_test.cxx)
    target_link_libraries(some_test PRIVATE AICxx::statefultask AICxx::evio AICxx::evio_protocol AICxx::threadpool AICxx::threadsafe AICxx::events AICxx::xml AICxx::math AICxx::utils AICxx::cwds)

The order is mostly significant because many modules depend on modules that appear later in the list.

Finally, run

<pre>
./autogen.sh
</pre>

to let cmake-aicxx do its magic, and commit all the changes.
