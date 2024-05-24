-- todo
-- keep as the last window
-- config in lazy
local start_win
local plugin_win
local plugin_buf

local intro_lines = {
  "just a cheat sheet. foundamentals, like :q!, may not be included",
  ":q to close current window",
  "(ctrl_w, h/j/k/l/arrow_key) to change window, or just mouse",
  ":todo_search_mod",
  ":todo_basic_mod",
  ":todo_hide_hint_words"
}

local basic_dict = {
  "ESC: exist current mode back to normal mode",
  "h/j/k/l/arrow_key: move cursor",
  "i: insert mode, not modifying cursor",
  "A: insert mode, move cursor to line-end",
  "x: delete character at cursor position",
  "':q': quit",
  "':q!': force quit, can be essential if there is only a CLI, and for hidden buffers may cause data-lost",
  "':wq': write and quit",
  "':w': write",
  "dd: delete current line, store in clipboard",
  "p: paste below this line",
  "P: paste above this line"
}

local my_dict = {
  "':<n>':\t\tto line n, index starts at 1",
  "G:\t\tto last line",
  "'/<ptn>':\tsearch pattern <ptn>",
  "n/N:\t\tmove to the next/last searched",
  "*(shf_8)/#(shf_3):\tsearch current word and 'n/N'",
  "%(shf_5):\tmove to the matched bracket",
  "dd:\t\tdelete current line. store it in clipboard",
  "yy:\t\tcopy this line",
  "p:\t\tpaste",
  "0:\t\tmove cursor to line-start",
  "$:\t\tmove cursor to line-end",
  "u:\t\tundo",
  "ctrl_r:\t\tredo, important!: control is not command, expecially ctrl_w",
  "ctrl_w, <dir_key>:\tchange window",
  "':saveas <path>': save as",
  "':e <path>':\topen",
  "'.':\t\trepeat last command, '<n><command>' is recognized as not one but n commands",
  "<n><command>:\trepeat <command> n times",
  ":help <command>",
  ":buffers",
  ":sbuffer <buffer_number>",
  "",
  "https://vim.rtorr.com/lang/zh_cn"
}

local function create_helper_buffer()
  plugin_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(plugin_buf, "vim command helper")
  vim.api.nvim_set_option_value("filetype", "txt", { buf = plugin_buf }) -- maybe plain text?
  return plugin_buf
end

local function clear_buffer(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "" })
end

local function exec_plugin()
  -- remember start context
  start_win = vim.api.nvim_get_current_win()

  -- set buffer
  local buf = create_helper_buffer()
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, my_dict)

  -- create window
  vim.api.nvim_command('botright new')
  plugin_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(plugin_win, buf)
  vim.api.nvim_set_option_value("statusline", "vim command helper", { scope = "local", win = plugin_win })

  -- back to start window
  vim.api.nvim_set_current_win(start_win)
end

local function exit_plugin()
  vim.api.nvim_win_close(plugin_win, true)
  vim.api.nvim_buf_delete(plugin_buf, { force = true })
end

exec_plugin()
