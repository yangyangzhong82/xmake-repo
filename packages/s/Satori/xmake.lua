package("Satori")

    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK for event recording.")
    add_urls("https://github.com/yangyangzhong82/Satori-Release.git", {alias = "git"})

    add_versions("0.0.1", "f1be82287019ef0321d601500effcaa3d653e814d095286f011d8118c31d66a5")

    add_deps("nlohmann_json")

    on_install(function (package)
        os.cp("SDK/.", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("recordPlayerEvent", {includes = "SatoriSDK.hpp"}))
    end)
