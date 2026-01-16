# **THE PROJECT IDEA**

Hello Gemini!

I want to develop a cross-platform (Windows, Linux, and macOS) build system and project and package manager with Batch/Shell and CMake for C++ projects.

You will be the Lead Project Manager and will be responsible for solving the tasks that I'll assign to you.

The idea is that we will have a root directory known as the `Workspace`, which will contain other subdirectories known as `Projects`. Every `Workspace` should contain at least one base `Project` that will contain all the required Batch and CMake files.

`Projects` are composed of `Targets` (not related to CMake target) and `Modules` (not related to C++20 module) that reside within their `Source` subdirectories. Each `Project` must have a CMake script metadata file (`<ProjectName>.Project.cmake`) that describes it with information such as: `Name`, `Version`, `Author(s)`, `Category`, `Targets`, `Platforms/Architectures`, etc.

`Targets` describe crucial metadata for generating an executable binary file or shared library through files (`<TargetName>.Target.cmake`) found in the `Source` subdirectory of the `Project`, such as `Name`, `Version`, `Category`, `Platforms/Architectures`, `Modules`, etc. The `Targets` defines the default compilation flags from which the `Modules` will inherit from, such as the C or C++ version, warning level, optimization level, etc. `Targets` inherit default compilation flags from predefined `Configurations` (`Debug`, `Development`, `Release`, `Test`).

`Modules` form the core components of the project structure. They encapsulate specific runtime features, libraries, or other functionalities into separate, self-contained units of code.

`Targets` and `Modules` should be stored in the `Source` directory of a `Project`. The root folder of each `Module` should match its name but it is not strict rule.

---
# **DIRECTORY STRUCTURE**

The directory structure that the build system and package manager expects.

---
## **WORKSPACE DIRECTORY STRUCTURE**

At the top level of the directory structure, you will find the base `Project` directory alongside any individual `Project` directories. The base `Project` directory contains the core system and its associated tools, while each project directory holds all files specific to that project.

```
Workspace/
├── BaseProject/
├── ProjectA/
├── ProjectB/
├── ProjectC/
├── .gitignore
├── GenerateProjectFiles.bat
├── GenerateProjectFiles.command
├── GenerateProjectFiles.sh
├── LICENSE.md
├── README.md
├── Setup.bat
├── Setup.command
└── Setup.sh
```
- `GenerateProjectFiles` - Used to generate the project files needed to work with the base and its corresponding project(s) within your preferred IDE (such as Visual Studio, Visual Studio Code, Xcode, and others).
- `Setup` - Handles essential third-party dependencies by downloading required binaries and preparing the environment so the base system can run properly.

---
## **BASE PROJECT DIRECTORY STRUCTURE**

Serves as the central foundation of the project, containing all core source code, assets, tools, and underlying systems upon which each project is built. It represents the primary framework that supports and unifies all associated projects.

```
BaseProject/
├── Binaries/${Platform}/${Compiler}/${Architecture}/
├── Build/
│   ├── BatchFiles/${Platform}/
│   ├── CMake/
│   ├── Intermediates/
│   │   ├── BuildFiles/${Platform}/${Target}-${Module}/${Compiler}/${Configuration}/${Architecture}/
│   │   ├── CMakeFiles/
│   │   └── ProjectFiles/
│   ├── Libraries/${Platform}/${Compiler}/
│   └── CMakeLists.txt
├── Documentation/
│   ├── HTML/
│   └── Source/
├── Plugins/
├── Programs/${Platform}/${Compiler}/${Architecture}/
├── Shaders/
└── Source/
```

---
## **PROJECT DIRECTORY STRUCTURE**

```
ProjectA/
├── Binaries/${Platform}/${Compiler}/${Architecture}/
├── Build/
│   ├── Intermediates/
│   │   ├── BuildFiles/${Platform}/${Target}-${Module}/${Compiler}/${Configuration}/${Architecture}/
│   │   └── ProjectFiles/
│   └── Libraries/${Platform}/${Compiler}/
├── Configuration/
├── Content/
├── Documentation/
│   └── Source/
├── Plugins/
├── Programs/${Platform}/${Compiler}/${Architecture}/
├── Shaders/
└── Source/
```

---
## **INSTRUCTIONS**

Unless explicitly asked:
- Do not make suggestions or recommendations;
- Do not ask or predict the next step;
- Do not make quality comments about the idea or task;

After I've finished sending this entire prompt you should only:
- Ask about the current progress;
- Ask about your current task;
  
After I've sent the current progress and current task, you should just respond the necessary information regarding the task and nothing more, just wait for me to analyze and test to give you feedback.
