function init()
   reset()
end

function step()
   robot.leds.set_single_color(counter+1, "red")
   counter = (counter + 1) % 13

   a = robot.proximity
   if a[1].value ~= 0 or a[24].value~=0 or 
      a[2].value ~= 0 or a[23].value~=0 then
	   robot.wheels.set_velocity(-5,5)
   else
	   robot.wheels.set_velocity(5,5)
   end

   --[[
   if a[3].value ~= 0 or a[5].value~=0 or 
      a[4].value ~= 0 or a[6].value~=0 then
	   robot.wheels.set_velocity(-5,5)
   else
	   robot.wheels.set_velocity(5.1,5)
   end
   --]]
   
   robot.leds.set_single_color(counter+1, "green")
end

function reset()
   counter = 0
   robot.leds.set_all_colors("red")
	-- robot.colored_blob_omnidirectional_camera.enable()
	robot.wheels.set_velocity(5,5)
end

function destroy()
end
