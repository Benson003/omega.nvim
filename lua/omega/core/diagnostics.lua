local M = {}

-- =========================
-- Schema
-- =========================

local SCHEMA = {
    loader = {
        overrides = true,
        duplicates = true,
        errors = true,
    },
    registry = {
        conflicts = true,
    },
    runtime = {
        errors = true,
        warnings = true,
    },
}

-- =========================
-- Store
-- =========================

local function default_store()
    local store = {}

    for section, kinds in pairs(SCHEMA) do
        store[section] = {}
        for kind, _ in pairs(kinds) do
            store[section][kind] = {}
        end
    end

    return store
end

local store = default_store()

-- =========================
-- Internal helpers
-- =========================

local function valid(section, kind)
    return SCHEMA[section] and SCHEMA[section][kind]
end

local function wrap(section, kind, item)
    if type(item) ~= "table" then
        item = { message = tostring(item) }
    end

    return {
        ts = os.time(),
        section = section,
        kind = kind,
        data = item,
    }
end

-- =========================
-- API
-- =========================

function M.add(section, kind, item)
    if not valid(section, kind) then
        -- silent fail OR track internally (your choice)
        return
    end

    local entry = wrap(section, kind, item)
    table.insert(store[section][kind], entry)
end

function M.get()
    return store
end

function M.get_section(section)
    return store[section]
end

function M.get_kind(section, kind)
    if not valid(section, kind) then
        return nil
    end
    return store[section][kind]
end

function M.reset()
    store = default_store()
end

-- =========================
-- Query helpers (lightweight)
-- =========================

function M.count(section, kind)
    local k = M.get_kind(section, kind)
    return k and #k or 0
end

function M.has_errors()
    return M.count("loader", "errors") > 0
        or M.count("runtime", "errors") > 0
end

return M
