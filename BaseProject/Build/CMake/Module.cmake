# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Internal Modules function helpers.
#

# TODO
function(AddModuleList InModuleName)
    AddRegistryList(MODULE ${InModuleName})
endfunction()

# TODO
function(GetModuleList OutValue)
    GetRegistryList(Value MODULE)
    set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# TODO
function(SetModuleEntry InModuleName InPropertyName InValue)
	SetRegistryEntry(MODULE ${InModuleName} ${InPropertyName} ${InValue})
endfunction()

# TODO
function(GetModuleEntry OutValue InModuleName InPropertyName)
	GetRegistryEntry(Value MODULE ${InModuleName} ${InPropertyName})
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()
