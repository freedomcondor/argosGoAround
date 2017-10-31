#include <argos3/core/simulator/loop_functions.h>

using namespace argos;

class testLoopFunction : public CLoopFunctions
{
public:
	//testLoopFunction();
	//~testLoopFunction();
	void test();
	void Init(TConfigurationNode& t_tree);
	void PreStep();
};
