## The current progress:

### ✅ COMPLETED
- Basic Discovery Phase logic implemented;
- Basic Project API implemented;

### 🟡 IN PROGRESS
 - Build Configurations;
 - Full Pipeline Design;

### ⚠️ BLOCKERS
- Need to decide on configuration strategy;

## Your current task:
- Using the Registry system, develop a new CMake module file (`CMake/Configuration.cmake`) to add default `Configurations` that `Targets` are going to inherit from;
- Use the tables below to better understand the system;

## **BUILD TARGET CONFIGURATIONS REFERENCE**

| State           | Description                                                                                                                                                                                                                                                                             |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Debug**       | A non-optimized build designed for troubleshooting and in-depth code inspection. This configuration favors clarity and ease of debugging over runtime speed, making it suitable for investigating issues and verifying system behavior.                                                 |
| **Development** | A balanced configuration intended for regular development work. Most optimizations are enabled, but build times remain manageable. The project is compiled **modularly**, allowing individual components to be rebuilt quickly and improving iteration speed during active development. |
| **Release**     | A fully optimized configuration for final distribution. The entire target is compiled as a single monolithic binary, removing auxiliary debugging utilities and internal diagnostics to achieve maximum performance and minimal overhead.                                               |
| **Test**        | Structurally similar to Release in terms of optimization, but retains a limited set of diagnostic and profiling capabilities. This configuration is useful for QA workflows, automated tests, and performance evaluations where some internal visibility is still required.             |
## **BUILD TARGET TYPES REFERENCE**

| **State**         | **Description**                                                                                                                                                                               |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Standalone**    | Builds a self-contained executable. Ideal for local applications that operate independently without requiring external network-based orchestration.                                           |
| **Client**        | Builds the user-facing interface. This target excludes backend-heavy processing or administrative logic to ensure a lightweight footprint and improved security for the end-user environment. |
| **Server**        | Builds a headless, background-running process. This target strips out UI, rendering, and local input logic, focusing entirely on data processing, API handling, and system-level tasks.       |
| **SharedLibrary** | Builds the target as a standalone shared library. Used for creating modular components or SDKs that can be linked by multiple external applications.                                          |
| **Program**       | Builds a minimal, specialized binary designed for automation or CLI tasks. Unlike other Targets, it only supports **Debug** and **Release** modes.                                            |

## **BUILD TARGET PLATFORMS REFERENCE**

| State       | Description                                                                                                       |
| ----------- | ----------------------------------------------------------------------------------------------------------------- |
| **Android** | Targets **Android** mobile devices.                                                                               |
| **FreeBSD** | Targets **FreeBSD** server environments.                                                                          |
| **IOS**     | Targets **iOS** and **iOS Simulator**.                                                                            |
| **Linux**   | Targets all major **Linux** distributions such as **Debian**, **Ubuntu**, **Arch**, **Fedora**, **SteamOS**, etc. |
| **MacOS**   | Targets Apple desktop hardware (Intel and Apple Silicon).                                                         |
| **Windows** | Targets the **Windows** desktop and related environments.                                                         |

## **BUILD TARGET ARCHITECTURES REFERENCE**

| State     | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| **x86**   | Only supported on **Windows**.                                        |
| **x64**   | Supported by **FreeBSD**, **Linux**, **MacOS** (old) and **Windows**. |
| **ARM32** | Only supported on **Android**.                                        |
| **ARM64** | Supported by all platforms.                                           |

## **BUILD TARGET COMPILERS REFERENCE**

| State     | Description                             |
| --------- | --------------------------------------- |
| **Clang** | Supported by all platforms.             |
| **GCC**   | Supported by **FreeBSD** and **Linux**. |
| **MSVC**  | Only supported on **Windows**.          |

## CMake script files

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
# TODO
#

include("Configuration")
include("Discovery")
include("Context")

#
# Initialization
#

InitializeConfigurations()
InitializeDefaultConfigurations()

