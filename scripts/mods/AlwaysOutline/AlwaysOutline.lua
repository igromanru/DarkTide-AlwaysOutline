local mod = get_mod("AlwaysOutline")

local OutlineSettings = require("scripts/settings/outline/outline_settings")
local ModUtils = mod:io_dofile("AlwaysOutline/scripts/mods/AlwaysOutline/ModUtils/ModUtils") ---@type ModUtils

local ALL_ENEMY = "all_enemy"
local SPECIALIST_ENEMY = "specialist_enemy"
local ELITE_ENEMY = "elite_enemy"
local MONSTER_ENEMY = "monster_enemy"

local ENABLE_MOD_SETTING = "enable_mod"
local ALL_ENEMY_ENABLED_SETTING = ALL_ENEMY .. "_enabled"
local SPECIALIST_ENEMY_SETTING = SPECIALIST_ENEMY .. "_enabled"
local ELITE_ENEMY_SETTING = ELITE_ENEMY .. "_enabled"
local MONSTER_ENEMY_ENABLED_SETTING = MONSTER_ENEMY .. "_enabled"

local OUTLINE_MATERIAL_LAYERS = {
	"minion_outline",
	-- "minion_outline_reversed_depth",
}

local function round(num, decimal_places)
    local mult = 10^(decimal_places or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function visibility_check(unit)
	if not unit or not HEALTH_ALIVE[unit] then
		return false
	end
	return true
end

mod.get_color_array = function(self, name)
	local r = round(tonumber(self:get(name.."_r")) / 255, 3)
	local g = round(tonumber(self:get(name.."_g")) / 255, 3)
	local b = round(tonumber(self:get(name.."_b")) / 255, 3)

	return {r,g,b}
end

mod.update_outline_settings = function(self, instance)
	if not instance then return end

	instance.MinionOutlineExtension[ALL_ENEMY] = {
		priority = self:get(ALL_ENEMY .. "_priority"),
		color = self:get_color_array(ALL_ENEMY),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension[SPECIALIST_ENEMY] = {
		priority = self:get(SPECIALIST_ENEMY .. "_priority"),
		color = self:get_color_array(SPECIALIST_ENEMY),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension[ELITE_ENEMY] = {
		priority = self:get(ELITE_ENEMY .. "_priority"),
		color = self:get_color_array(ELITE_ENEMY),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension[MONSTER_ENEMY] = {
		priority = self:get(MONSTER_ENEMY .. "_priority"),
		color = self:get_color_array(MONSTER_ENEMY),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		visibility_check = visibility_check
	}
end

mod.on_setting_changed = function(setting_id)
	mod:update_outline_settings(OutlineSettings)
end

mod:hook_require("scripts/settings/outline/outline_settings", function(instance)
	mod:update_outline_settings(instance)
end)

local function get_breed_tags(enemy_unit_data_extension)
	if enemy_unit_data_extension then
		local breed = enemy_unit_data_extension:breed()
		return breed and breed.tags
	end
	return nil
end

local function set_outline_color(unit, outline_unit_data_extension)
	if not unit or not outline_unit_data_extension then return end

	local top_outline = outline_unit_data_extension.outlines[1]
	if top_outline then
		local color = outline_unit_data_extension.settings[top_outline.name].color
		if color then
			Unit.set_vector3_for_materials(unit, "outline_color", Vector3(color[1], color[2], color[3]), true)
		end
	end
end

function mod.tick(self)
	local outline_system = ModUtils.get_outline_system()
	if outline_system then
		local enemy_units = ModUtils.get_enemy_units()
		if not enemy_units then return end
		
		-- local enemy_units_lookup = ModUtils.get_enemy_units_lookup()
		-- if not enemy_units_lookup then return end
		-- for enemy_unit, _ in pairs(enemy_units_lookup) do
		for _, enemy_unit in ipairs(enemy_units) do
			local outline_unit_data_extension = outline_system._unit_extension_data[enemy_unit]
			if outline_unit_data_extension and outline_unit_data_extension.outlines then
				local outlines_count = #outline_unit_data_extension.outlines
				if outlines_count > 1 then
					outline_system:remove_outline(enemy_unit, ALL_ENEMY)
					outline_system:remove_outline(enemy_unit, MONSTER_ENEMY)
					outline_system:remove_outline(enemy_unit, SPECIALIST_ENEMY)
					outline_system:remove_outline(enemy_unit, ELITE_ENEMY)
				elseif outlines_count < 1 then
					local enemy_unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
					local breed_tags = get_breed_tags(enemy_unit_data_extension)
					if breed_tags then
						if self:get(ELITE_ENEMY_SETTING) and (breed_tags.elite or breed_tags.captain) then
							outline_system:add_outline(enemy_unit, ELITE_ENEMY)
							set_outline_color(enemy_unit, outline_unit_data_extension)
						elseif self:get(SPECIALIST_ENEMY_SETTING) and breed_tags.special then
							outline_system:add_outline(enemy_unit, SPECIALIST_ENEMY)
							set_outline_color(enemy_unit, outline_unit_data_extension)
						elseif self:get(MONSTER_ENEMY_ENABLED_SETTING) and breed_tags.monster then
							outline_system:add_outline(enemy_unit, MONSTER_ENEMY)
							set_outline_color(enemy_unit, outline_unit_data_extension)
						elseif self:get(ALL_ENEMY_ENABLED_SETTING) then
							outline_system:add_outline(enemy_unit, ALL_ENEMY)
							set_outline_color(enemy_unit, outline_unit_data_extension)
						end
					end
				end
			end
		end
	end
end

local cooldown = 0.0
function mod.update(dt)
    if cooldown > 0 then
		cooldown = cooldown - dt
	else
		cooldown = 0.3 -- 300ms
		if mod:get(ENABLE_MOD_SETTING) then
			mod:tick()
		end
	end
end