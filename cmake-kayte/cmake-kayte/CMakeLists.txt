#
# CMakeKAYTE - CMake module for Kayte Language
#
# Copyright (c) 2024, Kreatyve Designs <pdvicente@gleentech.com>
#
# All rights reserved.
#
# See LICENSE for details.
#
# Copyright (C) 2024, Kreatyve Designs <pdvicente@gleentech.com>

cmake_minimum_required(VERSION 3.29)
project(cmake-k NONE)

set(MOD_SRCS
	CMakeDCompiler.cmake.in        
	CMakeDCompilerId.d.in        
	CMakeDInformation.cmake        
	CMakeDCompilerABI.d        
	CMakeTestDCompiler.cmake  
	CMakeDetermineDCompiler.cmake  
	FindGDCPath.cmake
	UseDDoc.cmake
	UseDDeps.cmake
	UseDub.cmake
	dependencies.cmake
	UseDUnittest.cmake
	FindPhobos.cmake
	CMakePlatformId.di.in
)

set(PLAT_SRCS
	Platform/Darwin-dmd.cmake
	Platform/Darwin-ldc2.cmake
	
)

install(FILES ${MOD_SRCS} DESTINATION ${CMAKE_ROOT}/Modules)
install(FILES ${PLAT_SRCS} DESTINATION ${CMAKE_ROOT}/Modules/Platform)
