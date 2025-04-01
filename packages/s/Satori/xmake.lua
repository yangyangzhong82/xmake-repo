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
    if os.isdir("include") then
        os.cp("*", package:installdir())

-- 结束 on_install 函数的定义
end)
