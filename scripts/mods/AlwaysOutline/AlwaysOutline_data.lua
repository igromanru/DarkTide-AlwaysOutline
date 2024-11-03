local mod = get_mod("AlwaysOutline")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	allow_rehooking = true,
	options = {
		widgets =
		{
			{
				setting_id = "enable_mod",
				title =  "enable",
				tooltip = "enable_mod_tooltip",
				type = "checkbox",
				default_value = true
			},
			{
				setting_id = "all_enemy",
				type = "group",
				sub_widgets =
				{
					{
						setting_id = "all_enemy_enabled",
						title =  "enable",
						type = "checkbox",
						default_value = false
					},
					{
						setting_id = "all_enemy_priority",
						tooltip = "priority_tooltip",
						title = "priority_title",
						type = "numeric",
						default_value = 4,
						range = {1, 10},
						decimals_number = 0
					},
					{
						setting_id = "all_enemy_r",
						title = "title_r",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "all_enemy_g",
						title = "title_g",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "all_enemy_b",
						title = "title_b",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
				}
			},
			{
				setting_id = "specialist_enemy",
				type = "group",
				sub_widgets =
				{
					{
						setting_id = "specialist_enemy_enabled",
						title =  "enable",
						type = "checkbox",
						default_value = true
					},
					{
						setting_id = "specialist_enemy_priority",
						tooltip = "priority_tooltip",
						title = "priority_title",
						type = "numeric",
						default_value = 3,
						range = {1, 10},
						decimals_number = 0
					},
					{
						setting_id = "specialist_enemy_r",
						title = "title_r",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "specialist_enemy_g",
						title = "title_g",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "specialist_enemy_b",
						title = "title_b",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
				}
			},
			{
				setting_id = "elite_enemy",
				type = "group",
				sub_widgets =
				{
					{
						setting_id = "elite_enemy_enabled",
						title =  "enable",
						type = "checkbox",
						default_value = true
					},
					{
						setting_id = "elite_enemy_priority",
						tooltip = "priority_tooltip",
						title = "priority_title",
						type = "numeric",
						default_value = 3,
						range = {1, 10},
						decimals_number = 0
					},
					{
						setting_id = "elite_enemy_r",
						title = "title_r",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "elite_enemy_g",
						title = "title_g",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "elite_enemy_b",
						title = "title_b",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
				}
			},
			{
				setting_id = "monster_enemy",
				type = "group",
				sub_widgets =
				{
					{
						setting_id = "monster_enemy_enabled",
						title =  "enable",
						type = "checkbox",
						default_value = true
					},
					{
						setting_id = "monster_enemy_priority",
						tooltip = "priority_tooltip",
						title = "priority_title",
						type = "numeric",
						default_value = 3,
						range = {1, 10},
						decimals_number = 0
					},
					{
						setting_id = "monster_enemy_r",
						title = "title_r",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "monster_enemy_g",
						title = "title_g",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
					{
						setting_id = "monster_enemy_b",
						title = "title_b",
						type = "numeric",
						default_value = 128,
						range = {0, 255},
						decimals_number = 0
					},
				}
			},
		},
	},
}
