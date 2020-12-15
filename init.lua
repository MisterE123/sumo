sumo = {}

--note add register on hp change so players dont die
minetest.register_node("sumo:boundary", {
    description = "Sumo arena bounary",
    drawtype = "glasslike",
    tiles = {"default_obsidian_glass.png"},
    paramtype = "light",
    walkable = false,
    is_ground_content = false,
    sunlight_propagates = true,
    groups = {cracky=3,oddly_breakable_by_hand=3},
})

minetest.register_craftitem("sumo:pushstick", {
    description = "Push Stick",
    inventory_image = "default_stick.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == 'object' then
            if minetest.is_player(pointed_thing.ref) == true then
               
                local dir = user:get_look_dir()
				pointed_thing.ref:add_player_velocity(vector.multiply(dir, math.random(5,20)))
			end
		end
	
                


    end,
})



arena_lib.register_minigame("sumo", {
    prefix = "[Sumo] ",
    hub_spawn_point = { x = 0, y = 20, z = 0 },
    show_minimap = false,
    time_mode = 2,
    join_while_in_progress = false,
    keep_inventory = false,
    in_game_physics = {
        
        jump = 1,
        sneak = false,

    },

    --disabled_damage_types = {'punch'},



    player_properties = {       
          

    },
})


arena_lib.on_load("sumo", function(arena)

    local item = ItemStack("sumo:pushstick")
    
    for pl_name, stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        player:get_inventory():set_stack("main", 1, item)
    end
  
end)

arena_lib.on_time_tick('sumo', function(arena)
    return
    
end)

--if the game times out
arena_lib.on_timeout('sumo', function(arena)
    local winner_names = {}
    for p_name, p_stats in pairs(arena.players) do
        table.insert(winner_names, p_name)
    end
        

    arena_lib.load_celebration('sumo', arena, winner_names)

end)






arena_lib.on_death('sumo', function(arena, p_name, reason)
    arena_lib.remove_player_from_arena(p_name, 1)

end)





minetest.register_privilege("sumo_admin", {  
    description = "With this you can use /sumo_admin"
})
  



  ChatCmdBuilder.new("sumo", function(cmd)

    -- create arena
    cmd:sub("tutorial", function(name)
        minetest.chat_send_player(name, "See the TUTORIAL.txt file in the mod folder.")
    end)



    -- create arena
    cmd:sub("create :arena", function(name, arena_name)
        arena_lib.create_arena(name, "sumo", arena_name)
    end)



    cmd:sub("create :arena :minplayers:int :maxplayers:int", function(name, arena_name, min_players, max_players)
        arena_lib.create_arena(name, "sumo", arena_name, min_players, max_players)
    end)



    -- remove arena
    cmd:sub("remove :arena", function(name, arena_name)
        arena_lib.remove_arena(name, "sumo", arena_name)
    end)

    
    
    -- list of the arenas
    cmd:sub("list", function(name)
        arena_lib.print_arenas(name, "sumo")
    end)



    -- info on a specific arena
    cmd:sub("info :arena", function(name, arena_name)
        arena_lib.print_arena_info(name, "sumo", arena_name)
      end)



    -- this sets the spawns using the player position
    cmd:sub("setspawn :arena", function(name, arena)
        arena_lib.set_spawner(name, "sumo", arena)
      end)



    cmd:sub("setspawn :arena", function(name, arena)
        arena_lib.set_spawner(name, "sumo", arena)
    end)



    -- this sets the arena's sign
    cmd:sub("setsign :arena", function(sender, arena)
        arena_lib.set_sign(sender, nil, nil, "sumo", arena)
    end)


    
    -- enter editor mode
    cmd:sub("edit :arena", function(sender, arena)
        arena_lib.enter_editor(sender, "sumo", arena)
    end)



    -- enable and disable arenas
    cmd:sub("enable :arena", function(name, arena)
        arena_lib.enable_arena(name, "sumo", arena)
    end)



    cmd:sub("disable :arena", function(name, arena)
        arena_lib.disable_arena(name, "sumo", arena)
    end)


    -- Debug commands
    cmd:sub("play :sound :gain:number", function(p_name, sound, gain)
        minetest.sound_play(sound, { pos = minetest.get_player_by_name(p_name):get_pos(), to_player = p_name, gain = gain})
    end)
    

end, {
  description = [[
      
    (/help sumo)

    Use this to configure your arena:
    - tutorial
    - create <arena name> [min players] [max players]
    - edit <arena name> 
    - enable <arena name>
    
    Other commands:
    - list
    - info <arena name>
    - remove <arena name>
    - removechest <arena name>
    - disable <arena>
    ]],
  privs = { sumo_admin = true }
})
