package("catalyst")
    set_license("LGPL-3.0")
    set_homepage("https://github.com/yangyangzhong82/Catalyst")

    add_urls("https://github.com/yangyangzhong82/Catalyst.git")
    add_versions("0.0.1", "205a5e0fc08f8e9f476422bfe81a81b35e8153e6")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)