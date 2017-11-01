#include <argos3/core/simulator/loop_functions.h>
#include <argos3/plugins/simulator/entities/cylinder_entity.h>

using namespace argos;

class testLoopFunction : public CLoopFunctions
{
public:
	//testLoopFunction();
	//~testLoopFunction();
	void test();
	void Init(TConfigurationNode& t_tree);
	void PreStep();
private:
	int flag;
	CCylinderEntity* pcCylinder;
};
