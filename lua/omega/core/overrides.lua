local M = {}
local diag = require("omega.core.diagnostics")

local function safe_load_file(path)
    local ok, err = pcall(dofile, path)
    if not ok then
        diag.add("runtime", "errors", {
            type = "override_load_failed",
            file = path,
            error = err,
        })
    end
end

local function scan_dir(dir, source)
    if vim.fn.isdirectory(dir) == 0 then return {} end

    local specs = {}
    -- vim.fs.dir returns an iterator that traverses the directory
    -- 'type' will be 'file' or 'directory'
    for name, type in vim.fs.dir(dir, { depth = 10 }) do
        if type == "file" and name:sub(-4) == ".lua" then
            -- Construct the full path
            -- Note: vim.fs.dir 'name' is relative to 'dir'
            local path = dir .. "/" .. name
            local spec = safe_load_file(path)

            if spec then
                spec._omega_source = source
                table.insert(specs, spec)
            end
        end
    end

    return specs
end

function M.load()
    local base = vim.fn.stdpath("config") .. "/lua/user"
    scan_dir(base .. "/overrides")
end

return M
