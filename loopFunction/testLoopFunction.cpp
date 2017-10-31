#include "testLoopFunction.h"
#include <stdio.h>

void testLoopFunction::PreStep()
{
	//printf("test: I am prestep\n");
}

void testLoopFunction::Init(TConfigurationNode& t_tree)
{
	printf("test: I am init\n");
	TConfigurationNodeIterator itEntity("entity");
	for(itEntity = itEntity.begin(&t_tree);
			itEntity != itEntity.end();
			++itEntity) 
	{
		std::string strBaseId;
		GetNodeAttribute(*itEntity, "id", strBaseId);
		//m_mapEntityDefinitions.emplace(strBaseId, *itEntity);
		printf("%s\n",strBaseId.c_str());
	}
}


REGISTER_LOOP_FUNCTIONS(testLoopFunction, "testLoopFunction");
