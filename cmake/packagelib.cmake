# cmake/Helpers.cmake

function(package_lib TARGET_NAME)
    set(options INTERFACE)
    set(oneValueArgs)
    set(multiValueArgs SOURCES INCLUDES ARCHIVES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_INTERFACE)
        add_library(${TARGET_NAME} INTERFACE)
    else()
        add_library(${TARGET_NAME} STATIC ${ARG_SOURCES})
    endif()

    # Handle includes
    if(ARG_INCLUDES)
        if(ARG_INTERFACE)
            target_include_directories(${TARGET_NAME} INTERFACE ${ARG_INCLUDES})
        else()
            target_include_directories(${TARGET_NAME} PUBLIC ${ARG_INCLUDES})
        endif()
    endif()

    # Handle dependent archives/libs
    if(ARG_ARCHIVES)
        if(ARG_INTERFACE)
            target_link_libraries(${TARGET_NAME} INTERFACE ${ARG_ARCHIVES})
        else()
            target_link_libraries(${TARGET_NAME} PUBLIC ${ARG_ARCHIVES})
        endif()
    endif()
endfunction()
