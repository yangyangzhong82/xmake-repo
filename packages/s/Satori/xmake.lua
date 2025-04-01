package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/0.0.1/SatoriSDK.zip")
    add_versions("0.0.1", "899c2a75715244ec8c36d22eb646a4c45a2d288341146e409471ef2862b797ae")
    
on_install(function(package)
    os.cp("*", package:installdir())
end)
