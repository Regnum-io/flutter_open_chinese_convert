// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_open_chinese_convert",
    platforms: [.macOS("10.15")],
    products: [
        .library(name: "flutter-open-chinese-convert", targets: ["flutter_open_chinese_convert"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/ddddxxx/SwiftyOpenCC",
            revision: "1d8105a0f7199c90af722bff62728050c858e777")
    ],
    targets: [
        .target(
            name: "flutter_open_chinese_convert",
            dependencies: [
                .product(name: "OpenCC", package: "SwiftyOpenCC")
            ])
    ]
)
