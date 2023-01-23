local can_node_box = {
	type = 'fixed',
	fixed = {
		-- main box
		{-0.25, -0.4375, -0.25, 0.25, 0.4375, 0.25},
		-- next box in
		{-0.21875, -0.46875, -0.21875, 0.21875, 0.5, 0.21875},
		-- base
		{-0.1875, -0.5, -0.1875, 0.1875, -0.46875, 0.1875},
	},
}

local tall_can_node_box = {
	type = 'fixed',
	fixed = {
		-- main box
		{-0.25, -0.4375, -0.25, 0.25, 0.9375, 0.25},
		-- next box in
		{-0.21875, -0.46875, -0.21875, 0.21875, 1, 0.21875},
		-- base
		{-0.1875, -0.5, -0.1875, 0.1875, -0.46875, 0.1875},
	},
}

local carton_node_box = {
	type = 'fixed',
	fixed = {
		-- main box
		{-0.5, -0.5, -0.5, 0.5, 0.3375, 0.5},
	},
}

minetest.register_node('beverage:pepsi_max_carton', {
		description = 'Pepsi Max Carton' ,
		drawtype = 'nodebox',
		node_box = carton_node_box,
		tiles = {
			'pepsi_max_top_carton.png', 'pepsi_max_bottom_carton.png', -- Y
			'pepsi_max_front_carton.png', 'pepsi_max_back_carton.png', -- X
			'pepsi_max_rside_carton.png', 'pepsi_max_lside_carton.png', -- Z
		},

		paramtype = 'light',
		sunlight_propagates = true,
		walkable = false,
		groups = {fleshy=3,dig_immediate=3,flammable=10},
		on_use = minetest.item_eat(health_add),
	})
minetest.register_craft {
	output = 'beverage:pepsi_max_carton',
	type = 'shapeless',
	recipe = {'beverage:pepsi_max 9'}
}

minetest.register_node('beverage:can', {
	description = 'Empty can',
	drawtype = 'nodebox',
	node_box = can_node_box,
	tiles = {
		'can_top.png', 'can_bottom.png', -- Y
		'can_side.png', 'can_side.png', -- X
		'can_side.png', 'can_side.png', -- Z
	},
	inventory_image = 'can_side.png',
	paramtype = 'light',
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3},
})

minetest.register_craft {
	output = 'beverage:can 9',
	recipe = {
		{'default:tin_ingot', 'default:tin_ingot', 'default:tin_ingot'},
		{'default:tin_ingot', '', 'default:tin_ingot'},
		{'default:tin_ingot', 'default:tin_ingot', 'default:tin_ingot'},
	}
}

minetest.register_craft {
	output = 'beverage:can',
	type = 'shapeless',
	recipe = {'beverage:can_tall'}
}

minetest.register_node('beverage:can_tall', {
	description = 'Empty tall can',
	drawtype = 'nodebox',
	node_box = tall_can_node_box,
	tiles = {
		'can_top.png', 'can_bottom.png', -- Y
		'can_tall_side.png', 'can_tall_side.png', -- X
		'can_tall_side.png', 'can_tall_side.png', -- Z
	},
	inventory_image = 'can_tall_side.png',
	paramtype = 'light',
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3},
})

minetest.register_craft {
	output = 'beverage:can_tall',
	type = 'shapeless',
	recipe = {'beverage:can'}
}

