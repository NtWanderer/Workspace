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
