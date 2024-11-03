local mod = get_mod("AlwaysOutline")

local OutlineSettings = require("scripts/settings/outline/outline_settings")

local ENABLE_MOD_SETTING = "enable_mod"
local ALL_ENEMY_ENABLED_SETTING = "all_enemy_enabled"
local SPECIALIST_ENEMY_SETTING = "specialist_enemy_enabled"
local ELITE_ENEMY_SETTING = "elite_enemy_enabled"
local MONSTER_ENEMY_ENABLED_SETTING = "monster_enemy_enabled"

local OUTLINE_MATERIAL_LAYERS = {
	"minion_outline",
	-- "minion_outline_reversed_depth",
}

local function round(num, decimal_places)
    local mult = 10^(decimal_places or 0)
    return math.floor(num * mult + 0.5) / mult
end

local get_color_array = function(name)
	local r = round(tonumber(mod:get(name.."_r")) / 255, 3)
	local g = round(tonumber(mod:get(name.."_g")) / 255, 3)
	local b = round(tonumber(mod:get(name.."_b")) / 255, 3)

	return {r,g,b}
end

local function visibility_check(unit)
	if not unit or not HEALTH_ALIVE[unit] then
		return false
	end
	return true
end

mod.update_outline_settings = function(self, instance)
	if not instance then return end

	instance.MinionOutlineExtension.all_enemy = {
		priority = mod:get("all_enemy_priority"),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		color = get_color_array("all_enemy"),
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension.specialist_enemy = {
		priority = mod:get("specialist_enemy_priority"),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		color = get_color_array("specialist_enemy"),
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension.elite_enemy = {
		priority = mod:get("elite_enemy_priority"),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		color = get_color_array("elite_enemy"),
		visibility_check = visibility_check
	}

	instance.MinionOutlineExtension.monster_enemy = {
		priority = mod:get("monster_enemy_priority"),
		material_layers = OUTLINE_MATERIAL_LAYERS,
		color = get_color_array("monster_enemy"),
		visibility_check = visibility_check
	}
end

mod.on_setting_changed = function(setting_name)
	mod:update_outline_settings(OutlineSettings)
end

mod:hook_require("scripts/settings/outline/outline_settings", function(instance)
	mod:update_outline_settings(instance)
end)

local function get_my_player_unit()
	if not Managers.player then return nil end

	local player = Managers.player:local_player(1)
	return player.player_unit
end

local function get_side(unit)
	if not unit then return nil end

	local side_system = Managers.state.extension:system("side_system")
	if not side_system then return nil end

	return side_system.side_by_unit[unit]
end

local function get_enemy_units()
	local side = get_side(get_my_player_unit())
	if not side then return {} end

	return side.enemy_units_lookup or {}
end

local function get_breed_tags(enemy_unit_data_extension)
	if enemy_unit_data_extension then
		local breed = enemy_unit_data_extension:breed()
		return breed and breed.tags
	end
	return nil
end

function mod.tick()
	if not Managers.state or not Managers.state.extension then return end

	local has_outline_system = Managers.state.extension:has_system("outline_system")
	if has_outline_system then
		local enemy_units = get_enemy_units()
		local outline_system = Managers.state.extension:system("outline_system")
		for enemy_unit, _ in pairs(enemy_units) do
			
			local outline_unit_data_extension = outline_system._unit_extension_data[enemy_unit]
			if outline_unit_data_extension and outline_unit_data_extension.outlines then
				local outlines_count = #outline_unit_data_extension.outlines
				if outlines_count > 1 then
					outline_system:remove_outline(enemy_unit, "all_enemy")
					outline_system:remove_outline(enemy_unit, "monster_enemy")
					outline_system:remove_outline(enemy_unit, "specialist_enemy")
					outline_system:remove_outline(enemy_unit, "elite_enemy")
				elseif outlines_count < 1 then
					local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
					local breed_tags = get_breed_tags(enemy_unit_data_extension)
					if breed_tags then
						if mod:get(ELITE_ENEMY_SETTING) and (breed_tags.elite or breed_tags.captain) then
							outline_system:add_outline(enemy_unit, "elite_enemy")
						elseif mod:get(SPECIALIST_ENEMY_SETTING) and breed_tags.special then
							outline_system:add_outline(enemy_unit, "specialist_enemy")
						elseif mod:get(MONSTER_ENEMY_ENABLED_SETTING) and breed_tags.monster then
							outline_system:add_outline(enemy_unit, "monster_enemy")
						elseif mod:get(ALL_ENEMY_ENABLED_SETTING) then
							outline_system:add_outline(enemy_unit, "all_enemy")
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
			mod.tick()
		end
	end
end