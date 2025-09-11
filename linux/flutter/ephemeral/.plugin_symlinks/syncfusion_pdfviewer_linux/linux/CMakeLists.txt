cmake_minimum_required(VERSION 3.10)
project(syncfusion_pdfviewer_linux LANGUAGES CXX)

# Determine the CPU architecture
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
  set(PDFIUM_ARCH "arm64")
else()
  set(PDFIUM_ARCH "x64")
endif()

find_path(PDFium_INCLUDE_DIR
  NAMES "fpdfview.h"
  PATHS "${CMAKE_CURRENT_LIST_DIR}/include/pdfium"
)

find_file(PDFium_LIBRARY
  NAMES "libpdfium.so"
  PATHS "${CMAKE_CURRENT_LIST_DIR}/include/pdfium/${PDFIUM_ARCH}/bin"
)

find_package_handle_standard_args(PDFium REQUIRED_VARS PDFium_LIBRARY PDFium_INCLUDE_DIR)

add_library(pdfium SHARED IMPORTED)
set_target_properties(pdfium PROPERTIES
  IMPORTED_LOCATION "${PDFium_LIBRARY}"
  INTERFACE_INCLUDE_DIRECTORIES "${PDFium_INCLUDE_DIR}"
)

set(PLUGIN_NAME "syncfusion_pdfviewer_linux_plugin")

add_library(${PLUGIN_NAME} SHARED
  pdfviewer.cpp
  pdfviewer.h
  syncfusion_pdfviewer_linux_plugin.cc
)

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden
)

target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter pdfium PkgConfig::GTK)

set(syncfusion_pdfviewer_linux_bundled_libraries "${PDFium_LIBRARY}" PARENT_SCOPE)