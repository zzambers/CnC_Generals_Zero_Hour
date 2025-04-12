add_library(z_browserdispatch INTERFACE)

if(WIN32 OR "${CMAKE_SYSTEM}" MATCHES "Windows")
    if(MINGW)
    add_custom_command(
        OUTPUT BrowserDispatch_i.c BrowserDispatch.h
        COMMAND "$ENV{WIDL}" "${CMAKE_CURRENT_LIST_DIR}/BrowserDispatch.idl" -H BrowserDispatch.h
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS "${CMAKE_CURRENT_LIST_DIR}/BrowserDispatch.idl"
        VERBATIM
    )
    else()
    add_custom_command(
        OUTPUT BrowserDispatch_i.c BrowserDispatch.h
        COMMAND midl.exe "${CMAKE_CURRENT_LIST_DIR}\\BrowserDispatch.idl" /header BrowserDispatch.h
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS "${CMAKE_CURRENT_LIST_DIR}/BrowserDispatch.idl"
        VERBATIM
    )
    endif()
    add_library(z_browserdispatchwin STATIC BrowserDispatch_i.c)
    set_target_properties(z_browserdispatchwin PROPERTIES OUTPUT_NAME browserdispatchwin)
    target_link_libraries(z_browserdispatch INTERFACE z_browserdispatchwin)
endif()

target_include_directories(z_browserdispatch INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/..)
