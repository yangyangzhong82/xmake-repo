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
                shared = package:config("shared")
            })
        else
            import("package.tools.cmake").install(package, {
                "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"),
                "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF")
            })
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <vector>
            #include <cstddef>
            #include <sculk/protocol/packet/UpdateBlockPacket.hpp>
            #include <sculk/protocol/utility/deps/BinaryStream.hpp>

            void test() {
                std::vector<std::byte> buffer;
                sculk::protocol::UpdateBlockPacket packet;
                sculk::protocol::BinaryStream stream(buffer);
                packet.mRuntimeId = 1;
                packet.mFlag = 3;
                packet.mLayer = 0;
                packet.write(stream);
                (void)packet.getId();
            }
        ]]}, {configs = {languages = "c++23"}}))
    end)
