return {
  "neovim/nvim-lspconfig",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.INFO] = "I",
          [vim.diagnostic.severity.HINT] = "H",
        },
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      max_width = math.floor(vim.o.columns * 0.7),
      max_height = 10,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      max_width = math.floor(vim.o.columns * 0.7),
      max_height = 8,
    })

    vim.lsp.config("html", {
      filetypes = {
        "html",
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim",
            },
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    })

    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = false,
        },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          check = {
            command = "check",
          },
        },
      },
    })

    vim.lsp.config("texlab", {
      settings = {
        texlab = {
          build = {
            executable = "latexmk",
            args = {
              "-pdf",
              "-interaction=nonstopmode",
              "-synctex=1",
              "%f",
            },
            onSave = false,
            forwardSearchAfter = false,
          },
          forwardSearch = {
            executable = "evince",
            args = {
              "%p",
            },
          },
        },
      },
    })

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          validate = {
            enable = true,
          },
        },
      },
    })

    vim.lsp.config("html", {
      filetypes = {
        "html",
      },
      settings = {
        html = {
          format = {
            enable = false,
          },
          hover = {
            documentation = true,
            references = true,
          },
        },
      },
    })

    vim.lsp.config("cssls", {
      settings = {
        css = {
          validate = true,
        },
        scss = {
          validate = true,
        },
        less = {
          validate = true,
        },
      },
    })

    vim.lsp.config("bashls", {})

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
      },
    })

    vim.lsp.enable("clangd")

    local hover_group = vim.api.nvim_create_augroup("LspHoverOnHold", {
      clear = true,
    })

    local diagnostic_timer = nil
    local hover_timer = nil

    local function stop_timer(timer)
      if timer and not timer:is_closing() then
        timer:stop()
        timer:close()
      end

      return nil
    end

    local function diagnostic_under_cursor()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local lnum = cursor[1] - 1
      local col = cursor[2]

      local diagnostics = vim.diagnostic.get(0, {
        lnum = lnum,
      })

      for _, diagnostic in ipairs(diagnostics) do
        local start_col = diagnostic.col or 0
        local end_col = diagnostic.end_col or start_col + 1

        if col >= start_col and col <= end_col then
          return true
        end
      end

      return false
    end

    local function has_lsp()
      return not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0 }))
    end

    local function schedule_popups()
      diagnostic_timer = stop_timer(diagnostic_timer)
      hover_timer = stop_timer(hover_timer)

      diagnostic_timer = vim.uv.new_timer()
      diagnostic_timer:start(500, 0, vim.schedule_wrap(function()
        if has_lsp() and diagnostic_under_cursor() then
          vim.diagnostic.open_float(nil, {
            focus = false,
            scope = "cursor",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
          })
        end
      end))

      hover_timer = vim.uv.new_timer()
      hover_timer:start(3000, 0, vim.schedule_wrap(function()
        if has_lsp() and not diagnostic_under_cursor() then
          vim.lsp.buf.hover({
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.7),
            max_height = 10,
          })
        end
      end))
    end

    vim.api.nvim_create_autocmd({
      "CursorMoved",
      "CursorMovedI",
      "BufEnter",
    }, {
      group = hover_group,
      callback = schedule_popups,
    })

    vim.api.nvim_create_autocmd({
      "BufLeave",
      "WinLeave",
    }, {
      group = hover_group,
      callback = function()
        diagnostic_timer = stop_timer(diagnostic_timer)
        hover_timer = stop_timer(hover_timer)
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, action, desc)
          vim.keymap.set("n", keys, action, {
            buffer = event.buf,
            desc = desc,
          })
        end

        local function jump_location_in_tab(method)
          local params = vim.lsp.util.make_position_params(0, "utf-8")
          local results = vim.lsp.buf_request_sync(0, method, params, 1000)

          if not results or vim.tbl_isempty(results) then
            return false
          end

          local location = nil

          for _, result in pairs(results) do
            if result.result then
              if vim.islist(result.result) then
                location = result.result[1]
              else
                location = result.result
              end

              break
            end
          end

          if not location then
            return false
          end

          local uri = location.uri or location.targetUri
          local range = location.range or location.targetSelectionRange

          if not uri or not range then
            return false
          end

          local filename = vim.uri_to_fname(uri)
          local row = range.start.line + 1
          local col = range.start.character

          vim.cmd("tabnew " .. vim.fn.fnameescape(filename))
          vim.api.nvim_win_set_cursor(0, { row, col })
          vim.cmd("normal! zz")

          return true
        end

        local function implementation_in_tab()
          if jump_location_in_tab("textDocument/implementation") then
            return
          end

          if jump_location_in_tab("textDocument/definition") then
            return
          end

          vim.notify("Implementation not found", vim.log.levels.WARN)
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("gr", vim.lsp.buf.references, "Go to references")

        map("K", function()
          vim.lsp.buf.hover({
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.7),
            max_height = 10,
          })
        end, "Hover documentation")
        map("<leader>gt", implementation_in_tab, "Go to implementation in new tab")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")

        map("<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")

        map("[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous diagnostic")

        map("]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")

        map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
      end,
    })
  end,
}
