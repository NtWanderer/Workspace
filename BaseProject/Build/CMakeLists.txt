# Copyright (c) Workspace. All Rights Reserved.

cmake_minimum_required(VERSION 3.20)
project(Workspace)

#
# Set the Workspace directory.
#

set(WORKSPACE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../../")
get_filename_component(WORKSPACE_DIRECTORY "${WORKSPACE_DIRECTORY}" ABSOLUTE)

#
# Append the BaseProject CMake scripts subdirectory to the include path.
#

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/CMake")

#
#
#

include("Discovery")
include("Context")

#
#
#

DiscoverProjects()
GetProjectList(ProjectList)

if(NOT ProjectList)
	message(WARNING "No projects found.")
	return()
endif()

#
#
#

ContextLoadProjects()

#
#
#

foreach(ProjectName ${ProjectList})
	GetProjectEntry(ProjectNameAlt "${ProjectName}" "Name")

	if (ProjectNameAlt)
		list(APPEND ProjectListNames "${ProjectNameAlt}")
	else()
		list(APPEND ProjectListNames "${ProjectName}")
	endif()

	GetProjectEntry(ProjectDirectory "${ProjectName}" "Directory")
	DiscoverProjectComponents("${ProjectName}" "${ProjectDirectory}")
endforeach()

list(JOIN ProjectListNames ", " ProjectListString)
message(STATUS "Projects: [${ProjectListString}]")

#
#
#
