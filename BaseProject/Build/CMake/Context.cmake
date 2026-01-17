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
