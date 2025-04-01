package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    on_install(function (package)
        if os.isdir("include") then
            os.cp("*", package:installdir())
        elseif os.isdir("lib") then
            os.cp("*", package:installdir())
        else
            assert(false, "no include or bin")
        end
    end)

    on_load(function (package)
        -- 添加头文件搜索路径
        package:add("includedirs", package:installdir("include"))
        -- 添加库文件搜索路径
        package:add("linkdirs", package:installdir("lib"))
        -- 添加需要链接的库名（xmake 会自动处理 .lib 后缀）
        package:add("links", "Satori")
    end)
