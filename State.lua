--[[
Explanations:

A State should have:
{
   class = "State"      
   INIT = {flag}
   EXIT = {flag}
         those are flags
   step()            <a function>
   data =            <a table>
   {
      to be filled..
   }
         step is necessary
         data is necessary default {}, (implemented in state:create)

   the other is all optional:

   id = "xxx"     <a string>  
   substates =       <a table>
   {
      statename = the state   statename is the index,    <state can be anything>
      ...
   }

   transitions =    <a table>
   {
      1.    <a table>
      {
         condition = xxx   <a function returning true of false>
         from = "statename"
         to = "statename"
      }

      2.    <a table>
      {
         condition = xxx   <a function returning true of false>
         from = "statename"
         to = "statename"
      }

      1,2,3.. are indexes, you can also add transition with string index like 
            lalala = {conditiong = xxx, from = xxx, to = xxx}

      ...
   }


   current = the state        <can be anything> 
   method = function (self)    <State:method>
}
--]]

-- To Inherite/Create a State_object  a = State.create(xxx)
-- then a should have {class, EXIT, data={}, step(), and what ever xxx defines}
--[[
xxx (options) would be like this:

options  <a table>
{
   these things are all optional:

   id = "xxx"
   substates =    <a table>
   {
      statename = the state   statename is the id, state can be anything
      ...
   }

   initial = statename   <string>  the statename  
            if there is substates, must assign an initial state
         -- since there is and INIT state now, do not need to have initial

   transitions =    <a table>
   {
      1.    <a table>
      {
         condition = xxx   <a function returning true of false>
         from = statename
         to = statename
      }

      2.    <a table>
      {
         condition = function (dt)   <a function returning true of false>
            <any variable inside should be writen as dt.i, dt.x>
         from = "statename"
         to = "statename"
      }

      to exit, a transition should have:
      {
         xxx
         to = 'EXIT'
      }

      ...
   }

   data =     <a table>
   {
      to be filled..
   }
}
--]]

-- Table State would act as a class
local State = 
{
   class = "State",
   INIT = {initflag="flagflag"}, 
   EXIT = {exitflag="flagflag"}, 
            -- this is just a flag, {exitflag="flagflag"} can be anything unique
   data = {}
}
State.__index = State            
--setmetatable(State,State)    -- don't do that, it will enter a loop when trying to find a index

function State:create(configuration)
   -- Inherite
   local instance = {}
   setmetatable(instance, self)
   self.__index = self
      --the metatable of instance would be whoever owns this create
      --so you can :  a = State:create();  b = a:create();  grandfather-father-son

   -- Asserts
   if configuration == nil then return instance end  -- return an State object with only basic thing
   --if configuration.substates ~= nil and configuration.initial == nil then
      --print("bad create option: There are substates, but initial not assigned\n") return nil end
         -- since there is and INIT state now, do not need to have initial

    -- check condition
      -- to be filled, 
      -- condition is optional
      -- but if you like you can also check the structure of conditions, 
      -- there may be no {from INIT to xxx} or {from xxx to EXIT} transition,but it's ok for robots

   -- add configuration into state object
   instance.id = configuration.id
   instance.substates = configuration.substates
   instance.transitions = configuration.transitions
   instance.method = configuration.method
      -- those may need to be changed to table.copy,
      -- because if do something like
      -- configuration = {xxxx}
      --  a.create(configuration)
      --  b.create(configuration)
      -- then a and b may share the same memery
   --instance.data = configuration.data or {}
      -- this is fine if do not inherite data from fathers, 
      -- otherwise may need to do something like this:
      -- but also care about the memery sharing problem
         ---[[
         instance.data={}
         for index,value in pairs(self.data) do
            instance.data[index] = value
         end
            -- equals to table.copy
         if configuration.data ~= nil then
            for index,_ in pairs(configuration.data) do
               instance.data[index] = configuration.data[index]
            end
         end
         --]]

   if configuration.substates ~= nil then
      --instance.current = instance.substates[configuration.initial]
      instance.substates.EXIT = State.EXIT  -- add an exit substate
      instance.substates.INIT = State.INIT  -- add an exit substate
      instance.current = instance.substates.INIT
   else
      instance.current = nil
   end

   return instance
