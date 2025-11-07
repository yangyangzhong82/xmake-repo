package("debug_shape")
    set_license("LGPL-3.0")
    set_homepage("https://github.com/engsr6982/DebugShape")

    -- <Version, CommitHash>
    add_urls("https://github.com/engsr6982/DebugShape.git")
    add_versions("0.1.0", "5b5e740fa130985bc14c615836e2a0dda9a97e7c")
    add_versions("0.2.0", "7c337b5fd6b0c55c03010f535697655ee3d477b5")
    add_versions("0.3.0", "6de0232c33223750bf254691350acd7837c47d42")
    add_versions("0.5.0", "0efe5753632b8430e34b3f553748050f9acef3fe")
    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)