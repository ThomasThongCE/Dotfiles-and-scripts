require("zoxide"):setup {
	update_db = true,
}

-- vim-style relative line numbers + count-motions (5j, 12k, 10gg)
require("relative-motions"):setup {
	show_numbers = "relative_absolute", -- hybrid like vim number+relativenumber
	show_motion = true,
}

require("git"):setup {
	order = 1500,
}
