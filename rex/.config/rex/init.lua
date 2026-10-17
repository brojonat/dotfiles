-- Smart pane switching with awareness of Vim splits, a la vim-tmux-navigator.
-- When the focused terminal is running Vim, ctrl+hjkl falls through to it
-- (nvim moves between its own splits and calls `rex focus` at the edge).
-- Otherwise Rex moves focus to the neighboring pane.

local terminal = "com.superlogical.terminal"

-- Same set as tmux's is_vim regex: g?(view|n?vim?x?)(diff)?
local function is_vim_name(name)
  name = (name or ""):match("[^/]*$"):gsub("^g", ""):gsub("diff$", "")
  return name == "view" or name:match("^n?vim?x?$") ~= nil
end

local function is_vim(block_id)
  local p = rex.block.call(terminal, "process", { block_id = block_id })
  local fg = p and p.foreground
  if not fg then return false end
  return is_vim_name(fg.argv0) or is_vim_name(fg.name)
end

local function navigate(direction)
  return function(ctx)
    if is_vim(ctx.block_id) then return false end -- send the key to Vim
    rex.session.focus_direction{ direction = direction }
    return true
  end
end

rex.bind("ctrl+h", navigate("left"))
rex.bind("ctrl+j", navigate("down"))
rex.bind("ctrl+k", navigate("up"))
rex.bind("ctrl+l", navigate("right"))

-- Leader key sequences, mirroring the C-Space prefix in .tmux.conf and
-- tmux's default bindings under it. % and " are shift+5 and shift+' on a
-- US layout.
local leader = "ctrl+space>"
rex.bind(leader .. "shift+5", "pane.split", { direction = "right" })
rex.bind(leader .. "shift+'", "pane.split", { direction = "down" })
rex.bind(leader .. "z", "pane.zoom")
rex.bind(leader .. "x", "pane.close")
rex.bind(leader .. "o", "pane.focus_next")
rex.bind(leader .. "c", "client.tab.new")
rex.bind(leader .. "n", "client.tab.next")
rex.bind(leader .. "p", "client.tab.previous")
rex.bind(leader .. ",", "client.tab.rename")
rex.bind(leader .. "shift+7", "client.tab.close") -- &
rex.bind(leader .. "s", "session.switch")
rex.bind(leader .. "shift+s", "session.new")
rex.bind(leader .. "shift+4", "session.rename") -- $
rex.bind(leader .. "shift+x", "session.close")
rex.bind(leader .. "r", "client.config.reload")
for i = 1, 9 do
  rex.bind(leader .. i, "client.tab.goto", { index = i })
end

-- Poor man's copy mode (tmux's prefix [): open the focused pane's screen
-- read-only in nvim, zoomed to fill the window, and yank with vim motions.
-- Quitting nvim closes the pane. Rex only exposes the visible screen, not
-- scrollback.
rex.action{
  name = "copy_mode",
  title = "Open Screen in Neovim",
  run = function(ctx)
    local screen, err = rex.block.call(terminal, "format", {
      block_id = ctx.block_id,
      format = "text",
      trim = true,
      unwrap = true,
    })
    if screen == nil then error(err, 0) end

    local path = os.tmpname()
    local f = assert(io.open(path, "w"))
    f:write(screen.content)
    f:close()

    local split, split_err = rex.session.new_split{
      anchor_block_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = {
          -- nvim directly (not via sh) so the vim check above sees it.
          command = {
            "nvim", "-R", "-n", "+normal G",
            "+autocmd VimLeave * call delete('" .. path .. "')",
            path,
          },
        },
      },
    }
    if split == nil then error(split_err, 0) end
    rex.session.zoom_block{ block_id = split.block_ids[1], zoom = true }
  end,
}
rex.bind(leader .. "[", "copy_mode")
-- Press ctrl+space twice to send one to the terminal (tmux's send-prefix).
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
