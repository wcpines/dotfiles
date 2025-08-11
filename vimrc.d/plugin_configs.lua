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

-- Claude Code integration functions
local function setup_claude_code_integration()
	-- Function to send current buffer path to Claude Code terminal
	local function send_buffer_context()
		local buf_name = vim.fn.expand('%:.')  -- Get relative path
		local context = string.format("@%s", buf_name)
		
		-- Find Claude Code terminal and send the context
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name_term = vim.api.nvim_buf_get_name(buf)
			if buf_name_term:match("claude") or vim.bo[buf].buftype == 'terminal' then
				-- Send context to terminal
				vim.api.nvim_chan_send(vim.bo[buf].channel, context .. '\n')
				return
			end
		end
		-- Fallback: copy to clipboard
		vim.fn.setreg('+', context)
		print("Claude Code terminal not found. Context copied to clipboard: " .. context)
	end

	-- Function to send visual selection to Claude Code terminal  
	local function send_selection()
		-- Get visual selection
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local lines = vim.fn.getline(start_pos[2], end_pos[2])
		
		-- Handle single line selection
		if #lines == 1 then
			lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
		else
			-- Handle multi-line selection
			lines[1] = string.sub(lines[1], start_pos[3])
			lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
		end
		
		local selection = table.concat(lines, '\n')
		local buf_name = vim.fn.expand('%:.')
		local context = string.format("From %s (lines %d-%d):\n```\n%s\n```\n", 
			buf_name, start_pos[2], end_pos[2], selection)
		
		-- Find Claude Code terminal and send the selection
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name_term = vim.api.nvim_buf_get_name(buf)
			if buf_name_term:match("claude") or vim.bo[buf].buftype == 'terminal' then
				vim.api.nvim_chan_send(vim.bo[buf].channel, context)
				return
			end
		end
		-- Fallback: copy to clipboard
		vim.fn.setreg('+', context)
		print("Claude Code terminal not found. Selection copied to clipboard")
	end

	-- Function to send entire buffer content
	local function send_buffer_content()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local content = table.concat(lines, '\n')
		local buf_name = vim.fn.expand('%:.')
		local context = string.format("Full content of %s:\n```\n%s\n```\n", buf_name, content)
		
		-- Find Claude Code terminal and send the content
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name_term = vim.api.nvim_buf_get_name(buf)
			if buf_name_term:match("claude") or vim.bo[buf].buftype == 'terminal' then
				vim.api.nvim_chan_send(vim.bo[buf].channel, context)
				return  
			end
		end
		-- Fallback: copy to clipboard
		vim.fn.setreg('+', context)
		print("Claude Code terminal not found. Buffer content copied to clipboard")
	end

	-- Create commands
	vim.api.nvim_create_user_command('ClaudeContext', send_buffer_context, 
		{ desc = 'Send current buffer context to Claude Code' })
	vim.api.nvim_create_user_command('ClaudeSelection', send_selection, 
		{ desc = 'Send visual selection to Claude Code', range = true })
	vim.api.nvim_create_user_command('ClaudeBuffer', send_buffer_content,
		{ desc = 'Send entire buffer content to Claude Code' })

	-- Set up keymaps
	vim.keymap.set('n', '<leader>cf', send_buffer_context, { desc = 'Send file path to Claude' })
	vim.keymap.set('v', '<leader>cs', send_selection, { desc = 'Send selection to Claude' })
	vim.keymap.set('n', '<leader>cb', send_buffer_content, { desc = 'Send buffer to Claude' })
end

-- Initialize plugin configurations
local function init()
	setup_enhanced_colors()
	setup_claude_code_integration()
end

-- Return the initialization function
return {
	init = init,
} 