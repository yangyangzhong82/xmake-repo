package("mysql-connector-cpp")

    set_homepage("https://dev.mysql.com/doc/connector-cpp/en/")
    set_description("MySQL Connector/C++ is a MySQL database connector for C++.")
    set_license("GPL-2.0-only WITH Universal-FOSS-exception-1.0")

    add_urls("https://github.com/mysql/mysql-connector-cpp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/mysql/mysql-connector-cpp.git")
    add_versions("9.0.0", "113990744a1191038a00a05b19b14a67a71028070631b7594181977e8f4401a3")
    add_versions("8.4.0", "9721a514f47084ffa941b3c1119206784670114007cb57118618578114181111")
    -- add_versions("8.0.33", "3613a98914301944a05e881115e9c80190477865181111111111111111111111") -- Example older version

    add_deps("cmake")
    add_deps("openssl", "protobuf-cpp")

    -- Add patch for Windows linking Crypt32
    if is_plat("windows") then
        -- Assuming the patch file exists at the specified path relative to xmake.lua
        -- You might need to provide the full SHA256 hash for verification if required by your setup
        add_patches("9.0.0", "patches/9.0.0/win_link_crypt32.patch")
        -- Add patches for other versions if needed, e.g.:
        -- add_patches("8.4.0", "patches/8.4.0/win_link_crypt32.patch")
    end

    on_install("windows", "linux", "macosx", function (package)
        local configs = {
            "-DWITH_JDBC=OFF",
            "-DWITH_TESTS=OFF",
            "-DWITH_DOC=OFF"
        }
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        -- Try to pass dependency paths explicitly
        local openssl_dep = package:dep("openssl")
        local openssl_installdir = openssl_dep:installdir()
        if openssl_installdir then
            table.insert(configs, "-DOPENSSL_ROOT_DIR=" .. openssl_installdir)
            -- Provide hints for libraries and includes
            table.insert(configs, "-DOPENSSL_INCLUDE_DIR=" .. openssl_dep:installdir("include"))
            local libdir = openssl_dep:installdir("lib")
            local ssl_lib = path.join(libdir, package:config("shared") and openssl_dep:libfilename("ssl") or openssl_dep:libfilename("libssl"))
            local crypto_lib = path.join(libdir, package:config("shared") and openssl_dep:libfilename("crypto") or openssl_dep:libfilename("libcrypto"))
            if os.isfile(ssl_lib) and os.isfile(crypto_lib) then
                 table.insert(configs, "-DOPENSSL_LIBRARIES=" .. ssl_lib .. ";" .. crypto_lib)
            end
            -- Some cmake find modules might need this
            if package:config("shared") then
                table.insert(configs, "-DOPENSSL_USE_STATIC_LIBS=OFF")
            else
                table.insert(configs, "-DOPENSSL_USE_STATIC_LIBS=ON")
            end
        end

        local protobuf_dep = package:dep("protobuf-cpp")
        local protobuf_installdir = protobuf_dep:installdir()
        if protobuf_installdir then
            -- Find the correct path for protobuf-config.cmake or FindProtobuf.cmake hints
            local protobuf_cmake_dir = path.join(protobuf_installdir, "lib/cmake/protobuf")
            if os.isdir(protobuf_cmake_dir) then
                 table.insert(configs, "-DProtobuf_DIR=" .. protobuf_cmake_dir)
            else
                 -- Provide library/include hints if DIR doesn't work
                 table.insert(configs, "-DProtobuf_INCLUDE_DIR=" .. protobuf_dep:installdir("include"))
                 table.insert(configs, "-DProtobuf_LIBRARY=" .. path.join(protobuf_dep:installdir("lib"), protobuf_dep:libfilename("protobuf")))
                 -- Potentially need protobuf-lite and protoc libs too depending on cmake script
            end
            -- Specify static/shared protobuf linkage based on dependency build
            table.insert(configs, "-DProtobuf_USE_STATIC_LIBS=" .. (protobuf_dep:config("shared") == false and "ON" or "OFF"))
        end

        -- Add C++ standard definition
        table.insert(configs, "-DCMAKE_CXX_STANDARD=17")
        table.insert(configs, "-DCMAKE_CXX_STANDARD_REQUIRED=ON")
        table.insert(configs, "-DCMAKE_CXX_EXTENSIONS=OFF") -- Optional: disable compiler-specific extensions

        if package:is_plat("windows") then
            -- Ensure static runtime if building static lib on windows
            if not package:config("shared") then
                -- CMake handles this via CMAKE_MSVC_RUNTIME_LIBRARY or policy CMP0091
                -- Let's try setting the variable directly
                table.insert(configs, "-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded$<$<CONFIG:Debug>:Debug>")
            end
        end

        import("package.tools.cmake").install(package, configs)

        -- Ensure correct include paths are copied/installed
        -- CMake install rules should handle this, but we can force copy if needed
        os.cp("include", package:installdir())
        if os.isdir(path.join(package:buildir(), "include/mysqlx")) then
             os.cp(path.join(package:buildir(), "include/mysqlx"), package:installdir("include"))
        end
        if os.isdir(path.join(package:buildir(), "include/jdbc")) then
             os.cp(path.join(package:buildir(), "include/jdbc"), package:installdir("include"))
        end
    end)

    on_load(function (package)
        -- Determine library name based on version and static/shared
        local libname = "mysqlcppconn"
        if package:version():ge("8.0.0") then
             libname = "mysqlcppconn" .. package:version():major()
        end

        if package:config("shared") then
            package:add("links", libname)
        else
            -- Static library name might be the same or have a suffix, check CMakeLists/install layout if needed
            -- Assuming the name is the same for static lib for now
            package:add("links", libname)
            package:add("defines", "CONCPP_BUILD_STATIC") -- Define for static linking
            package:add("defines", "STATIC_CONCPP") -- Also defined in CMakeLists for static builds
        end
        package:add("includedirs", "include") -- Public headers

        -- Add system dependencies
        if package:is_plat("windows") then
            package:add("syslinks", "Secur32", "Shlwapi", "Crypt32")
            -- If using static openssl, might need Ws2_32, Gdi32, User32, Advapi32, Crypt32
            if not package:dep("openssl"):config("shared") then
                package:add("syslinks", "Ws2_32", "Gdi32", "User32", "Advapi32")
            end
        elseif package:is_plat("linux") then
            package:add("syslinks", "pthread", "dl", "m")
        elseif package:is_plat("macosx") then
            package:add("syslinks", "pthread")
            package:add("frameworks", "CoreFoundation", "SystemConfiguration", "Security")
        end

        -- Add protobuf libs if linking statically
        if not package:config("shared") then
            local protobuf_dep = package:dep("protobuf-cpp")
            if not protobuf_dep:config("shared") then
                 package:add("links", protobuf_dep:libname("protobuf"))
                 -- May need protobuf-lite, protoc-lib depending on usage
            end
        end
    end)
