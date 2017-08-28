import Vapor

extension Droplet {
    func setupRoutes() throws {
        let telegramCommandsController = TelegramCommandsController(droplet: self)

        self.post("<bot_access_token>", handler: telegramCommandsController.handleTelegramCommand)
    }
}