local function register_beverage(name, name_cap, health_add, ingredients, is_tall)
	local node_box = is_tall and tall_can_node_box or can_node_box
	local can = is_tall and 'beverage:can_tall' or 'beverage:can'

	minetest.register_node('beverage:' .. name, {
		description = name_cap,
		drawtype = 'nodebox',
		node_box = node_box,
		tiles = {
			name .. '_top.png', name .. '_bottom.png', -- Y
			name .. '_front.png', name .. '_back.png', -- X
			name .. '_rside.png', name .. '_lside.png', -- Z
		},
		inventory_image = name .. '.png',
		paramtype = 'light',
		sunlight_propagates = true,
		walkable = false,
		groups = {fleshy=3,dig_immediate=3,flammable=10},
		on_use = minetest.item_eat(health_add),
	})

	minetest.register_craft {
		output = 'beverage:' .. name .. ' 9',
		recipe = {
			{'default:tin_ingot', 'default:tin_ingot', 'default:tin_ingot'},
			{'default:tin_ingot', 'beverage:' .. name .. '_liquid', 'default:tin_ingot'},
			{'default:tin_ingot', 'default:tin_ingot', 'default:tin_ingot'},
		}
	}

	minetest.register_craft {
		output = 'beverage:' .. name .. ' 9',
		type = 'shapeless',
		recipe = {
			'beverage:' .. name .. '_liquid',
			can .. ' 9',
		}
	}

	minetest.register_node('beverage:' .. name .. '_liquid', {
		description = name_cap .. ' liquid',
		drawtype = 'liquid',
		tiles = {
			{
				name = name .. '_liquid.png',
				backface_culling = false,
				animation = {
					type = 'vertical_frames',
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
			{
				name = name .. '_liquid.png',
				backface_culling = true,
				animation = {
					type = 'vertical_frames',
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		use_texture_alpha = 'blend',
		paramtype = 'light',
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = '',
		drowning = 1,
		liquidtype = 'source',
		liquid_alternative_flowing = 'beverage:' .. name .. '_liquidflo',
		liquid_alternative_source = 'beverage:' .. name .. '_liquid',
		liquid_viscosity = 0.00000000001,
		liquid_renewable = false,
		liquid_range = 2,
		post_effect_color = {a = 640, r = 600, g = 500, b = 450},
		groups = {water = 3, liquid = 3, cools_lava = 1},
		sounds = default.node_sound_water_defaults(),
	})

	minetest.register_node('beverage:' .. name .. '_liquidflo', {
		description = name_cap .. ' liquidflo',
		drawtype = 'flowingliquid',
		waving = 3,
		tiles = {name .. '_liquid.png'},
		special_tiles = {
			{
				name = name .. '_liquid.png',
				backface_culling = false,
				animation = {
					type = 'vertical_frames',
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
			{
				name = name .. '_liquid.png',
				backface_culling = true,
				animation = {
					type = 'vertical_frames',
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
		},
		use_texture_alpha = 'blend',
		paramtype = 'light',
		paramtype2 = 'flowingliquid',
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = '',
		drowning = 1,
		liquidtype = 'flowing',
		liquid_alternative_flowing = 'beverage:' .. name .. '_liquidflo',
		liquid_alternative_source = 'beverage:' .. name .. '_liquid',
		liquid_viscosity = 0.00000000001,
		post_effect_color = {a = 64, r = 60, g = 50, b = 45},
		groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
			cools_lava = 1},
		sounds = default.node_sound_water_defaults(),
	})

	minetest.register_craft {
		output = 'beverage:' .. name .. '_liquid 1',
		type = 'shapeless',
		recipe = ingredients,
	}
end

register_beverage('pepsi', 'Pepsi', 11, {'beverage:pepsi_max_liquid', 'default:papyrus'})
register_beverage('pepsi_max', 'Pepsi Max', 10, {'bucket:water_bucket', 'default:apple', 'default:mese_crystal'})
register_beverage('coke', 'Coca-Cola', 11, {'beverage:coke_no_sugar_liquid', 'default:papyrus'})
register_beverage('coke_no_sugar', 'Coca-Cola No Sugar', 10, {'bucket:water_bucket', 'default:pine_needles', 'default:mese_crystal'})
register_beverage('arizona_fruit_punch', 'Arizona Fruit Punch', 6, {'bucket:water_bucket', 'default:apple', 'default:papyrus'}, true)
