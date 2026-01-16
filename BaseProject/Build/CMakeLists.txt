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

#
# Discover all Projects
#

DiscoverProjects("${WORKSPACE_DIRECTORY}")
GetProjectList(ProjectList)

if(ProjectList)
	list(JOIN ProjectList ", " ProjectListString)
	message(STATUS "Projects: [${ProjectListString}]")

	#foreach(ProjectName ${ProjectList})
	#	GetProjectEntry(ProjectDirectory "${ProjectName}" "Directory")
	#	DiscoverComponents("${ProjectName}" "${ProjectDirectory}")
	#endforeach()
else()
	message(WARNING "No projects found.")
endif()
