package("mysql-connector-cpp")

    set_homepage("https://dev.mysql.com/doc/connector-cpp/en/")
    set_description("MySQL Connector/C++ is a MySQL database connector for C++.")
    set_license("GPL-2.0-only WITH Universal-FOSS-exception-1.0")

    add_urls("https://github.com/mysql/mysql-connector-cpp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/mysql/mysql-connector-cpp.git")
    add_versions("9.0.0", "113990744a1191038a00a05b19b14a67a71028070631b7594181977e8f4401a3")
    add_versions("8.4.0", "9721a514f47084ffa941b3c1119206784670114007cb57118618578114181111")
    add_versions("8.0.33", "3613a98914301944a05e881115e9c80190477865181111111111111111111111") -- Example older version, hash needs verification if used

    add_deps("openssl", "protobuf")

    -- Default to shared library build, as per connector's default
    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean"})

    on_install("windows", "linux", "macosx", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_INSTALL_LIBDIR=" .. package:installdir("lib"))
        table.insert(configs, "-DCMAKE_INSTALL_INCLUDEDIR=" .. package:installdir("include"))
        table.insert(configs, "-DWITH_JDBC=OFF")
        table.insert(configs, "-DWITH_TESTS=OFF")
        -- BUILD_STATIC=OFF builds shared lib, BUILD_STATIC=ON builds static lib
        if package:config("shared") then
            table.insert(configs, "-DBUILD_STATIC=OFF")
        else
            -- Note: This builds *only* the static library
            table.insert(configs, "-DBUILD_STATIC=ON")
            if package:is_plat("windows") then
                -- When building static lib on windows, allow static runtime
                table.insert(configs, "-DSTATIC_MSVCRT=ON")
            end
            -- Add define for static linking
            package:add("defines", "STATIC_CONCPP")
        end
        -- Let CMake handle C++ standard via enable_cxx17()
        -- table.insert(configs, "-DCMAKE_CXX_STANDARD=17")

        -- Add dependency paths
        local openssl_installdir = package:dep("openssl"):installdir()
        if openssl_installdir then
            -- CMake find_dependency(SSL) needs OPENSSL_ROOT_DIR or similar hints
            table.insert(configs, "-DOPENSSL_ROOT_DIR=" .. openssl_installdir)
            -- Some FindSSL modules might need these too
            table.insert(configs, "-DOPENSSL_INCLUDE_DIR=" .. openssl_installdir .. "/include")
            table.insert(configs, "-DOPENSSL_LIBRARIES=" .. openssl_installdir .. "/lib")
        end

        local protobuf_installdir = package:dep("protobuf"):installdir()
        if protobuf_installdir then
             -- CMake find_dependency(Protobuf) needs PROTOBUF_ROOT or similar hints
            table.insert(configs, "-DProtobuf_ROOT=" .. protobuf_installdir)
        end

        import("package.tools.cmake").install(package, configs)

        -- Ensure headers are in include directory (CMake should handle this with CMAKE_INSTALL_INCLUDEDIR)
        -- os.cp("include/*", package:installdir("include"))
    end)

    on_load(function (package)
        package:add("includedirs", "include")
        if package:config("shared") then
            package:add("links", "mysqlcppconn") -- Common name for shared lib
        else
            package:add("links", "mysqlcppconn-static") -- Common name for static lib
            package:add("defines", "STATIC_CONCPP") -- Define needed for static linking
        end
        -- Add system libraries if needed (e.g., on Linux)
        if package:is_plat("linux") then
            package:add("syslinks", "pthread", "m", "dl")
        elseif package:is_plat("windows") then
             -- Dependencies like ws2_32 might be needed, check linker errors if any
             package:add("syslinks", "ws2_32", "secur32")
        end
    end)
