package("Satori")

    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")
    add_deps("nlohmann_json")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")

    -- on_install(function (package)
    --     os.cp("include", package:installdir())
    --     os.cp("lib", package:installdir())
    -- end)
    on_install(function (package)
        -- 如果解压后存在 include 目录，则将其复制到安装目录下的 include 子目录
        if os.isdir("include") then
            os.cp("include", package:installdir("include"))
        end
        -- 如果解压后存在 lib 目录，则将其复制到安装目录下的 lib 子目录
        if os.isdir("lib") then
            os.cp("lib", package:installdir("lib"))
        end
        -- 如果还有其他需要复制的目录或文件（例如 bin, licenses），可以类似添加
        -- if os.isdir("bin") then
        --     os.cp("bin", package:installdir("bin"))
        -- end
        -- os.cp("LICENSE.txt", package:installdir())
    end)