package("czmoney")
    add_urls("https://github.com/yangyangzhong82/czmoney/releases/download/$(version)/czmoney-windows-x64.zip")
    add_versions("0.0.3", "88695a7abc7335563470db87f1714ac7ce146c9dc938050787acbdcc7bf2f6eb")

    on_install(function (package)
        os.cp("include", package:installdir())
        os.cp("lib/*.lib", package:installdir("lib"))
    end)