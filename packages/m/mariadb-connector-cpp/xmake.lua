package("mariadb-connector-cpp")

    set_homepage("https://github.com/mariadb-corporation/mariadb-connector-cpp")
    set_description("MariaDB Connector/C++ is a C++ library for connecting to MariaDB and MySQL servers.")
    set_license("LGPL-2.1")

    add_urls("https://github.com/mariadb-corporation/mariadb-connector-cpp/archive/refs/tags/$(version).tar.gz")
    add_versions("1.1.6", "8c48386e112a138127929b633a304a5b0244b9925c5acc16205cab285f6047e7")
    add_versions("1.0.9", "783267d3f009f928e46955a0a38b2512128549302b17f443589b251e60086c8a")

    -- 定义构建和运行时依赖
    add_deps("cmake")
    -- 核心依赖：它必须依赖于 C 连接器
    add_deps("mariadb-connector-c")
    -- 另一个重要依赖：Boost
    add_deps("boost")

    -- 定义用户可配置的选项
    add_configs("unit_tests", {description = "Build with unit tests.", default = false, type = "boolean"})
    -- 注意：SSL 的支持是自动的。如果其依赖 mariadb-connector-c 开启了 SSL，
    -- C++ 连接器在构建时会自动检测并启用 SSL，无需手动配置。

    on_load(function (package)
        -- 无论静态还是共享库，链接的库名都是 mariadbcpp
        package:add("links", "mariadbcpp")

        -- 告知使用此包的用户，他们需要确保 Boost 的 regex 和 date_time 组件被构建。
        -- xmake 的 boost 包默认不会构建所有组件，用户需要在他们的项目中配置。
        -- 例如：xmake f --boost_components=regex,date_time
        -- 我们在这里添加一个消息来提示用户。
        if not package:is_used_by("self") then
            package:add("links", "boost_regex", "boost_date_time")
            -- print("info: mariadb-connector-cpp requires Boost components: regex, date_time.")
            -- print("info: Please ensure they are enabled in your project's boost configuration.")
            -- print("info: e.g., xmake f --boost_components=regex,date_time")
        end
    end)

    on_install("linux", "macosx", "windows", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))

        -- 将 xmake 的配置转换为 CMake 的选项
        if package:config("unit_tests") then
            table.insert(configs, "-DWITH_UNIT_TESTS=ON")
        else
            table.insert(configs, "-DWITH_UNIT_TESTS=OFF")
        end

        -- xmake 会自动将依赖项（如 mariadb-connector-c, boost）的路径传递给 CMake，
        -- 所以 CMake 的 find_package(MariaDBConnectorC) 和 find_package(Boost) 会自动成功。
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        -- 测试一个核心的 C++ API 函数是否存在，以验证安装是否成功
        assert(package:has_cxxfuncs("sql::mariadb::get_driver_instance", {includes = "mariadb/conncpp.hpp"}))
    end)