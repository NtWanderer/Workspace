# Copyright (c) Workspace. All Rights Reserved.

cmake_minimum_required(VERSION 3.20)
project(Engine)

#
# Get the actual workspace directory.
#

set(WORKSPACE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../../")
get_filename_component(WORKSPACE_DIRECTORY "${WORKSPACE_DIRECTORY}" ABSOLUTE)

#
# Append the BaseProject CMake scripts subdirectory to the include path.
#

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/CMake")

include("Discovery")
