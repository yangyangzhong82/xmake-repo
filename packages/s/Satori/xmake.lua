package("Satori")
    set_homepage("https://github.com/yangyangzhong82/Satori-Release")
    set_description("Satori SDK")

    add_urls("https://github.com/yangyangzhong82/Satori-Release/releases/download/$(version)/SatoriSDK.zip")
    add_versions("0.0.1", "28498798b7f1507fa79b13af85af370ec428c08839fe89863723d25f9df1ca75")
    
on_install(function(package)
    os.cp("*", package:installdir())
end)
