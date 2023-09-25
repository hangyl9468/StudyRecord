cmake_minimum_required(VERSION 3.5.1)
project(test)

aux_source_directory(./ src)
include_directories(${include_path})
link_directories(${lib_path})
link_libraries(${lib_name})
set(EXECUTABLE_OUTPUT_PATH ${output_path})
add_executable(${output_name} ${src})