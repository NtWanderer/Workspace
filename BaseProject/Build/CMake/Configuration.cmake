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
