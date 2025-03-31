package("Satori")

    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK for event recording.")
    add_urls("https://github.com/yangyangzhong82/Satori-Release.git", {alias = "git"})
    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/$(version)/SDK.zip", {alias = "zip"})

    add_versions("git:0.0.1", "f1be82287019ef0321d601500effcaa3d653e814d095286f011d8118c31d66a5")
    add_versions("zip:0.0.1", "0c2ff7d48a5b3c8e068afb64a01e3201f8d951049f214811fccae898e689fe70")

    add_deps("nlohmann_json")

    on_install(function (package)
        os.cp("SDK/.", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("recordPlayerEvent", {includes = "SatoriSDK.hpp"}))
    end)
