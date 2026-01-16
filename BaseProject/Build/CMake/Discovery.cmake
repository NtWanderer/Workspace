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
