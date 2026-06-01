local function run_copilot_chat(prompt)
  vim.api.nvim_cmd({
    cmd = "CopilotChat",
    args = {
      prompt,
    },
  }, {})
end

local function edit_current_buffer()
  vim.ui.input({
    prompt = "AI edit buffer: ",
  }, function(input)
    if not input or input == "" then
      return
    end

    local prompt = table.concat({
      "@copilot",
      "#buffer:active",
      "Use the edit tool and apply the change directly to the current file.",
      "Do not only explain.",
      "Task:",
      input,
    }, " ")

    run_copilot_chat(prompt)
  end)
end

local function edit_selection()
  vim.ui.input({
    prompt = "AI edit selection: ",
  }, function(input)
    if not input or input == "" then
      return
    end

    local prompt = table.concat({
      "@copilot",
      "#buffer:active",
      "#selection",
      "Use the edit tool and apply the change directly to the selected code.",
      "Do not only explain.",
      "Change only the selected code if possible.",
      "Task:",
      input,
    }, " ")

    run_copilot_chat(prompt)
  end)
end

local function fix_selection()
  local prompt = table.concat({
    "@copilot",
    "#buffer:active",
    "#selection",
    "Use the edit tool and fix the selected code directly in the buffer.",
    "Do not only explain.",
    "Preserve the original behavior unless there is an obvious bug.",
    "Keep the style consistent with the surrounding code.",
  }, " ")

  run_copilot_chat(prompt)
end

vim.keymap.set("n", "<leader>ab", edit_current_buffer, {
  desc = "AI edit current buffer",
})

vim.keymap.set("v", "<leader>av", edit_selection, {
  desc = "AI edit selection with prompt",
})

vim.keymap.set("v", "<leader>af", fix_selection, {
  desc = "AI fix selection in buffer",
})
