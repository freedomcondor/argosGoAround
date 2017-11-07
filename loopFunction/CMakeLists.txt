cmake_minimum_required(VERSION 2.8)
project( testLoopFunction )

#lua is needed by one of .h files of argos
find_package( Lua REQUIRED )
#${LUA_INCLUDE_DIR}
#${LUA_LIBRARIES}

#####  argos  ###########

# Find the ARGoS package, make sure to save the ARGoS prefix
find_package(PkgConfig)
pkg_check_modules(ARGOS REQUIRED argos3_simulator)
set(ARGOS_PREFIX ${ARGOS_PREFIX} CACHE INTERNAL "")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ARGOS_PREFIX}/share/argos3/cmake)

include_directories(    
#	${OpenCV_INCLUDE_DIRS} 
#	${AprilTag_INCLUDE_DIR} 
	${LUA_INCLUDE_DIR}
#	${OPENGL_INCLUDE_DIRS}
#	${GLUT_INCLUDE_DIRS}
)

link_directories(${ARGOS_LIBRARY_DIRS})


add_library(testLoopFunction MODULE
		   		testLoopFunction.cpp
		      	testLoopFunction.h)

target_link_libraries( testLoopFunction
#${OpenCV_LIBS} 
#${AprilTag_LIB} 
${LUA_LIBRARIES}
#${OPENGL_LIBRARIES}
#${GLUT_LIBRARIES}

argos3core_simulator
argos3plugin_simulator_entities

)

