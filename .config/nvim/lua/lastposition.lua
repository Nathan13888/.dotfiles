local M = {}

local SEVEN_DAYS_SECS = 7 * 24 * 60 * 60

local function undo_file_path(bufname)
  -- Mirrors Neovim's undofile() logic: replaces path separators with %
  local udir = vim.fn.stdpath("data") .. "/undo"
  local encoded = vim.fn.fnamemodify(bufname, ":p"):gsub("[/\\%%]", "%%")
  return udir .. "/" .. encoded
end

local function is_recent(bufname)
  local undo_path = undo_file_path(bufname)
  local stat = vim.uv.fs_stat(undo_path)
  if not stat then
    -- No undo file — treat as recent so the mark is still restored
    return true
  end
  local age = os.time() - stat.mtime.sec
  return age < SEVEN_DAYS_SECS
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("LastPosition", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    desc = "Restore cursor to last edit position",
    callback = function(ev)
      -- Skip special buffers (quickfix, terminal, etc.)
      if vim.bo[ev.buf].buftype ~= "" then
        return
      end

      -- Skip git buffers where position restoration is disruptive
      local ft = vim.bo[ev.buf].filetype
      if ft == "gitcommit" or ft == "gitrebase" then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      if bufname == "" then
        return
      end

      if not is_recent(bufname) then
        return
      end

      -- `"` mark holds the position where the cursor was when the buffer was last exited
      local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
      local row, col = mark[1], mark[2]

      if row <= 0 then
        return
      end

      -- Guard against marks beyond the end of a file (e.g. after truncation)
      local line_count = vim.api.nvim_buf_line_count(ev.buf)
      if row > line_count then
        return
      end

      vim.api.nvim_win_set_cursor(0, { row, col })
      vim.cmd("normal! zz")
    end,
  })
end

return M
