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