end

function State:step()
   --[[
      explanations:
         three conditions may happen:
         1. the owner of this step is a state with everything (substates..): 
            run it as a normal state, go through all the substates
               for each substates, 2 conditions:
                  1. this substates is a state 
                     if it has a method, run method
                     then run step
                  2. this substates is not a state (a string maybe, do not have a method)
                     if it has method(although it is not a state), run method

         2. It is a state with nothing (no substates, no currents...)
            do nothing (presume its method has run outside before the step)
         3. It is not a state, a string maybe
            do nothing (in fact this condition may not even happen)
   --]]

   --[[
   if self.method ~= nil then    
      self:method(self.data)
   end   
   --]]
      -- have to run method outside step if method need to change transtions, because
      -- self need to be a parameter in method

   --If no substates, do nothing
   if self.substates == nil then
      return -1
   end

   --Go though all substates, for each run method() and step() 
      -- run method(self) if this method changes transtions
   while self.current ~= self.EXIT do
      --if self.current.method ~= nil then self.current:method(self) end
      if type(self.current.method) == 'function' then self.current:method(self) end

      --print("current",self.current)     -- for debug

      if self.current.class == "State" and
         self.current.step ~= nil and 
         type(self.current.step) == "function" then
            self.current:step()
      end

      --check all the condition
      for _, focal_tran in pairs(self.transitions) do 
         -- focal_tran would be a transition table
         if    (type(focal_tran.condition) == 'function' and focal_tran.condition(self.data) or
            type(focal_tran.condition) ~= 'function' and focal_tran.condition   ) and
            self.substates[focal_tran.from] == self.current then
               --print("from:",self.substates[focal_tran.from])   --for debug
               --print("to",self.substates[focal_tran.to])        --for debug
               self.current = self.substates[focal_tran.to]
               break
         end
      end
   end

   return 0
end

function State:stepSingle()
   --[[
      explanations:
         three conditions may happen:
         1. the owner of this step is a state with everything (substates..): 
            run it as a normal state, check the current substates
               for each current substate, 2 conditions:
                  1. this substate is a state 
                        run stepSingle
                        if the substate exited, check transition
                        if not stay
                  2. this substates is not a state (a string maybe, do not have a method)
                        check transiton

         2. It is a state with nothing (no substates, no currents...)
               do nothing (presume its method has run outside before the step)
         3. It is not a state, a string maybe
               do nothing (in fact this condition may not even happen)
   --]]

   --[[
   if self.method ~= nil then    
      self:method(self.data)
   end   
   --]]
      -- have to run method outside step if method need to change transtions, because
      -- self need to be a parameter in method

   --If no substates, do nothing
   if self.substates == nil then
      return -1
   end

   --check current substate, see if it is has substates
   if self.current == self.EXIT then return -1 end

   flag = -1
   if self.current.class == "State" and
      self.current.stepSingle ~= nil and 
      type(self.current.stepSingle) == "function" then
         flag = self.current:stepSingle()
   end

   if flag ~= 0 then
      local flag = 0
      for _, focal_tran in pairs(self.transitions) do 
         -- focal_tran would be a transition table
         if    (type(focal_tran.condition) == 'function' and focal_tran.condition(self.data) or
            type(focal_tran.condition) ~= 'function' and focal_tran.condition   ) and
            self.substates[focal_tran.from] == self.current then
               --print("from:",self.substates[focal_tran.from])   --for debug
               --print("to",self.substates[focal_tran.to])        --for debug
               self.current = self.substates[focal_tran.to]
               flag = 1
               break
         end
      end

      --if flag == 1 and type(self.current.method) == 'function' then self.current:method(self) end
      if type(self.current.method) == 'function' then self.current:method(self) end
      if self.current == self.EXIT then return -1 end
   end

   return 0
end

return State

