import PackageDescription

let package = Package(
  name: "HaCWebsite",
  targets: [
    Target(name: "HaCWebsiteLib"),
    Target(name: "HaCWebsite", dependencies: ["HaCWebsiteLib"])
  ],
  dependencies: [
    .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 6),
    .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 6),
    .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", majorVersion: 1, minor: 6)
  ]
)