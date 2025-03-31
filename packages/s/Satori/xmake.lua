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
        -- Copy contents of include and lib directories from the extracted SatoriSDK folder
        os.cp("SatoriSDK/include", package:installdir("include"))
        os.cp("SatoriSDK/lib", package:installdir("lib"))
    end)

    on_load(function (package)
        package:add("includedirs", "include")
        package:add("linkdirs", "lib")
        package:add("links", "Satori")
    end)