#
# TODO
#

DoDiscovery()

#
# TODO
#

ContextLoadProjects()
ContextLoadTargets()
ContextLoadModules()
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
	get_property(GlobalList GLOBAL PROPERTY "REGISTRY_${InRegistryType}_LIST")

	if(NOT "${InRegistryName}" IN_LIST GlobalList)
		set_property(GLOBAL APPEND PROPERTY "REGISTRY_${InRegistryType}_LIST" "${InRegistryName}")
	endif()
endmacro()

# Get the actual RegistryType list.
macro(GetRegistryList OutVar InRegistryType)
	get_property(${OutVar} GLOBAL PROPERTY "REGISTRY_${InRegistryType}_LIST")
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
function(AddProject InProjectName InProjectFile InProjectDirectory)
	#
	# TODO
	#

	GetProjectList(ProjectList)

	if("${InProjectName}" IN_LIST ProjectList)
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

	SetProjectEntry("${InProjectName}" "File" "${InProjectFile}")
	SetProjectEntry("${InProjectName}" "Directory" "${AbsoluteDirectory}")
endfunction()

# TODO
function(AddProjectComponent InProjectName InPropertyName InComponentName)
	#
	# TODO
	#

	GetProjectEntry(ComponentList "${InProjectName}" "${InPropertyName}")

	if("${InComponentName}" IN_LIST ComponentList)
		return()
	endif()

	#
	#
	#

	AddProjectEntry("${InProjectName}" "${InPropertyName}" "${InComponentName}")
endfunction()

#
# Project API
#

# Sets a descriptive name for the project, overriding the folder-based name.
function(SetProjectName InName)
    SetProjectEntry("${CurrentProject}" "Name" "${InName}")
endfunction()

# Sets the version of the project.
function(SetProjectVersion InMajor InMinor InPatch)
    SetProjectEntry("${CurrentProject}" "Version" "${InMajor}.${InMinor}.${InPatch}")
endfunction()

# Adds one or more authors to the project.
function(AddProjectAuthor)
    foreach(Author ${ARGN})
        AddProjectEntry("${CurrentProject}" "Author" "${Author}")
    endforeach()
endfunction()

# Sets the category for the project.
function(SetProjectCategory InCategory)
    SetProjectEntry("${CurrentProject}" "Category" "${InCategory}")
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
function(AddTarget InTargetName InProjectName InTargetFile InTargetDirectory)
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
	SetTargetEntry("${InTargetName}" "File" "${InTargetFile}")
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
function(AddModule InModuleName InProjectName InModuleFile InModuleDirectory)
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
	SetModuleEntry("${InModuleName}" "File" "${InModuleFile}")
	SetModuleEntry("${InModuleName}" "Directory" "${AbsoluteDirectory}")
endfunction()
```

`Build/CMake/Configuration.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Internal Configurations function helpers.
#

# Adds a specified Configuration to the Configuration list.
function(AddConfigurationList InConfigurationName)
    AddRegistryList("CONFIGURATION" "${InConfigurationName}")
endfunction()

# Get the list of all registered Configurations.
function(GetConfigurationList OutValue)
    GetRegistryList(Value "CONFIGURATION")
    set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# Add a named Property entry for a Configuration.
function(AddConfigurationEntry InConfigurationName InPropertyName InValue)
	AddRegistryEntry("CONFIGURATION" "${InConfigurationName}" "${InPropertyName}" "${InValue}")
endfunction()

# Set a named Property entry for a Configuration.
function(SetConfigurationEntry InConfigurationName InPropertyName InValue)
    SetRegistryEntry("CONFIGURATION" "${InConfigurationName}" "${InPropertyName}" "${InValue}")
endfunction()

# Get a named Property entry of a Configuration.
function(GetConfigurationEntry OutValue InConfigurationName InPropertyName)
    GetRegistryEntry(Value "CONFIGURATION" "${InConfigurationName}" "${InPropertyName}")
    set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

