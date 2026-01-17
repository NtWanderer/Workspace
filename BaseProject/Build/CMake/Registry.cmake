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
