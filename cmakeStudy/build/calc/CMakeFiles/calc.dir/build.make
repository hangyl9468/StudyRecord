# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.27

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = E:\cmake-3.27.6-windows-x86_64\bin\cmake.exe

# The command to remove a file.
RM = E:\cmake-3.27.6-windows-x86_64\bin\cmake.exe -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\Users\hangyl\Desktop\cmakeStudy

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\Users\hangyl\Desktop\cmakeStudy\build

# Include any dependencies generated for this target.
include calc/CMakeFiles/calc.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include calc/CMakeFiles/calc.dir/compiler_depend.make

# Include the progress variables for this target.
include calc/CMakeFiles/calc.dir/progress.make

# Include the compile flags for this target's objects.
include calc/CMakeFiles/calc.dir/flags.make

calc/CMakeFiles/calc.dir/add.cpp.obj: calc/CMakeFiles/calc.dir/flags.make
calc/CMakeFiles/calc.dir/add.cpp.obj: calc/CMakeFiles/calc.dir/includes_CXX.rsp
calc/CMakeFiles/calc.dir/add.cpp.obj: C:/Users/hangyl/Desktop/cmakeStudy/calc/add.cpp
calc/CMakeFiles/calc.dir/add.cpp.obj: calc/CMakeFiles/calc.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=C:\Users\hangyl\Desktop\cmakeStudy\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object calc/CMakeFiles/calc.dir/add.cpp.obj"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT calc/CMakeFiles/calc.dir/add.cpp.obj -MF CMakeFiles\calc.dir\add.cpp.obj.d -o CMakeFiles\calc.dir\add.cpp.obj -c C:\Users\hangyl\Desktop\cmakeStudy\calc\add.cpp

calc/CMakeFiles/calc.dir/add.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/calc.dir/add.cpp.i"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\Users\hangyl\Desktop\cmakeStudy\calc\add.cpp > CMakeFiles\calc.dir\add.cpp.i

calc/CMakeFiles/calc.dir/add.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/calc.dir/add.cpp.s"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\Users\hangyl\Desktop\cmakeStudy\calc\add.cpp -o CMakeFiles\calc.dir\add.cpp.s

calc/CMakeFiles/calc.dir/div.cpp.obj: calc/CMakeFiles/calc.dir/flags.make
calc/CMakeFiles/calc.dir/div.cpp.obj: calc/CMakeFiles/calc.dir/includes_CXX.rsp
calc/CMakeFiles/calc.dir/div.cpp.obj: C:/Users/hangyl/Desktop/cmakeStudy/calc/div.cpp
calc/CMakeFiles/calc.dir/div.cpp.obj: calc/CMakeFiles/calc.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=C:\Users\hangyl\Desktop\cmakeStudy\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object calc/CMakeFiles/calc.dir/div.cpp.obj"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT calc/CMakeFiles/calc.dir/div.cpp.obj -MF CMakeFiles\calc.dir\div.cpp.obj.d -o CMakeFiles\calc.dir\div.cpp.obj -c C:\Users\hangyl\Desktop\cmakeStudy\calc\div.cpp

calc/CMakeFiles/calc.dir/div.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/calc.dir/div.cpp.i"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\Users\hangyl\Desktop\cmakeStudy\calc\div.cpp > CMakeFiles\calc.dir\div.cpp.i

calc/CMakeFiles/calc.dir/div.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/calc.dir/div.cpp.s"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\Users\hangyl\Desktop\cmakeStudy\calc\div.cpp -o CMakeFiles\calc.dir\div.cpp.s

calc/CMakeFiles/calc.dir/mul.cpp.obj: calc/CMakeFiles/calc.dir/flags.make
calc/CMakeFiles/calc.dir/mul.cpp.obj: calc/CMakeFiles/calc.dir/includes_CXX.rsp
calc/CMakeFiles/calc.dir/mul.cpp.obj: C:/Users/hangyl/Desktop/cmakeStudy/calc/mul.cpp
calc/CMakeFiles/calc.dir/mul.cpp.obj: calc/CMakeFiles/calc.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=C:\Users\hangyl\Desktop\cmakeStudy\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object calc/CMakeFiles/calc.dir/mul.cpp.obj"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT calc/CMakeFiles/calc.dir/mul.cpp.obj -MF CMakeFiles\calc.dir\mul.cpp.obj.d -o CMakeFiles\calc.dir\mul.cpp.obj -c C:\Users\hangyl\Desktop\cmakeStudy\calc\mul.cpp

