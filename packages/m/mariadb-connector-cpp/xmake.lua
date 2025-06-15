package("mariadb-connector-cpp")

    set_homepage("https://github.com/mariadb-corporation/mariadb-connector-cpp")
    set_description("MariaDB Connector/C++ is a C++ library for connecting to MariaDB and MySQL servers.")
    set_license("LGPL-2.1")

    -- 更新的 URL 模板，移除了 'v' 前缀
    add_urls("https://github.com/mariadb-corporation/mariadb-connector-cpp/archive/refs/tags/$(version).tar.gz",
             "https://downloads.mariadb.com/Connectors/cpp/connector-cpp-$(version)/mariadb-connector-cpp-$(version)-src.tar.gz")

    -- 添加新的版本和对应的哈希值
    -- 你可以使用 `xmake sha256 <URL>` 命令来获取哈希值
    add_versions("1.1.6", "086a070183069c994bc9b0d7718e2c244793f4cd9121652431d1d8100e12d47e")
    add_versions("1.0.11", "1d9c18d0426f8d09559fec373527a296d9876793a65c26b8969b8822080a297e")

    -- 定义构建和运行时依赖
    add_deps("cmake")
    -- 核心依赖：它必须依赖于 C 连接器
    add_deps("mariadb-connector-c")
    -- Boost 依赖仍然存在
    add_deps("boost")

    -- 定义用户可配置的选项
    add_configs("unit_tests", {description = "Build with unit tests.", default = false, type = "boolean"})
    -- SSL 支持仍然是自动从 mariadb-connector-c 继承

    on_load(function (package)
        -- 链接的库名在 1.x 版本中保持为 mariadbcpp
        package:add("links", "mariadbcpp")

        -- 提示用户需要 Boost 的 regex 和 date_time 组件
        if not package:is_used_by("self") then
            -- 明确添加对 boost 组件库的链接，以便 xmake 能够正确处理
            package:add("links", "boost_regex", "boost_date_time")
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

        -- 在新版本中，可能需要显式地告诉它 Boost 的位置，尽管 xmake 通常会自动处理。
        -- 我们可以添加一个显式的 Boost_ROOT 指向，以增加鲁棒性。
        -- local boost_dep = package:dep("boost")
        -- if boost_dep and boost_dep:installdir() then
        --     table.insert(configs, "-DBOOST_ROOT=" .. boost_dep:installdir())
        -- end

        -- 调用 CMake 工具进行安装。xmake 会自动处理依赖路径。
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        -- 测试一个核心的 C++ API 函数是否存在
        assert(package:has_cxxfuncs("sql::mariadb::get_driver_instance", {includes = "mariadb/conncpp.hpp"}))
    end)