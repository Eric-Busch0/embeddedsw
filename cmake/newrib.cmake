# Usage:
#   cmake -P scaffold.cmake
#        -DDEST_DIR=/abs/path/new-project
#        -DPROJECT=hello_uart -DBOARD=zcu102 -DCORE=a53
#        [-DFORCE=ON]
cmake_minimum_required(VERSION 3.18)

set(TEMPLATE_DIR "${CMAKE_CURRENT_LIST_DIR}/rib-template")
# ---- inputs ----
if(NOT DEFINED TEMPLATE_DIR OR NOT DEFINED DEST_DIR)
  message(FATAL_ERROR "Set -DTEMPLATE_DIR and -DDEST_DIR")
endif()
if(NOT DEFINED PROJECT)
  set(PROJECT newproj)
endif()
if(NOT DEFINED BOARD)
  set(BOARD myboard)
endif()
if(NOT DEFINED CORE)
  set(CORE a53) # or r5/a9
endif()
if(NOT DEFINED FORCE)
  set(FORCE OFF)
endif()

# Normalize
get_filename_component(TEMPLATE_DIR "${TEMPLATE_DIR}" ABSOLUTE)
get_filename_component(DEST_DIR     "${DEST_DIR}"     ABSOLUTE)

if(NOT EXISTS "${TEMPLATE_DIR}")
  message(FATAL_ERROR "TEMPLATE_DIR not found: ${TEMPLATE_DIR}")
endif()
if(EXISTS "${DEST_DIR}" AND NOT FORCE)
  message(FATAL_ERROR "DEST_DIR exists. Pass -DFORCE=ON to overwrite: ${DEST_DIR}")
endif()
file(MAKE_DIRECTORY "${DEST_DIR}")

# Variables available to @ONLY configure_file()
set(PROJECT_NAME "${PROJECT}")
set(BOARD_NAME   "${BOARD}")
set(CORE_NAME    "${CORE}")

# Helper: replace tokens in path segments (filenames/dirs)
function(_subst_path OUT INPATH)
  set(P "${INPATH}")
  string(REPLACE "@PROJECT@" "${PROJECT}" P "${P}")
  string(REPLACE "@BOARD@"   "${BOARD}"   P "${P}")
  string(REPLACE "@CORE@"    "${CORE}"    P "${P}")
  set(${OUT} "${P}" PARENT_SCOPE)
endfunction()

# Recursively walk template
file(GLOB_RECURSE _ALL RELATIVE "${TEMPLATE_DIR}" "${TEMPLATE_DIR}/*")

foreach(rel IN LISTS _ALL)
  set(src "${TEMPLATE_DIR}/${rel}")

  # Map to destination path (preserve tree), then replace tokens in path
  _subst_path(rel_sub "${rel}")
  set(dst "${DEST_DIR}/${rel_sub}")

  if(IS_DIRECTORY "${src}")
    file(MAKE_DIRECTORY "${dst}")
    continue()
  endif()

  # Ensure parent dir exists
  get_filename_component(dst_dir "${dst}" DIRECTORY)
  file(MAKE_DIRECTORY "${dst_dir}")

  # Decide: configure or copy?
  get_filename_component(ext "${src}" EXT)
  if(ext STREQUAL ".in")
    # Drop .in extension in the output filename
    string(REGEX REPLACE "\\.in$" "" dst_cfg "${dst}")
    configure_file("${src}" "${dst_cfg}" @ONLY NEWLINE_STYLE UNIX)
  else()
    # Raw copy (preserve mode)
    execute_process(COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${src}" "${dst}")
  endif()
endforeach()

message(STATUS "Scaffold created at: ${DEST_DIR}")
message(STATUS "  PROJECT=${PROJECT}  BOARD=${BOARD}  CORE=${CORE}")
