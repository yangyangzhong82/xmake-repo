package("czmoney")
    add_urls("https://github.com/yangyangzhong82/czmoney/releases/download/$(version)/czmoney-windows-x64.zip")
    add_versions("0.0.5", "1378552f1c3bf3d7819aaa70364f3ed763db61449db7c39c0faa0306e3b9e69a")

    on_install(function (package)
        os.cp("include", package:installdir())
        os.cp("lib/*.lib", package:installdir("lib"))
    end)