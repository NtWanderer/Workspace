# Discovery - Implementation Plan

## Executive Summary
The Build System should crawl the `Workspace` to search for every `Project` and then search for every `Target` and `Module` at the `Source` subdirectory of each `Project`.

### Phase 1: Infrastructure
- **Objective**: Create the entry-point scripts and the base CMake logic for recursive scanning.
- **Sub-tasks**:
    - Implement the `Workspace/BaseProject/Build/CMake/Discovery.cmake` script file.
    - Define `FindProjects()` function to identify subdirectories containing a `<ProjectName>.Project.cmake` file.
    - Create the top-level `Workspace/BaseProject/Build/CMakeLists.txt` to include the scanner.

### Phase 2: Project Metadata Parsing
- **Objective**: Implement the logic to read and validate the `<ProjectName>.Project.cmake` files.
- **Sub-tasks**:
    - Create a standard macro `RegisterProject()` that parses `Name`, `Version`, and `Author`.
    - Implement a loop to scan the `Source/` directory of each found Project for Targets and Modules.

### Phase 3: Target & Module Discovery
- **Objective**: Catalog every Target and Module within the `Source/` subdirectory.
- **Sub-tasks**:
    - Implement `FindTargets()`: Search for `<TargetName>.Target.cmake` files.
    - Implement `FindModules()`: Identify subdirectories (Modules) and check for associated metadata.
    - Map the relationships: Link `Targets` to the `Modules` they explicitly list in their metadata.

### Phase 4: Hierarchy Verification & Logging
- **Objective**: Ensure the discovered structure matches the expected hierarchy and provide feedback to the user.
- **Sub-tasks**:
    - Implement a "Discovery Report" that prints the found Workspace structure (Tree view) during the CMake generation phase.
    - Validate that every `Project` has at least one `Target` and that `Modules` are correctly located in the `Source/` directory.
