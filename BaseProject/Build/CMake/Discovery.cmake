# Copyright (c) Workspace. All Rights Reserved.

include_guard(GLOBAL)

include("Registry")
include("Project")

#
# Discovery Phase
#

message(STATUS "Starting Workspace Discovery: ${WORKSPACE_DIRECTORY}")

# 1. Identify all potential project directories in the Workspace
file(GLOB ALL_FILES RELATIVE "${WORKSPACE_DIRECTORY}" "${WORKSPACE_DIRECTORY}/*")

foreach(Entry ${ALL_FILES})
    set(FullEntryPath "${WORKSPACE_DIRECTORY}/${Entry}")
    
    if(IS_DIRECTORY "${FullEntryPath}")
        # 2. Search for the <ProjectName>.Project.cmake file inside the directory
        # According to the structure, we look for ProjectA/ProjectA.Project.cmake
        set(ProjectMetadataFile "${FullEntryPath}/${Entry}.Project.cmake")

        if(EXISTS "${ProjectMetadataFile}")
            # 3. Register the Project
            # The AddProject function (from Project.cmake) handles the Registry logic
            AddProject("${Entry}" "${FullEntryPath}")

            # 4. Include the metadata file to populate further info (Targets, Version, etc.)
            # This allows the project to call SetProjectEntry for additional metadata
            include("${ProjectMetadataFile}")
        endif()
    endif()
endforeach()

# 5. Summary of discovered projects
GetProjectList(DiscoveredProjects)

if(DiscoveredProjects)
    list(JOIN DiscoveredProjects ", " ProjectListStr)
    message(STATUS "Discovery Complete. Registered Projects: [${ProjectListStr}]")
else()
    message(WARNING "Discovery Complete. No valid projects found in the workspace.")
endif()
