package("protocol")
    set_homepage("https://github.com/yangyangzhong82/Protocol")
    set_description("Minecraft Bedrock protocol library in C++23")
    set_license("MPL-2.0")

    add_urls("https://github.com/yangyangzhong82/Protocol.git")
    add_versions("dev", "main")

    add_deps("openssl")
    add_configs("shared", {description = "Build shared library", default = true, type = "boolean"})

    on_install(function (package)
        if os.isfile("xmake.lua") then
            import("package.tools.xmake").install(package, {
                mode = package:is_debug() and "debug" or "release",
                configs = {shared = package:config("shared")}
            })
        else
            import("package.tools.cmake").install(package, {
                "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"),
                "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF")
            })
        end
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("sculk/protocol/MinecraftPackets.hpp"))
    end)
