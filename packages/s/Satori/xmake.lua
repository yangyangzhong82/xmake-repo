package("Satori")

    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")
    add_deps("nlohmann_json")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "f7c68782136db29f503b32cff43dd0c280d8317e662407f8c46959508cf9618b")

    -- on_install(function (package)
    --     os.cp("include", package:installdir())
    --     os.cp("lib", package:installdir())
    -- end)
on_install(function (package)
    if os.isdir("include") then
        os.cp("*", package:installdir())

-- 结束 on_install 函数的定义
end)
