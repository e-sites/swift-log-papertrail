//
//  Queue.swift
//  CocoaAsyncSocket
//
//  Created by Bas van Kuijck on 15/07/2020.
//

import Foundation

struct QueueItem {
    let message: String
    let date: Date
}

class Queue: PapertrailSocketClientDelegate {
    let socketClient: PapertrailSocketClient
    private var items: [QueueItem] = []
    
    init(socketClient: PapertrailSocketClient) {
        self.socketClient = socketClient
        socketClient.delegate = self
    }

    func add(message: String) {
        let wasEmpty = items.isEmpty
        items.append(QueueItem(message: message, date: Date()))
        if wasEmpty {
            sendMessages()
        }
    }

    private func sendMessages() {
        if !items.isEmpty, socketClient.connectionStatus == .connected {
            for item in items {
                socketClient.send(message: item.message, date: item.date)
            }
            items.removeAll()
        }
    }

    func didChangeConnectionStatus(client: PapertrailSocketClient, connectionStatus: PapertrailSocketClient.ConnectionStatus) {
        if connectionStatus == .connected {
            sendMessages()
        }
    }
}
