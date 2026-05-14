local M = {}
local diag = require("omega.core.diagnostics")

-- =========================
-- Loading primitives
-- =========================

local function safe_load(path)
	local ok, spec = pcall(dofile, path)

	if not ok then
		diag.add("loader", "errors", {
			path = path,
			error = spec,
		})
		return nil
	end

	if type(spec) ~= "table" then
		diag.add("loader", "errors", {
			path = path,
			error = "spec did not return a table",
		})
		return nil
	end

	return spec
end

local function scan_dir(dir, source)
	if vim.fn.isdirectory(dir) == 0 then
		diag.add("loader", "errors", {
			path = source,
			error = "Path is none existent",
		})
		return {}
	end

	local ok, files = pcall(vim.fn.readdir, dir)
	if not ok or type(files) ~= "table" then
		return {}
	end

	local specs = {}

	for _, file in ipairs(files) do
		if file:sub(-4) == ".lua" then
			local path = dir .. "/" .. file
			local spec = safe_load(path)

			if spec then
				spec._omega_source = source
				table.insert(specs, spec)
			end
		end
	end

	return specs
end

-- =========================
-- Startup merge (SAFE)
-- =========================

-- No overrides, no logging, cannot fail
local function startup_merge(infra, ui, extra)
	local seen = {}
	local out = {}

	local function add(list)
		if type(list) ~= "table" then
			diag.add("loader", "errors", {
				path = "",
				error = "invalid format found",
			})
			return
		end
		for _, spec in ipairs(list) do
			local name = spec[1] or spec.name
			if name and not seen[name] then
				seen[name] = true
				table.insert(out, spec)
			end
		end
	end

	-- priority via order
	add(infra)
	add(ui)
	add(extra)

	return out
end

-- =========================
-- Audit merge (STRICT + LOGGING)
-- =========================

local PRIORITY = {
	infra = 3,
	ui = 2,
	extra = 1,
}

local function audit_merge(infra, ui, extra)
	local seen = {}

	local function register(spec)
		local name = spec[1] or spec.name
		local source = spec._omega_source or "extra"

		if not name then
			return
		end

		if not seen[name] then
			seen[name] = spec
			return
		end

		local existing = seen[name]
		local existing_source = existing._omega_source or "extra"

		local new_prio = PRIORITY[source] or 0
		local old_prio = PRIORITY[existing_source] or 0

		if new_prio > old_prio then
			diag.add("loader", "overrides", {
				name = name,
				from = existing_source,
				to = source,
			})
		else
			diag.add("loader", "duplicates", {
				name = name,
				kept = existing_source,
				ignored = source,
			})
		end
	end

	-- order does not matter here, priority handles it
	for _, s in ipairs(extra) do
		register(s)
	end
	for _, s in ipairs(ui) do
		register(s)
	end
	for _, s in ipairs(infra) do
		register(s)
	end
end

-- =========================
-- Init
-- =========================

local function get_omega_root()
	-- This finds where the actual code of the engine is running from
	local str = debug.getinfo(1, "S").source:sub(2)
	-- Remove 'lua/omega/loader.lua' from the end to get the root
	return str:match("(.*)/lua/omega/.*")
end

-- Inside your loader.lua
function M.get_lazy_specs()
	-- User config stays in .config/nvim/lua
	local config_base = vim.fn.stdpath("config") .. "/lua"

	-- Infra files live in .local/share/nvim/lazy/omega.nvim/lua/omega
	-- We use /lazy/omega.nvim because that is the folder name created from the repo
	local omega_root = get_omega_root()
	local data_base = omega_root .. "/lua/omega"

	-- Scans
	local infra = scan_dir(data_base .. "/infra/plugins", "infra")
	local extra = scan_dir(config_base .. "/user/extras", "extra")
	local ui = scan_dir(config_base .. "/user/ui", "ui")

	local merged = startup_merge(infra, ui, extra)

	vim.schedule(function()
		audit_merge(infra, ui, extra)
	end)

	return merged
end

return M
