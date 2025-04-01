package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    -- on_install 不再需要显式处理路径存储，xmake 默认会解压
    -- on_install(function (package)
    -- end)

on_load(function (package)
    -- 直接在安装目录下查找 include 和 lib
    local includedir = path.join(package:installdir(), "include") -- 移除了 "SatoriSDK"
    local libdir = path.join(package:installdir(), "lib")       -- 移除了 "SatoriSDK"

    if os.isdir(includedir) then
        package:add("includedirs", includedir) -- 添加包含路径
    else
        -- 如果需要，可以添加警告或错误信息
        -- print("warning: include directory not found at " .. includedir)
    end

    if os.isdir(libdir) then
        package:add("linkdirs", libdir) -- 添加库文件搜索路径
    else
        -- print("warning: lib directory not found at " .. libdir)
    end
    package:add("links", "Satori") -- 添加要链接的库名
end)