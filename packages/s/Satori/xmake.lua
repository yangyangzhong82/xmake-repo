package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "6d86b2cfae6a978ef8164aef0c8a4a9cb1369d1dd71edcba25460fa2a94c6a0b")
    
on_install(function(package)
    os.cp("*", package:installdir())
end)
