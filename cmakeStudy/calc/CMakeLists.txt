cmake_minimum_required(VERSION 3.5.1)
project(calc)

aux_source_directory(./ src)
include_directories(${include_path})
set(LIBRARY_OUTPUT_PATH ${lib_path})
add_library(${lib_name} STATIC ${src})