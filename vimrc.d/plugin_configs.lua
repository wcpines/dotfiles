-- Plugin configurations
-- This file contains all plugin-specific configurations

-- Enhanced Colors command that includes both .vim and .lua colorschemes
local function setup_enhanced_colors()
	-- Function to get all colorschemes (both .vim and .lua)
	local function get_all_colors()
		local colors = {}
		
		-- Get .vim colorschemes from runtimepath
		local vim_colors = vim.split(vim.fn.globpath(vim.o.rtp, "colors/*.vim"), "\n")
		for _, path in ipairs(vim_colors) do
			if path ~= "" then
				local name = vim.fn.fnamemodify(path, ":t:r")
				if not vim.tbl_contains(colors, name) then
					table.insert(colors, name)
				end
			end
		end
		
		-- Get .lua colorschemes from runtimepath
		local lua_colors = vim.split(vim.fn.globpath(vim.o.rtp, "colors/*.lua"), "\n")
		for _, path in ipairs(lua_colors) do
			if path ~= "" then
				local name = vim.fn.fnamemodify(path, ":t:r")
				if not vim.tbl_contains(colors, name) then
					table.insert(colors, name)
				end
			end
		end
		
		-- Also check packpath for packages
		if vim.fn.has('packages') == 1 then
			local pack_vim = vim.split(vim.fn.globpath(vim.o.packpath, "pack/*/opt/*/colors/*.vim"), "\n")
			for _, path in ipairs(pack_vim) do
				if path ~= "" then
					local name = vim.fn.fnamemodify(path, ":t:r")
					if not vim.tbl_contains(colors, name) then
						table.insert(colors, name)
					end
				end
			end
			
			local pack_lua = vim.split(vim.fn.globpath(vim.o.packpath, "pack/*/opt/*/colors/*.lua"), "\n")
			for _, path in ipairs(pack_lua) do
				if path ~= "" then
					local name = vim.fn.fnamemodify(path, ":t:r")
					if not vim.tbl_contains(colors, name) then
						table.insert(colors, name)
					end
				end
			end
		end
		
		-- Sort and put current colorscheme first
		table.sort(colors)
		if vim.g.colors_name then
			-- Remove current from list and add at beginning
			colors = vim.tbl_filter(function(c) return c ~= vim.g.colors_name end, colors)
			table.insert(colors, 1, vim.g.colors_name)
		end
		
		return colors
	end
	
	-- Override the default Colors command
	vim.api.nvim_create_user_command('Colors', function(opts)
		local colors = get_all_colors()
		require('fzf-lua').fzf_exec(colors, {
			actions = {
				['default'] = function(selected)
					if selected and selected[1] then
						vim.cmd('colo ' .. selected[1])
					end
				end,
			},
			previewer = false,
			prompt = 'Colors> ',
			winopts = {
				height = 0.6,
				width = 0.5,
			}
		})
	end, { bang = true, desc = 'Enhanced Colors command with fzf-lua' })
end


-- Initialize plugin configurations
local function init()
	setup_enhanced_colors()
end

-- Return the initialization function
return {
	init = init,
} 