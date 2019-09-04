mobs_mc = {}
mobs_mc.override = {}
mobs_mc.override.items = {}
-- mobs_mc.override.items.bow = "bows:bow_wood"
mobs_mc.override.items.arrow = "bows:arrow"
mobs_mc.override.enderman_block_texture_overrides = {}
minetest.register_alias("mobs_mc:bow_wood", "bows:bow_wood")
minetest.register_alias("mobs_mc:arrow", "bows:arrow")
minetest.log("action", "[mobs_mc_gameconfig] loaded!")
