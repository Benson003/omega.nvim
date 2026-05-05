return {
    "glsl_hlsl",

    filetypes = {
        "glsl",
        "hlsl",
    },

    treesitter = {
        host = "glsl",
        injections = {
            "glsl",
            "hlsl",
        },
    },

    lsp = {
        servers = {
            glsl_analyzer = {
                settings = {
                    filetypes = { "glsl" },
                },
            },

            ["hlsl-language-server"] = {
                settings = {
                    filetypes = { "hlsl" },
                },
            },
        },
    },

    tools = {
        mason = {
            ensure_installed = {
                "glsl_analyzer",
                "hlsl-language-server",
            },
        },

        formatter = {
            preferred = {
                "clang-format",
            },
            config = {
                style = "file",
            },
        },

        linter = {
            preferred = {
                "glslangValidator",
            },
            config = {
                args = { "-V", "--quiet" },
            },
        },
    },
}
