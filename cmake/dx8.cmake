FetchContent_Declare(
    dx8
    GIT_REPOSITORY https://github.com/TheSuperHackers/min-dx8-sdk.git
    GIT_TAG        20d31185872e1304e0573f7f4885ae11e50670d3
)
if(MINGW)
    if(NOT dx8_POPULATED)
        FetchContent_Populate(dx8)
    endif()
    # only use d3dx8 headers, other stuff is provided by MinGW
    file(MAKE_DIRECTORY "${dx8_BINARY_DIR}/d3dx8-inc")
    file(COPY
        "${dx8_SOURCE_DIR}/d3dx8.h"
        "${dx8_SOURCE_DIR}/d3dx8core.h"
        "${dx8_SOURCE_DIR}/d3dx8effect.h"
        "${dx8_SOURCE_DIR}/d3dx8math.h"
        "${dx8_SOURCE_DIR}/d3dx8math.inl"
        "${dx8_SOURCE_DIR}/d3dx8mesh.h"
        "${dx8_SOURCE_DIR}/d3dx8shape.h"
        "${dx8_SOURCE_DIR}/d3dx8tex.h"
        DESTINATION
        "${dx8_BINARY_DIR}/d3dx8-inc"
    )
    add_library(d3dx8 INTERFACE)
    target_link_libraries(d3dx8 INTERFACE d3dx8d)
    add_library(d3d8lib INTERFACE)
    target_link_libraries(d3d8lib INTERFACE d3d8 d3dx8 dinput8 dxguid)
    target_include_directories(d3d8lib INTERFACE "${dx8_BINARY_DIR}/d3dx8-inc")
    # workaround few missing macros in MinGW headers
    target_compile_definitions(d3d8lib INTERFACE
        D3DPRESENT_RATE_DEFAULT=0
        "D3DSGR_NO_CALIBRATION=__MSABI_LONG(0x00000000)"
        "D3DSGR_CALIBRATE=__MSABI_LONG(0x00000001)"
        "D3DCURSOR_IMMEDIATE_UPDATE=__MSABI_LONG(0x00000001)"
    )
else()
    FetchContent_MakeAvailable(dx8)
endif()
