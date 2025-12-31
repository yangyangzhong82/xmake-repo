package("catalyst")
    set_license("LGPL-3.0")
    set_homepage("https://github.com/yangyangzhong82/Catalyst")

    add_urls("https://github.com/yangyangzhong82/Catalyst.git")
    add_versions("0.0.1", "3776fb611fc2b0b75a33589debaea985b0ae80e5")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)