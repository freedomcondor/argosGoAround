cmake_minimum_required(VERSION 2.8)
project( testLoopFunction )

#lua is needed by one of .h files of argos
find_package( Lua REQUIRED )
#${LUA_INCLUDE_DIR}
#${LUA_LIBRARIES}

include_directories(    
#	${OpenCV_INCLUDE_DIRS} 
#	${AprilTag_INCLUDE_DIR} 
	${LUA_INCLUDE_DIR}
#	${OPENGL_INCLUDE_DIRS}
#	${GLUT_INCLUDE_DIRS}
)

add_library(testLoopFunction MODULE
		   		testLoopFunction.cpp
		      	testLoopFunction.h)

target_link_libraries( testLoopFunction
#${OpenCV_LIBS} 
#${AprilTag_LIB} 
${LUA_LIBRARIES}
#${OPENGL_LIBRARIES}
#${GLUT_LIBRARIES}
)

