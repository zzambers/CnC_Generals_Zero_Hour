FetchContent_Declare(
    reactos
    GIT_REPOSITORY https://github.com/reactos/reactos.git
    GIT_TAG        5022a451df34652c88654c4d5f7aebf730f7ce9c
)
if(NOT reactos_POPULATED)
    FetchContent_Populate(reactos)
endif()
# pseh
if (${CMAKE_SIZEOF_VOID_P} EQUAL 4)
    # 32-bit build uses pseh from reactos, as 32-bit pseh code from MinGW
    # does not work with C++ (only with C)
    add_library(pseh INTERFACE)
    target_include_directories(pseh INTERFACE "${reactos_SOURCE_DIR}/sdk/lib/pseh/include")
    target_compile_definitions(pseh INTERFACE _USE_PSEH3=1)
endif()

# atl
add_subdirectory("${reactos_SOURCE_DIR}/sdk/lib/atl")
target_compile_definitions(atl_classes INTERFACE
    _ATL_IIDOF=__uuidof
    _Delegate=0
)

# comsupp
file(MAKE_DIRECTORY "${reactos_BINARY_DIR}/comsupp-src")
file(COPY "${reactos_SOURCE_DIR}/sdk/lib/comsupp/comsupp.cpp"
    # needs comdef.h from reactos (compilation fails with comdef.h from MinGW)
    "${reactos_SOURCE_DIR}/sdk/include/vcruntime/comdef.h"
    DESTINATION "${reactos_BINARY_DIR}/comsupp-src")
# definition of _INC_WINDOWS in comsupp.cpp breaks MinGW build, workaround: doing includes first
file(WRITE "${reactos_BINARY_DIR}/comsupp-src/comsupp-fixed.cpp"
    "#include <windef.h>\n"
    "#include <winbase.h>\n"
    "#include <comdef.h>\n"
    "#include <comsupp.cpp>\n"
)
add_library(comsuppw STATIC "${reactos_BINARY_DIR}/comsupp-src/comsupp-fixed.cpp")
target_include_directories(comsuppw PRIVATE "${reactos_BINARY_DIR}/comsupp-src")
target_compile_definitions(comsuppw PRIVATE
    # workaround for: multiple definition of `_com_raise_error(long, IErrorInfo*)@8'
    _com_raise_error=_com_raise_error2
    # are these necessary?
    WIN32_NO_STATUS
    WITH_EXCEPTIONS
)