calc/CMakeFiles/calc.dir/mul.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/calc.dir/mul.cpp.i"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\Users\hangyl\Desktop\cmakeStudy\calc\mul.cpp > CMakeFiles\calc.dir\mul.cpp.i

calc/CMakeFiles/calc.dir/mul.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/calc.dir/mul.cpp.s"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\Users\hangyl\Desktop\cmakeStudy\calc\mul.cpp -o CMakeFiles\calc.dir\mul.cpp.s

calc/CMakeFiles/calc.dir/sub.cpp.obj: calc/CMakeFiles/calc.dir/flags.make
calc/CMakeFiles/calc.dir/sub.cpp.obj: calc/CMakeFiles/calc.dir/includes_CXX.rsp
calc/CMakeFiles/calc.dir/sub.cpp.obj: C:/Users/hangyl/Desktop/cmakeStudy/calc/sub.cpp
calc/CMakeFiles/calc.dir/sub.cpp.obj: calc/CMakeFiles/calc.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=C:\Users\hangyl\Desktop\cmakeStudy\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object calc/CMakeFiles/calc.dir/sub.cpp.obj"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT calc/CMakeFiles/calc.dir/sub.cpp.obj -MF CMakeFiles\calc.dir\sub.cpp.obj.d -o CMakeFiles\calc.dir\sub.cpp.obj -c C:\Users\hangyl\Desktop\cmakeStudy\calc\sub.cpp

calc/CMakeFiles/calc.dir/sub.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/calc.dir/sub.cpp.i"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\Users\hangyl\Desktop\cmakeStudy\calc\sub.cpp > CMakeFiles\calc.dir\sub.cpp.i

calc/CMakeFiles/calc.dir/sub.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/calc.dir/sub.cpp.s"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && E:\mingw64\bin\c++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\Users\hangyl\Desktop\cmakeStudy\calc\sub.cpp -o CMakeFiles\calc.dir\sub.cpp.s

# Object files for target calc
calc_OBJECTS = \
"CMakeFiles/calc.dir/add.cpp.obj" \
"CMakeFiles/calc.dir/div.cpp.obj" \
"CMakeFiles/calc.dir/mul.cpp.obj" \
"CMakeFiles/calc.dir/sub.cpp.obj"

# External object files for target calc
calc_EXTERNAL_OBJECTS =

C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/add.cpp.obj
C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/div.cpp.obj
C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/mul.cpp.obj
C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/sub.cpp.obj
C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/build.make
C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a: calc/CMakeFiles/calc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=C:\Users\hangyl\Desktop\cmakeStudy\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX static library C:\Users\hangyl\Desktop\cmakeStudy\lib\libcalc.a"
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && $(CMAKE_COMMAND) -P CMakeFiles\calc.dir\cmake_clean_target.cmake
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\calc.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
calc/CMakeFiles/calc.dir/build: C:/Users/hangyl/Desktop/cmakeStudy/lib/libcalc.a
.PHONY : calc/CMakeFiles/calc.dir/build

calc/CMakeFiles/calc.dir/clean:
	cd /d C:\Users\hangyl\Desktop\cmakeStudy\build\calc && $(CMAKE_COMMAND) -P CMakeFiles\calc.dir\cmake_clean.cmake
.PHONY : calc/CMakeFiles/calc.dir/clean

calc/CMakeFiles/calc.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" C:\Users\hangyl\Desktop\cmakeStudy C:\Users\hangyl\Desktop\cmakeStudy\calc C:\Users\hangyl\Desktop\cmakeStudy\build C:\Users\hangyl\Desktop\cmakeStudy\build\calc C:\Users\hangyl\Desktop\cmakeStudy\build\calc\CMakeFiles\calc.dir\DependInfo.cmake "--color=$(COLOR)"
.PHONY : calc/CMakeFiles/calc.dir/depend

