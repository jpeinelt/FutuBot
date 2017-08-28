//
//  TelegramCommandsController.swift
//  App
//
//  Created by Julius Peinelt on 28.08.17.
//
import Vapor
import HTTP
import Foundation

final class TelegramCommandsController {

    var drop: Droplet

    init(droplet: Droplet) {
        self.drop = droplet
    }

    func handleTelegramCommand(_ req: Request) throws -> ResponseRepresentable {
        let chatID: Int = req.data["message", "chat", "id"]?.int ?? 0
        let message: String = req.data["message", "text"]?.string?.lowercased() ?? ""
        let userFirstName: String = req.data["message", "from", "first_name"]?.string ?? ""

        var response: JSON

        if message.contains("gif") {
            response = try searchGif(chatID: chatID)
        } else {
            response = try JSON(node: [
                "method": "sendMessage",
                "chat_id": chatID,
                "text": "Hallo \(userFirstName) 😅"
                ]
            )
        }
        return response
    }

    func searchGif(chatID: Int) throws -> JSON {
        let giphyResponse = try drop.client.get("https://api.giphy.com/v1/gifs/random?tag=fail+funny&api_key=<giphy_token>&limit=1")
        let gifUrl = giphyResponse.data["data"]!["image_mp4_url"]!.string!
        return try JSON(node: [
            "method": "sendVideo",
            "chat_id": chatID,
            "video": gifUrl
            ]
        )
    }
}




