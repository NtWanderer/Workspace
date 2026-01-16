 The current progress is initial.

I've developed the beginning of the Discovery phase (the pre-configure phase) that crawls all the Workspace subdirectories in search of Projects. Now I'll start looking for Targets and Modules.

Your task: Update Discovery.cmake and add another function called "DiscoverComponents". This function should find every directory inside each Project source directory (`<ProjectName>/Source/`). For every directory, it should look for Targets (`<TargetName>.Target.cmake`) and Projects (`<ProjectName>.Project.cmake`). 

Current `Build/CMakeLists.txt`:
```cmake
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

	foreach(ProjectName ${ProjectList})
		GetProjectEntry(ProjectDirectory "${ProjectName}" "Directory")
		DiscoverProjectComponents("${ProjectName}" "${ProjectDirectory}")
	endforeach()
else()
	message(WARNING "No projects found.")
endif()
```

`Build/CMake/Registry.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

#
# Registry list access
#

# Add a specified Registry to the RegistryType list.
macro(AddRegistryList InRegistryType InRegistryName)
    get_property(GlobalList GLOBAL PROPERTY REGISTRY_${InRegistryType}_LIST)

    if(NOT "${InRegistryName}" IN_LIST GlobalList)
        set_property(GLOBAL APPEND PROPERTY REGISTRY_${InRegistryType}_LIST "${InRegistryName}")
    endif()
endmacro()

# Get the actual RegistryType list.
macro(GetRegistryList OutVar InRegistryType)
    get_property(${OutVar} GLOBAL PROPERTY REGISTRY_${InRegistryType}_LIST)
endmacro()

#
# Registry properties entries access
#

# Set a named Property entry in the named Registry of a RegistryType.
macro(SetRegistryEntry InRegistryType InRegistryName InPropertyName InValue)
	set(REGISTRY_${InRegistryType}_${InRegistryName}_${InPropertyName} "${InValue}" CACHE INTERNAL "")
endmacro()

# Add a named Property entry in the named Registry of a RegistryType.
macro(AddRegistryEntry InRegistryType InRegistryName InPropertyName InValue)
    set(VarName "REGISTRY_${InRegistryType}_${InRegistryName}_${InPropertyName}")
    
    if(DEFINED CACHE{${VarName}})
        set(TempList "$CACHE{${VarName}}")
    else()
        set(TempList "")
    endif()

    list(APPEND TempList "${InValue}")
    set(${VarName} "${TempList}" CACHE INTERNAL "")
endmacro()

# Get a named Property entry of the named Registry of a RegistryType.
macro(GetRegistryEntry OutVar InRegistryType InRegistryName InPropertyName)
	set(VarName "REGISTRY_${InRegistryType}_${InRegistryName}_${InPropertyName}")

	if(DEFINED ${VarName})
		set(${OutVar} "$CACHE{${VarName}}")
	else()
		set(${OutVar} "")
	endif()
endmacro()
```

`Build/CMake/Project.cmake`:
```cmake
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
```

`Build/CMake/Target.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Internal Targets function helpers.
#

# TODO
function(AddTargetList InTargetName)
	AddRegistryList("TARGET" "${InTargetName}")
endfunction()

# TODO
function(GetTargetList OutValue)
	GetRegistryList(Value "TARGET")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# TODO
function(AddTargetEntry InTargetName InPropertyName InValue)
	AddRegistryEntry("TARGET" "${InTargetName}" "${InPropertyName}" "${InValue}")
endfunction()

# TODO
function(SetTargetEntry InTargetName InPropertyName InValue)
	SetRegistryEntry("TARGET" "${InTargetName}" "${InPropertyName}" "${InValue}")
endfunction()

# TODO
function(GetTargetEntry OutValue InTargetName InPropertyName)
	GetRegistryEntry(Value "TARGET" "${InTargetName}" "${InPropertyName}")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

#
# Target Properties
#

# TODO
function(AddTarget InTargetName InProjectName InTargetDirectory)
	#
	# TODO
	#

	GetTargetList(TargetList)

	if("${InTargetName}" IN_LIST TargetList)
		message(WARNING "Target [${InTargetName}] already registered.")
		return()
	endif()

	#
	# TODO
	#

	AddTargetList("${InTargetName}")

	#
	# TODO
	#

	get_filename_component(AbsoluteDirectory "${InTargetDirectory}" ABSOLUTE)

	SetTargetEntry("${InTargetName}" "Project" "${InProjectName}")
	SetTargetEntry("${InTargetName}" "Directory" "${AbsoluteDirectory}")
endfunction()
```

