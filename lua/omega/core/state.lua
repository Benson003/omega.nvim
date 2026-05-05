local M = {
    instrumentation = false,
}

function M.enable_instrumentation()
    M.instrumentation = true
end

function M.disable_instrumentation()
    M.instrumentation = false
end

return M
