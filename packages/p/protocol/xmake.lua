package("protocol")
    set_homepage("https://github.com/yangyangzhong82/BedrockProtocol")
    set_description("Minecraft Bedrock v975 protocol library in C++23")
    set_license("MPL-2.0")

    add_urls("https://github.com/yangyangzhong82/BedrockProtocol.git")
    add_versions("v975", "15a144aee446c08cb40823503a2a6d145a120484")
    add_versions("v2168", "49582c04be5412f335ca549a5beb57a1f58f49a1")

    add_deps("openssl3")
    add_configs("shared", {description = "Build shared library", default = false, type = "boolean"})

    on_install(function (package)
        io.replace("CMakeLists.txt",
            "add_library(Protocol STATIC ${PROTOCOL_SOURCES})",
            "add_library(Protocol ${PROTOCOL_SOURCES})",
            {plain = true})

        local configs = {
            "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"),
            "-DREFLECTION_BUILD_TESTS=OFF"
        }
        if package:is_plat("windows") then
            table.insert(configs, "-DCMAKE_CXX_FLAGS=/FIcharconv /FIsystem_error")
            if package:config("shared") then
                table.insert(configs, "-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON")
            end
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <sculk/protocol/codec/MinecraftPackets.hpp>
            #include <sculk/protocol/codec/packet/IPacket.hpp>

            void test() {
                auto packet = sculk::protocol::MinecraftPackets::createPacket(
                    sculk::protocol::MinecraftPacketIds::Login);
                (void)packet;
            }
        ]]}, {configs = {languages = "c++23"}}))
    end)
package_end()