`Build/CMake/Module.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Internal Modules function helpers.
#

# TODO
function(AddModuleList InModuleName)
	AddRegistryList("MODULE" "${InModuleName}")
endfunction()

# TODO
function(GetModuleList OutValue)
	GetRegistryList(Value "MODULE")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# TODO
function(AddModuleEntry InModuleName InPropertyName InValue)
	AddRegistryEntry("MODULE" "${InModuleName}" "${InPropertyName}" "${InValue}")
endfunction()

# TODO
function(SetModuleEntry InModuleName InPropertyName InValue)
	SetRegistryEntry("MODULE" "${InModuleName}" "${InPropertyName}" "${InValue}")
endfunction()

# TODO
function(GetModuleEntry OutValue InModuleName InPropertyName)
	GetRegistryEntry(Value "MODULE" "${InModuleName}" "${InPropertyName}")
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

#
# Module Properties
#

# TODO
function(AddModule InModuleName InProjectName InModuleDirectory)
	#
	# TODO
	#

	GetModuleList(ModuleList)

	if("${InModuleName}" IN_LIST ModuleList)
		message(WARNING "Module [${InModuleName}] already registered.")
		return()
	endif()

	#
	# TODO
	#

	AddModuleList("${InModuleName}")

	#
	# TODO
	#

	get_filename_component(AbsoluteDirectory "${InModuleDirectory}" ABSOLUTE)

	SetModuleEntry("${InModuleName}" "Project" "${InProjectName}")
	SetModuleEntry("${InModuleName}" "Directory" "${AbsoluteDirectory}")
endfunction()
```

`Build/CMake/Discovery.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")
include("Project")
include("Target")
include("Module")


#
# Discover Projects
#

# TODO
function(DiscoverProjects InWorkspaceDirectory)
	#
	#
	#

	file(GLOB AllFiles RELATIVE "${InWorkspaceDirectory}" "${InWorkspaceDirectory}/*")

	foreach(FileName ${AllFiles})
		set(FullFilePath "${InWorkspaceDirectory}/${FileName}")

		#
		#
		#

		if(IS_DIRECTORY "${FullFilePath}")
			#
			#
			#

			file(GLOB ProjectMetadataFiles "${FullFilePath}/*.Project.cmake")

			foreach(ProjectMetadataFile ${ProjectMetadataFiles})
				#
				# Register the Project using the folder name as the Project name.
				#

				AddProject("${FileName}" "${FullFilePath}")
			endforeach()
		endif()
	endforeach()
endfunction()

# TODO
function(DiscoverProjectComponents InProjectName InProjectDirectory)
	#
	# TODO
	#

	set(SearchDirectory "${InProjectDirectory}/${PROJECT_SOURCE_DIRECTORY}")

	if(NOT EXISTS "${SearchDirectory}")
		return()
	endif()

	#
	# TODO
	#

	file(GLOB_RECURSE FoundComponents
		"${SearchDirectory}/*.Target.cmake"
		"${SearchDirectory}/*.Module.cmake"
	)

	#
	# TODO
	#

	foreach(ComponentPath ${FoundComponents})
		get_filename_component(FileName "${ComponentPath}" NAME)
		get_filename_component(FileDirectory "${ComponentPath}" DIRECTORY)

		if(FileName MATCHES "(.+)\\.Target\\.cmake$")
			#
			# Found Target
			#

			set(TargetName "${CMAKE_MATCH_1}")

			AddTarget("${TargetName}" "${InProjectName}" "${FileDirectory}")
			AddProjectEntry("${InProjectName}" "Targets" "${TargetName}")
		elseif(FileName MATCHES "(.+)\\.Module\\.cmake$")
			#
			# Found Module
			#

			set(ModuleName "${CMAKE_MATCH_1}")

			AddModule("${ModuleName}" "${InProjectName}" "${FileDirectory}")
			AddProjectEntry("${InProjectName}" "Modules" "${ModuleName}")
		endif()
	endforeach()
endfunction()
```
