package("Satori")

    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    -- on_install(function (package)
    --     os.cp("include", package:installdir())
    --     os.cp("lib", package:installdir())
    -- end)
    on_install(function (package)
        -- ... (现有的文件复制逻辑) ...
        -- 探测并存储实际的 include 和 lib 目录路径
        local includedir = package:installdir("include")
        local libdir = package:installdir("lib")
        -- 处理可能的嵌套 lib 目录
        local actual_libdir = path.join(libdir, "lib")
        if os.isdir(actual_libdir) then
            libdir = actual_libdir
        end
        package:data_set("includedir", includedir)
        package:data_set("libdir", libdir)
    end)

    on_load(function (package)
        local includedir = package:data("includedir")
        local libdir = package:data("libdir")
        if includedir and os.isdir(includedir) then
            package:add("includedirs", includedir) -- 添加包含路径
        end
        if libdir and os.isdir(libdir) then
            package:add("linkdirs", libdir)       -- 添加库文件搜索路径
        end
        package:add("links", "Satori")          -- 添加要链接的库名
    end)