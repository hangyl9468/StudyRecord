cmake_minimum_required(VERSION 3.5.1)
project(CmakeStudy)

# 设置头文件路径
set(include_path ${PROJECT_SOURCE_DIR}/include)
# 设置库文件路径
set(lib_path ${PROJECT_SOURCE_DIR}/lib)
# 设置输出可执行文件路径
set(output_path ${PROJECT_SOURCE_DIR}/bin)
# 设置库文件名
set(lib_name calc)
# 设置生成的可执行测试文件名
set(output_name test)

add_subdirectory(${PROJECT_SOURCE_DIR}/calc)
add_subdirectory(${PROJECT_SOURCE_DIR}/test)