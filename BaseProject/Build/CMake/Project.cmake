# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Project Directories
#

set(PROJECT_BINARIES_DIRECTORY		"Binaries")
set(PROJECT_BUILD_DIRECTORY			"Build")
set(PROJECT_CONTENT_DIRECTORY		"Content")
set(PROJECT_DOCUMENTATION_DIRECTORY	"Documentation")
set(PROJECT_PLUGINS_DIRECTORY		"Plugins")
set(PROJECT_PROGRAMS_DIRECTORY		"Programs")
set(PROJECT_SHADERS_DIRECTORY		"Shaders")
set(PROJECT_SOURCE_DIRECTORY		"Source")

#
# Project Build Subdirectories
#

set(PROJECT_BUILD_LIBRARIES_DIRECTORY		"${PROJECT_BUILD_DIRECTORY}/Libraries")
set(PROJECT_BUILD_INTERMEDIATES_DIRECTORY	"${PROJECT_BUILD_DIRECTORY}/Intermediates")

#
# Project Build/Intermediates Subdirectories
#

set(PROJECT_BUILD_INTERMEDIATES_BUILDFILES_DIRECTORY    "${PROJECT_BUILD_INTERMEDIATES_DIRECTORY}/BuildFiles")
set(PROJECT_BUILD_INTERMEDIATES_PROJECTFILES_DIRECTORY  "${PROJECT_BUILD_INTERMEDIATES_DIRECTORY}/ProjectFiles")

#
# Project Helper Functions
#

# TODO
function(AddProjectList InProjectName)
	AddRegistryList("PROJECT" "${InProjectName}")
endfunction()

# TODO
function(GetProjectList OutValue)
	GetRegistryList(Value "PROJECT")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# TODO
function(AddProjectEntry InProjectName InPropertyName InValue)
	AddRegistryEntry("PROJECT" "${InProjectName}" "${InPropertyName}" "${InValue}")

	Trace("[AddProjectEntry][${InProjectName}] ${InPropertyName} ${InValue}")
endfunction()

# TODO
function(SetProjectEntry InProjectName InPropertyName InValue)
	SetRegistryEntry("PROJECT" "${InProjectName}" "${InPropertyName}" "${InValue}")
endfunction()

# TODO
function(GetProjectEntry OutValue InProjectName InPropertyName)
	GetRegistryEntry(Value "PROJECT" "${InProjectName}" "${InPropertyName}")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

#
# Project Properties
#

# TODO
function(AddProject InProjectName InProjectDirectory)
	#
	# TODO
	#

	GetProjectList(ProjectList)

	if("${InProjectName}" IN_LIST ProjectList)
		message(WARNING "Project [${InProjectName}] already registered.")
		return()
	endif()

	#
	# TODO
	#

	AddProjectList("${InProjectName}")

	#
	# TODO
	#

	get_filename_component(AbsoluteDirectory "${InProjectDirectory}" ABSOLUTE)

	SetProjectEntry("${InProjectName}" "Directory" "${AbsoluteDirectory}")
endfunction()
