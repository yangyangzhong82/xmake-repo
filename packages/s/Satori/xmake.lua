package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    on_install( function (package)
    local srcdir = package:sourcedir()
    print("Source directory (package:sourcedir()): ", srcdir)

    if srcdir then
        local include_satori_path = path.join(srcdir, "include", "Satori")
        local lib_satori_path = path.join(srcdir, "lib", "Satori.lib")

        print("Attempting to find source header dir: ", include_satori_path)
        print("Attempting to find source lib file: ", lib_satori_path)

        -- 检查路径是否存在
        print("Does include/Satori exist? ", os.isdir(include_satori_path))
        print("Does lib/Satori.lib exist? ", os.isfile(lib_satori_path))

        -- 暂时注释掉复制操作来调试
        -- os.cp(include_satori_path, package:installdir("include"))
        -- os.cp(lib_satori_path, package:installdir("lib"))
    else
        print("Error: package:sourcedir() returned nil or empty!")
    end
    -- 可以加一句 error() 强制停止安装过程，方便看输出
    error("Stopping install for debug purposes")
end)

    on_load("windows", function (package)
        -- 添加头文件搜索路径
        package:add("includedirs", package:installdir("include"))
        -- 添加库文件搜索路径
        package:add("linkdirs", package:installdir("lib"))
        -- 添加需要链接的库名（xmake 会自动处理 .lib 后缀）
        package:add("links", "Satori")
    end)
