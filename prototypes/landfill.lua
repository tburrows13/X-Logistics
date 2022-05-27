--[[
Vanilla collision masks:
  water-shallow =
  {
    -- Character collides only with player-layer and train-layer,
    -- this can have any tile collision masks it doesn't matter for being walkable by character but not buildable.
    -- Having water-tile prevents placing paths, ground-tile prevents placing landfill.
    -- Not sure what other side effects could different combinations of tile masks cause.
    "water-tile",
    --"ground-tile",
    "item-layer",
    "resource-layer",
    "object-layer"
    --"doodad-layer"
  },

  water =
  {
    "water-tile",
    "resource-layer",
    "item-layer",
    "player-layer",
    "doodad-layer"
  },

  landfill = {"ground-tile"},

  landfill item.place_as_tile.condition =  { "ground-tile" }

]]

local collision_mask_util = require "__core__.lualib.collision-mask-util"

-- get_first_unused_layer() doesn't check tiles so cargo ships will be given the same mask,
-- which results in resources colliding with ground tiles
--local shallow_water_mask = collision_mask_util.get_first_unused_layer()
local shallow_water_mask = "layer-48"

local landfill_item = data.raw.item["landfill"]
landfill_item.place_as_tile.condition_size = 1
landfill_item.place_as_tile.condition = { shallow_water_mask }

for _, tile in pairs(data.raw.tile) do
  if tile.name ~= "water-shallow" and tile.name ~= "water-mud" then
    table.insert(tile.collision_mask, shallow_water_mask)
  end
end

data.raw["transport-belt"]["transport-belt"].collision_mask = { shallow_water_mask }

--local water_mask = collision_mask_util.get_first_unused_layer()
local water_mask = "layer-49"

data.raw["transport-belt"]["transport-belt"].collision_mask = nil

local deep_landfill_item = table.deepcopy(landfill_item)
deep_landfill_item.name = "x-deep-landfill"
deep_landfill_item.order = "c[landfill]-b[deep]"
deep_landfill_item.place_as_tile.condition = { water_mask }

local deep_landfill_recipe = table.deepcopy(data.raw.recipe["landfill"])
deep_landfill_recipe.name = "x-deep-landfill"
deep_landfill_recipe.energy_required = 10
deep_landfill_recipe.ingredients = {{ "stone", 400 }}
deep_landfill_recipe.result = "x-deep-landfill"
deep_landfill_recipe.enabled = true

for _, tile in pairs(data.raw.tile) do
  if tile.name ~= "water" and tile.name ~= "deepwater" and tile.name ~= "water-green" and tile.name ~= "deepwater-green" then
    table.insert(tile.collision_mask, water_mask)
  end
end

data:extend{deep_landfill_item, deep_landfill_recipe}

table.insert(data.raw.technology["landfill"].effects,
  {
    type = "unlock-recipe",
    recipe = "x-deep-landfill"
  }
)

data.raw.item["waterfill-item"].order = "c[landfill]-c[waterfill]"