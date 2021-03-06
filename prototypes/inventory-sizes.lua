local function divide_inventory_size(prototype, amount)
  if prototype.inventory_size > 2 then
    prototype.inventory_size = math.max(prototype.inventory_size / amount, 2)
  end
end

for _, prototype in pairs(data.raw["cargo-wagon"]) do
  divide_inventory_size(prototype, 10)
end

for _, prototype in pairs(data.raw["car"]) do
  divide_inventory_size(prototype, 5)
end

for _, prototype in pairs(data.raw["spider-vehicle"]) do
  divide_inventory_size(prototype, 5)
end

for _, prototype in pairs(data.raw["container"]) do
  -- wood/iron/steel default is 16/32/48
  -- change to 12/18/24
  if prototype.name == "wooden-chest" and prototype.inventory_size == 16 then
    prototype.inventory_size = 12
  elseif prototype.name == "iron-chest" and prototype.inventory_size == 32 then
    prototype.inventory_size = 18
  else
    divide_inventory_size(prototype, 2)
  end
end

for _, prototype in pairs(data.raw["logistic-container"]) do
  divide_inventory_size(prototype, 2)
end


local burner_types = {
  "boiler",
  "burner-generator",
  "car",
  "assembling-machine",
  "furnace",
  "rocket-silo",
  "generator-equipment",
  "inserter",
  "lab",
  "locomotive",
  "mining-drill",
  "pump",
  "radar",
  --"reactor",
  "roboport-equipment",
  "spider-vehicle",
}

local function min(a, b)
  if a < b then return a
  else return b
  end
end

-- Increase burner fuel inventory sizes to compensate
local function increase_fuel_inventory_size(energy_source)
  if energy_source and energy_source.fuel_inventory_size then
    energy_source.fuel_inventory_size = min(energy_source.fuel_inventory_size * 3, 12)
  end
end

for _, type in pairs(burner_types) do
  for _, prototype in pairs(data.raw[type]) do
    increase_fuel_inventory_size(prototype.burner)
    increase_fuel_inventory_size(prototype.energy_source)
  end
end

-- Increase player inventory size to compensate
for _, character in pairs(data.raw.character) do
  character.inventory_size = character.inventory_size * 1.5
end