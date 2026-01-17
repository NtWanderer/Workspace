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
	#
	#

	file(GLOB AllFiles RELATIVE "${WORKSPACE_DIRECTORY}" "${WORKSPACE_DIRECTORY}/*")

	foreach(FileName ${AllFiles})
		set(FullFilePath "${WORKSPACE_DIRECTORY}/${FileName}")

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
