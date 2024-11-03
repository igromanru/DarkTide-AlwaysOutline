return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AlwaysOutline` encountered an error loading the Darktide Mod Framework.")

		new_mod("AlwaysOutline", {
			mod_script       = "AlwaysOutline/scripts/mods/AlwaysOutline/AlwaysOutline",
			mod_data         = "AlwaysOutline/scripts/mods/AlwaysOutline/AlwaysOutline_data",
			mod_localization = "AlwaysOutline/scripts/mods/AlwaysOutline/AlwaysOutline_localization",
		})
	end,
	packages = {},
}
