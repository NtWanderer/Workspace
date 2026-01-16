# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")
include("Project")

#
# Discover Projects
#

# TODO
function(DiscoverProjects InWorkspaceDirectory)
    #
    #
    #

    file(GLOB AllFiles RELATIVE "${InWorkspaceDirectory}" "${InWorkspaceDirectory}/*")

    foreach(File ${AllFiles})
        set(FullFilePath "${InWorkspaceDirectory}/${File}")

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

                AddProject("${File}" "${FullFilePath}")
            endforeach()
        endif()
    endforeach()
endfunction()
