#include "testLoopFunction.h"
#include <stdio.h>

void testLoopFunction::PreStep()
{
	if (GetSpace().GetSimulationClock() < 500)
	{
		if (GetSpace().GetSimulationClock() % 50 == 0)
		{
		double x = rand()*1.0/RAND_MAX*1.2-0.6;
		double y = rand()*1.0/RAND_MAX*1.2-0.6;
	
		const CVector3 cv3 = CVector3(x,y,0);
		const CQuaternion cq = CQuaternion(1,0,0,0);
		MoveEntity(pcCylinder->GetEmbodiedEntity(),cv3,cq);
		//printf("test: I am prestep\n");
		}
	}
	else
	{
		if (flag == 0) RemoveEntity(*pcCylinder);
		flag = 1;
	}
}

void testLoopFunction::Init(TConfigurationNode& t_tree)
{
	flag = 0;
	printf("test: I am init\n");
	printf("getting config tree\n");
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

	/////////////////////////////////////////////////////////////////
	printf("read entity\n");
	CEntity::TVector entities;
	GetSpace().GetEntitiesMatching(entities,"obstacle");

	/*
	printf("%ld\n",entities.size());
	for (int i = 0; i < entities.size(); i++)
	{
		printf("%s\n",entities[i]->GetId().c_str());
	}
	*/

	pcCylinder = dynamic_cast<CCylinderEntity*>(entities[0]);

	/////////////////////////////////////////////////////////////////

	printf("create entity\n");
	const CVector3 cv3 = CVector3(0.4,0.4,0);
	const CVector3 size3 = CVector3(0.2,0.4,0.4);
	const CQuaternion cq = CQuaternion(1,0,0,0);
	pcBox = new CBoxEntity("testbox",
							cv3,
							cq,
							false,
							size3,
							1);

	AddEntity(*pcBox);
	
	//printf("%s\n",theObstacle->GetId().c_str());
}

REGISTER_LOOP_FUNCTIONS(testLoopFunction, "testLoopFunction");
