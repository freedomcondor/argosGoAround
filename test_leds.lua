State = require("State")


statemachine = State:create
{
   id = "root_machine",
   substates = 
   {
      goStraight = State:create
         {method = function() print("goStraight"); robot.wheels.set_velocity(5,5);return 0;end},
      turnLeft = State:create
         {method = function() print("turnLeft"); robot.wheels.set_velocity(-5,5);return 0; end},
      turnRight = State:create
         {method = function() print("turnRight");robot.wheels.set_velocity(5,-5);return 0;end},
      goAlongWall = State:create
         {
            id = "goAlongWall",
            substates = 
            {
               forward = State:create
               { method = function() print("subgo");robot.wheels.set_velocity(5,5) end },
               forwardLeft = State:create
               { method = function() print("subleft");robot.wheels.set_velocity(-5,5) end },
               forwardRight = State:create
               { method = function() print("subright");robot.wheels.set_velocity(5,-5) end },
            },
            transitions =
            {
               {condition = function () return true end, from = "INIT", to = "forward"},
               {condition =   function () 
                                 a = robot.proximity
                                 if  a[19].value ~= 0 and 
                                     a[20].value ~= 0 and
                                     a[21].value ~= 0 then
                                       return true 
                                 else
                                       return false
                                 end
                              end, 
                   from = "forward", to = "forwardLeft"},
               {condition =   function () 
                                 a = robot.proximity
                                 if  a[19].value ~= 0 and 
                                     a[21].value == 0 then
                                       return true 
                                 else
                                       return false
                                 end
                              end, 
                   from = "forwardLeft", to = "forward"},
               {condition =   function () 
                                 a = robot.proximity
                                 if  a[19].value == 0 and 
                                     a[20].value == 0 and
                                     a[21].value == 0 then
                                       return true 
                                 else
                                       return false
                                 end
                              end, 
                   from = "forward", to = "forwardRight"},
               {condition =   function () 
                                 a = robot.proximity
                                 if  a[19].value ~= 0 and 
                                     a[21].value == 0 then
                                       return true 
                                 else
                                       return false
                                 end
                              end, 
                   from = "forwardRight", to = "forward"},
               {condition =   function () 
                        a = robot.proximity
                        if a[1].value ~= 0 or a[22].value~=0 or 
                           a[2].value ~= 0 or a[23].value~=0 or
                           a[3].value ~= 0 or a[24].value~=0 then
                           return true 
                        else
                           return false
                        end
                     end, 
                 from = "forward", to = "forwardLeft"},
                 --from = "forward", to = "EXIT"},
            },
            method = function() print("subentry");robot.wheels.set_velocity(5,5) end,
         },
   },
   transitions =
   {
      {condition = function () return true end, from = "INIT", to = "goStraight"},
      {condition =   function () 
                        a = robot.proximity
                        if a[1].value ~= 0 or a[22].value~=0 or 
                           a[2].value ~= 0 or a[23].value~=0 or
                           a[3].value ~= 0 or a[24].value~=0 then
                           return true 
                        else
                           return false
                        end
                     end, 
            from = "goStraight", to = "turnLeft"},
      {condition =   function () 
                        a = robot.proximity
                        if a[1].value ~= 0 or a[22].value~=0 or 
                           a[2].value ~= 0 or a[23].value~=0 or
                           a[3].value ~= 0 or a[24].value~=0 then
                           return false
                        else
                           return true
                        end
                     end, 
            from = "turnLeft", to = "goAlongWall"},
      ---[[
      {condition =   function () 
                        a = robot.proximity
                        if a[1].value ~= 0 or a[22].value~=0 or 
                           a[2].value ~= 0 or a[23].value~=0 or
                           a[3].value ~= 0 or a[24].value~=0 then
                           return true 
                        else
                           return false
                        end
                     end, 
            from = "goAlongWall", to = "turnLeft"},
      --[[
      {condition =   function () 
                        a = robot.proximity
                        if a[16].value == 0 and a[19].value~=0 and
                           a[17].value ~= 0 and a[20].value~=0 and
                           a[18].value ~= 0 and a[21].value==0 then
                           return true 
                        else
                           return false
                        end
                     end, 
            from = "goStraight", to = "turnRight"},
      {condition =   function () 
                        a = robot.proximity
                        if a[16].value == 0 and a[19].value~=0 and
                           a[17].value ~= 0 and a[20].value~=0 and
                           a[18].value ~= 0 and a[21].value==0 then
                           return false 
                        else
                           return true
                        end
                     end, 
            from = "turnRight", to = "goStraight"},
      --]]
      --]]
   }
}

function init()
   reset()
end

function step()
   statemachine:stepSingle()
   --[[
   robot.leds.set_single_color(counter+1, "red")
   counter = (counter + 1) % 
   a = robot.proximity
   if a[1].value ~= 0 or a[24].value~=0 or 
      a[2].value ~= 0 or a[23].value~=0 then
	   robot.wheels.set_velocity(-5,5)
   else
	   robot.wheels.set_velocity(5,5)
   end

   robot.leds.set_single_color(counter+1, "green")
   --]]
end

function reset()
   counter = 0
   robot.leds.set_all_colors("red")
	-- robot.colored_blob_omnidirectional_camera.enable()
	--robot.wheels.set_velocity(5,5)
end

function destroy()
end