#
# Initialize Configurations
#

# TODO
function(InitializeConfigurations)
	AddConfigurationList("Debug")
	AddConfigurationList("Development")
	AddConfigurationList("Release")
	AddConfigurationList("Test")
endfunction()

#
# Configuration API
#

# TODO
function(AddConfiguration InPropertyName InDebugValue InDevelopmentValue InReleaseValue InTestValue)
	AddConfigurationEntry("Debug" "${InPropertyName}" "${InDebugValue}")
	AddConfigurationEntry("Development" "${InPropertyName}" "${InDevelopmentValue}")
	AddConfigurationEntry("Release" "${InPropertyName}" "${InReleaseValue}")
	AddConfigurationEntry("Test" "${InPropertyName}" "${InTestValue}")
endfunction()

# TODO
function(SetConfiguration InPropertyName InDebugValue InDevelopmentValue InReleaseValue InTestValue)
    SetConfigurationEntry("Debug" "${InPropertyName}" "${InDebugValue}")
	SetConfigurationEntry("Development" "${InPropertyName}" "${InDevelopmentValue}")
	SetConfigurationEntry("Release" "${InPropertyName}" "${InReleaseValue}")
	SetConfigurationEntry("Test" "${InPropertyName}" "${InTestValue}")
endfunction()

#
# Initialize Default Configurations Settings
#

# TODO
function(InitializeDefaultConfigurations)
	#
	# Language
	#

	# CompileLanguage: C CXX OBJC OBJCXX
	SetConfiguration("CompileLanguage" CXX CXX CXX CXX)
	# CStandard: 99, 11, 17, 23, Latest
	SetConfiguration("CStandard" 17 17 17 17)
	# CppStandard: 98, 11, 14, 17, 20, 23, 26, Latest
	SetConfiguration("CppStandard" 20 20 20 20)
	# bRemoveUnreferencedCode: FALSE, TRUE
	SetConfiguration("bRemoveUnreferencedCode" TRUE TRUE TRUE TRUE)
	# bEnableRTTI: FALSE, TRUE
	SetConfiguration("bEnableRTTI" TRUE TRUE FALSE TRUE)

	#
	# Diagnostics
	#

	# WarningLevel: None, Standard, Rich, Pedantic, Everything
	SetConfiguration("WarningLevel" Standard Standard Everything Everything)
	# bWarningAsError: FALSE, TRUE
	SetConfiguration("bWarningAsError" FALSE FALSE TRUE TRUE)
	# bAddressSanitizer: FALSE, TRUE
	SetConfiguration("bAddressSanitizer" FALSE FALSE FALSE FALSE)
	# bPedanticStandard: FALSE, TRUE
	SetConfiguration("bPedanticStandard" TRUE TRUE TRUE TRUE)
	# bEnableStackProtection: FALSE, TRUE
	SetConfiguration("bEnableStackProtection" TRUE TRUE TRUE TRUE)

	#
	# Optimization
	#

	# OptimizationLevel: Disabled, Balanced, Fast, Maximum
	SetConfiguration("OptimizationLevel" Disabled Balanced Maximum Maximum)
	# bOptimizeForSize: FALSE, TRUE
	SetConfiguration("bOptimizeForSize" FALSE FALSE FALSE FALSE)
	# bInlineFunctions: FALSE, TRUE
	SetConfiguration("bInlineFunctions" FALSE TRUE TRUE TRUE)
	# bOmitFramePointers: FALSE, TRUE
	SetConfiguration("bOmitFramePointers" FALSE FALSE FALSE FALSE)
	# bEnableLinkTimeOptimization: FALSE, TRUE
	SetConfiguration("bEnableLinkTimeOptimization" FALSE FALSE TRUE TRUE)

	#
	# External Includes
	#

	# bTreatAngleBracketsIncludesAsExternal: FALSE, TRUE
	SetConfiguration("bTreatAngleBracketsIncludesAsExternal" TRUE TRUE TRUE TRUE)
	# bEnableExternalTemplateDiagnostics: FALSE, TRUE
	SetConfiguration("bEnableExternalTemplateDiagnostics" TRUE TRUE TRUE TRUE)
	# ExternalWarningLevel: None, Standard, Rich, Pedantic, Everything
	SetConfiguration("ExternalWarningLevel" None None None None)

	#
	# Code Generation
	#

	# bEnableExceptions: FALSE, TRUE
	SetConfiguration("bEnableExceptions" TRUE TRUE TRUE TRUE)
	# bEnablePrecompiledHeaderFiles: FALSE, TRUE
	SetConfiguration("bEnablePrecompiledHeaderFiles" FALSE FALSE FALSE FALSE)
	# StructMemberAlignment: Default, <Number>
	SetConfiguration("StructMemberAlignment" Default Default Default Default)
	# FloatingPointModel: Precise, Fast, Strict
	SetConfiguration("FloatingPointModel" Precise Precise Precise Precise)
	# bFloatingPointExceptions: FALSE, TRUE
	SetConfiguration("bFloatingPointExceptions" TRUE TRUE TRUE TRUE)

	#
	# Build and Linkage
	#

	# bEnableIncrementalLinking: FALSE, TRUE
	SetConfiguration("bEnableIncrementalLinking" TRUE TRUE FALSE FALSE)
	# bStripSymbols: FALSE, TRUE
	SetConfiguration("bStripSymbols" FALSE FALSE TRUE FALSE)
	# bUseUnityBuild: FALSE, TRUE
	SetConfiguration("bUseUnityBuild" FALSE FALSE FALSE FALSE)
	# UnityBuildBatchSize: Default, <Number>
	SetConfiguration("UnityBuildBatchSize" Default Default Default Default)
