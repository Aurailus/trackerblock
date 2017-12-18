local time = 0
minetest.register_globalstep(function(delta)
   time = time + delta
   if time > 0.1 then
      time = 0
      for _,player in ipairs(minetest.get_connected_players()) do
         local north = vector.add(player:getpos(), vector.new(1, -3, 0))
         local south = vector.add(player:getpos(), vector.new(-1, -3, 0))
         local east  = vector.add(player:getpos(), vector.new(0, -3, 1))
         local west  = vector.add(player:getpos(), vector.new(0, -3, -1))
         local under = vector.add(player:getpos(), vector.new(0, -3, 0))

         if minetest.get_node(under).name == "air" then
            if minetest.get_node(north).name == "trackerblock:trackerblock" then
               minetest.set_node(north, {name = "air"})
               minetest.set_node(under, {name = "trackerblock:trackerblock"})
            elseif minetest.get_node(south).name == "trackerblock:trackerblock" then
               minetest.set_node(south, {name = "air"})
               minetest.set_node(under, {name = "trackerblock:trackerblock"})
            elseif minetest.get_node(west).name == "trackerblock:trackerblock" then
               minetest.set_node(west, {name = "air"})
               minetest.set_node(under, {name = "trackerblock:trackerblock"})
            elseif minetest.get_node(east).name == "trackerblock:trackerblock" then
               minetest.set_node(east, {name = "air"})
               minetest.set_node(under, {name = "trackerblock:trackerblock"})
            end
         end
      end
   end
end)

minetest.register_node("trackerblock:trackerblock", {
   drawtype = "normal",
   tiles = {"trackerblock_trackerblock.png"},
   groups = {cracky = 3, stone = 1},
   description = "Tracker Block",
   light_source = 5
})

mesecon.register_node("trackerblock:checker", {
   drawtype = "normal",
   tiles = {"trackerblock_blockchecker_top.png",
            "trackerblock_blockchecker_bottom.png",
            "trackerblock_blockchecker_side.png",
            "trackerblock_blockchecker_side.png",
            "trackerblock_blockchecker_side.png",
            "trackerblock_blockchecker_side.png"},
   groups = {cracky = 3, stone = 3},
   description = "Block Checker",
   on_construct = function (pos)
      minetest.get_node_timer(pos):start(0.2)
   end
}, {
   on_timer = function (pos, elapsed)
      if minetest.get_node(vector.new(pos.x, pos.y + 1, pos.z)).name == "trackerblock:trackerblock" then
         mesecon.receptor_on(pos)
         minetest.set_node(pos, {name = "trackerblock:checker_on"})
      end
      return true
   end,
   mesecons = {receptor = {
      state = mesecon.state.off
   }}
}, {
   on_timer = function (pos, elapsed)
      if minetest.get_node(vector.new(pos.x, pos.y + 1, pos.z)).name ~= "trackerblock:trackerblock" then
         mesecon.receptor_off(pos)
         minetest.set_node(pos, {name = "trackerblock:checker_off"})
      end
      return true
   end,
   mesecons = {receptor = {
      state = mesecon.state.on
   }}
})

minetest.register_craft({
   output = "trackerblock:checker_off",
   recipe = {
      {"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"},
      {"default:stone", "default:stone", "default:stone"},
      {"default:stone", "default:stone", "default:stone"}
   }
})

minetest.register_craft({
   output = "trackerblock:trackerblock",
   recipe = {
      {"default:stone", "mesecons:wire_00000000_off", "default:stone"},
      {"mesecons:wire_00000000_off", "default:mese_crystal", "mesecons:wire_00000000_off"},
      {"default:stone", "mesecons:wire_00000000_off", "default:stone"}
   }
})