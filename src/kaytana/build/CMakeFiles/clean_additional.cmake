# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/KaytanaLib_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/KaytanaLib_autogen.dir/ParseCache.txt"
  "CMakeFiles/Kaytana_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/Kaytana_autogen.dir/ParseCache.txt"
  "KaytanaLib_autogen"
  "Kaytana_autogen"
  )
endif()
