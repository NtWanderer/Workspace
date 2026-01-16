# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")

#
# Internal Targets function helpers.
#

# TODO
function(AddTargetList InTargetName)
    AddRegistryList(TARGET ${InTargetName})
endfunction()

# TODO
function(GetTargetList OutValue)
    GetRegistryList(Value TARGET)
    set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()

# TODO
function(SetTargetEntry InTargetName InPropertyName InValue)
	SetRegistryEntry(TARGET ${InTargetName} ${InPropertyName} ${InValue})
endfunction()

# TODO
function(GetTargetEntry OutValue InTargetName InPropertyName)
	GetRegistryEntry(Value TARGET ${InTargetName} ${InPropertyName})
	set(${OutValue} "${Value}" PARENT_SCOPE)
endfunction()
