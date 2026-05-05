local M = {}
function M.attach(bufnr, tools_spec)
    local ft = vim.bo[bufnr].filetype

    if tools_spec.formatter and tools_spec.formatter.preferred then
        local conform = require("conform")
        -- Ensure this is a table, conform doesn't like raw strings
        local preferred = type(tools_spec.formatter.preferred) == "string" 
                          and { tools_spec.formatter.preferred } 
                          or tools_spec.formatter.preferred
        
        conform.formatters_by_ft[ft] = preferred
    end

    if tools_spec.linter and tools_spec.linter.preferred then
        local lint = require("lint")
        lint.linters_by_ft[ft] = tools_spec.linter.preferred
        
        -- Use defer_fn to ensure the UI/Buffer is ready
        vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                lint.try_lint()
            end
        end, 100)
    end
end
return M
