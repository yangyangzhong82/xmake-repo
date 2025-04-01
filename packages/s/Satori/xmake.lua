package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    on_install( function (package)
        os.cp(path.join(package:sourcedir(), "include", "Satori"), package:installdir("include"))

        -- 2. 复制库文件
        -- 将解压后的 lib/Satori.lib 文件复制到包安装目录的 lib/ 下
        -- 目标结构: <install_dir>/lib/Satori.lib
        os.cp(path.join(package:sourcedir(), "lib", "Satori.lib"), package:installdir("lib"))
    end)

    on_load("windows", function (package)
        -- 添加头文件搜索路径
        package:add("includedirs", package:installdir("include"))
        -- 添加库文件搜索路径
        package:add("linkdirs", package:installdir("lib"))
        -- 添加需要链接的库名（xmake 会自动处理 .lib 后缀）
        package:add("links", "Satori")
    end)
