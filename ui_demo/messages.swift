//
//  messages.swift
//  ui_demo
//
//  Created by Andrew Welling on 3/9/25.
//

import SwiftUI
import Foundation

struct MessagesView: View {
    var messages: [Message] {
        let allMessages = getMessagesFromServer() // load messages
        // below ensures only messages from unique users are shown
        var seenUserIDs = Set<String>()
        return allMessages.filter { message in
            guard !seenUserIDs.contains(message.user_id) else { return false }
            seenUserIDs.insert(message.user_id)
            return true
        }
    }
    
    var body: some View {
        NavigationView {
            List(messages) { message in
                NavigationLink(destination: MessageDetailView(message: message)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(message.author)
                                .font(.headline)
                            Text(message.msg)
                                .font(.subheadline)
                                .lineLimit(1) // Show only one line in the list
                        }
                        Spacer()
                        Text(message.datetime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Messages")
        }
    }
}



// TODO: UI elements are very unfinished
struct MessageDetailView: View {
    let message: Message
    
    var messages: [Message] {
        getAllMessagesWithUserID(userID: message.user_id)
    }
    
    var body: some View {
        VStack {
            List(messages) { msg in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(msg.msg)
                            .font(.body)
                    }
                    Spacer()
                    Text(msg.datetime)
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle(message.author)
        .padding()
    }
}

// get messages from server (or in this case locally)
struct MessageResponse: Codable {
    var messages: [Message]
}

func getMessagesFromServer() -> [Message] {
    if let messageResponse = parseJSON(fromFile: "messages", type: MessageResponse.self) {
        return messageResponse.messages
    } else {
        return []
    }
}

func getAllMessagesWithUserID(userID: String) -> [Message] {
    if let messageResponse = parseJSON(fromFile: "messages", type: MessageResponse.self) { // load all messages
        return messageResponse.messages.filter { $0.user_id == userID }
    } else {
        return []
    }
}

// a basic message structure
struct Message: Identifiable, Codable {
    let id: String // unique id of message
    let user_id: String // unique user id
    var author: String
    var msg: String
    var datetime: String
}
