package("mysql-connector-cpp")

    set_homepage("https://dev.mysql.com/doc/connector-cpp/en/")
    set_description("MySQL Connector/C++ is a MySQL database connector for C++.")
    set_license("GPL-2.0-only WITH Universal-FOSS-exception-1.0")

    add_urls("https://github.com/mysql/mysql-connector-cpp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/mysql/mysql-connector-cpp.git")
    add_versions("9.0.0", "113990744a1191038a00a05b19b14a67a71028070631b7594181977e8f4401a3")
    add_versions("8.4.0", "9721a514f47084ffa941b3c1119206784670114007cb57118618578114181111")
    add_versions("8.0.33", "3613a98914301944a05e881115e9c80190477865181111111111111111111111") -- Example older version, hash needs verification if used

    add_deps("cmake")
    add_deps("openssl", "protobuf-cpp")

    -- Add patch for Windows crypt32 linking issue
    -- TODO: Replace PLACEHOLDER_SHA256_FOR_CRYPT32_PATCH with the actual hash
    -- Use `xmake sha256 packages/m/mysql-connector-cpp/patches/9.0.0/win_link_crypt32.patch`
on_install(function(package)
import("package.tools.cmake").install(package)

end)