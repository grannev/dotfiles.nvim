local function run_copilot_chat(prompt)
  vim.cmd("CopilotChat " .. vim.fn.escape(prompt, "\\|\""))
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
      "Apply this change directly to the current file using the edit tool.",
      "Do not only explain. Modify the buffer/file.",
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
      "Apply this change directly to the selected code using the edit tool.",
      "Do not only explain. Modify the buffer/file.",
      "Change only the selected code if possible.",
      "Task:",
      input,
    }, " ")

    run_copilot_chat(prompt)
  end)
end

vim.keymap.set("n", "<leader>ab", edit_current_buffer, {
  desc = "AI edit current buffer",
})

vim.keymap.set("v", "<leader>av", edit_selection, {
  desc = "AI edit selection",
})
