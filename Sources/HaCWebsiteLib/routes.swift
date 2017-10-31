import Foundation
import Kitura
import DotEnv
import SwiftyJSON
import LoggerAPI
import HeliumLogger
import HaCTML
import Fluent
import PostgreSQLDriver

func getWebsiteRouter() -> Router {
  let router = Router()

  router.all("/", middleware: RedirectsMiddleware(redirects: [
    "/intro-to-programming": "https://github.com/hackersatcambridge/workshops/blob/master/workshops/introduction_to_programming/session_1/description.md",
    "/bash": "https://github.com/hackersatcambridge/workshops/blob/master/workshops/tools_for_programmers/01_intro_to_bash/description.md",
    "/git": "https://github.com/hackersatcambridge/git-workshop-2017"
  ]))

  router.all("/static", middleware: StaticFileServer(path: "./static/dist"))

  /// Intended for use by GitHub webhooks
  router.post("/api/refresh_workshops", handler: GitHubWebhookController.handler)

  router.get("/", handler: LandingPageController.handler)
  router.get("/workshops", handler: WorkshopsController.handler)

  // MARK: Features in progress
  router.get("/beta/landing-update-feed", handler: LandingUpdateFeedController.handler)
  router.get("/beta/workshops") { _, response, next in
    try response.send(
      UI.Pages.workshops(workshops: WorkshopManager.workshops).render()
    ).end()
    next()
  }

  router.all("/", middleware: NotFoundMiddleware())


  return router
}

public func serveWebsite() {
  testDatabase()
  // Helium logger provides logging for Kitura processes
  HeliumLogger.use()
  // This speaks to Kitura's 'LoggerAPI' to set the default logger to HeliumLogger.
  // Kitura calls this API to log things

  Kitura.addHTTPServer(onPort: Config.listeningPort, with: getWebsiteRouter())
  Kitura.run() // This call never returns
}