endfunction()
```

`Build/CMake/Discovery.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Project")
include("Target")
include("Module")

#
# Projects Discovery
#

# TODO
function(DiscoverProjects)
	#
	# TODO
	#

	file(GLOB AllFiles RELATIVE "${WORKSPACE_DIRECTORY}" "${WORKSPACE_DIRECTORY}/*")

	foreach(FileName ${AllFiles})
		set(FullFilePath "${WORKSPACE_DIRECTORY}/${FileName}")

		#
		# TODO
		#

		if(IS_DIRECTORY "${FullFilePath}")
			#
			# TODO
			#

			file(GLOB ProjectMetadataFiles "${FullFilePath}/*.Project.cmake")

			foreach(ProjectMetadataFile ${ProjectMetadataFiles})
				#
				# Register the Project using the folder name as the Project name.
				#

				get_filename_component(MetadataFileName "${ProjectMetadataFile}" NAME)

				AddProject("${FileName}" "${MetadataFileName}" "${FullFilePath}")
			endforeach()
		endif()
	endforeach()
endfunction()

# TODO
function(DiscoverProjectComponents InProjectName InProjectDirectory)
	#
	# TODO
	#

	set(ProjectSourceDirectory "${InProjectDirectory}/${PROJECT_SOURCE_DIRECTORY}")

	if(NOT EXISTS "${ProjectSourceDirectory}")
		return()
	endif()

	#
	# TODO
	#

	file(GLOB_RECURSE FoundComponents
		"${ProjectSourceDirectory}/*.Target.cmake"
		"${ProjectSourceDirectory}/*.Module.cmake"
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

			AddProjectComponent("${InProjectName}" "Targets" "${TargetName}")
			AddTarget("${TargetName}" "${InProjectName}" "${FileName}" "${FileDirectory}")
		elseif(FileName MATCHES "(.+)\\.Module\\.cmake$")
			#
			# Found Module
			#

			set(ModuleName "${CMAKE_MATCH_1}")

			AddProjectComponent("${InProjectName}" "Modules" "${ModuleName}")
			AddModule("${ModuleName}" "${InProjectName}" "${FileName}" "${FileDirectory}")
		endif()
	endforeach()
endfunction()

#
# TODO
#

# TODO
function(DoDiscovery)
	#
	# TODO
	#

	DiscoverProjects()
	GetProjectList(ProjectList)

	if(NOT ProjectList)
		message(WARNING "No projects found.")
		return()
	endif()

	#
	# TODO
	#

	foreach(ProjectName ${ProjectList})
		GetProjectEntry(ProjectDirectory "${ProjectName}" "Directory")
		DiscoverProjectComponents("${ProjectName}" "${ProjectDirectory}")
	endforeach()
endfunction()
```

`Build/CMake/Context.cmake`:
```cmake
# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Project")
include("Target")
include("Module")

#
# Internal context management helpers. 
#

# Sets the current project context.
macro(SetProjectContext InProjectName InProjectDirectory)
	set(CurrentProject "${InProjectName}")
	set(CurrentProjectDirectory "${InProjectDirectory}")
endmacro()

# Clears the current project context.
macro(ClearProjectContext)
	unset(CurrentProject)
	unset(CurrentProjectDirectory)
endmacro()

# Sets the current target context.
macro(SetTargetContext InTargetName InTargetDirectory)
	set(CurrentTarget "${InTargetName}")
	set(CurrentTargetDirectory "${InTargetDirectory}")
endmacro()

# Clears the current target context.
macro(ClearTargetContext)
	unset(CurrentTarget)
	unset(CurrentTargetDirectory)
endmacro()

# Sets the current module context.
macro(SetModuleContext InModuleName InModuleDirectory)
	set(CurrentModule "${InModuleName}")
	set(CurrentModuleDirectory "${InModuleDirectory}")
endmacro()

# Clears the current module context.
macro(ClearModuleContext)
	unset(CurrentModule)
	unset(CurrentModuleDirectory)
endmacro()

#
# Include helpers with proper context management.
#

# TODO
function(ContextIncludeProject InProjectName)
	GetProjectEntry(FileName "${InProjectName}" "File")
	GetProjectEntry(Directory "${InProjectName}" "Directory")

	set(FilePath "${Directory}/${FileName}")

	if(EXISTS "${FilePath}")
		SetProjectContext("${InProjectName}" "${Directory}")
		include("${FilePath}")
		ClearProjectContext()
	endif()
endfunction()

# TODO
function(ContextIncludeTarget InTargetName)
	GetTargetEntry(FileName "${InTargetName}" "File")
	GetTargetEntry(Directory "${InTargetName}" "Directory")

	set(FilePath "${Directory}/${FileName}")

	if(EXISTS "${FilePath}")
		SetTargetContext("${InTargetName}" "${Directory}")
		include("${FilePath}")
		ClearTargetContext()
	endif()
endfunction()

# TODO
function(ContextIncludeModule InModuleName)
	GetModuleEntry(FileName "${InModuleName}" "File")
	GetModuleEntry(Directory "${InModuleName}" "Directory")

	set(FilePath "${Directory}/${FileName}")

	if(EXISTS "${FilePath}")
		SetModuleContext("${InModuleName}" "${Directory}")
		include("${FilePath}")
		ClearModuleContext()
	endif()
endfunction()

#
# Load helpers with proper context management.
#

# TODO
function(ContextLoadProjects)
    GetProjectList(ProjectList)
    
    foreach(ProjectName ${ProjectList})
        ContextIncludeProject("${ProjectName}")
    endforeach()
endfunction()

# TODO
function(ContextLoadTargets)
    GetTargetList(TargetList)
    
    foreach(TargetName ${TargetList})
        ContextIncludeTarget("${TargetName}")
    endforeach()
endfunction()

# TODO
function(ContextLoadModules)
    GetModuleList(ModuleList)
    
    foreach(ModuleName ${ModuleList})
        ContextIncludeModule("${ModuleName}")
    endforeach()
endfunction()
```
