//
//  profile.swift
//  ui_demo
//
//  Created by Andrew Welling on 3/9/25.
//
import SwiftUI
import Foundation

// implement showing user transactions below user info
struct ProfileView: View {
    let userInfo = getUserInfoFromServer()
    let transactions = getTransactionsFromServer()
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
            
            Text(userInfo.name)
                .font(.title)
            
            Text(userInfo.email)
                .foregroundColor(.gray)
            
            Text("Balance: $\(String(format: "%.2f", userInfo.balance))")
                .foregroundColor(.gray)
                .padding(.bottom, 10)

            Divider()
            
            Text("Recent Transactions")
                .font(.headline)
                .padding(.top, 5)
            
            List(transactions) { transaction in
                HStack {
                    VStack(alignment: .leading) {
                        Text(transaction.user)
                            .font(.headline)
                        Text(transaction.msg)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if !transaction.recipient { // if our user paid, add a - sign and use red
                            Text("$-\(String(format: "%.2f", transaction.amt))")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        } else { // use green and dont add - since the user was paid
                            Text("$\(String(format: "%.2f", transaction.amt))")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        Text(transaction.datetime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Profile")
    }
}

// get responses from server (or in this case locally)
struct TransactionResponse: Codable {
    var transactions: [Transaction] // note var name should match json header name containing data
}
// get messages from server (or in this case locally)
struct UserResponse: Codable {
    var user: UserInfo
}

func getTransactionsFromServer() -> [Transaction] {
    if let transactionResponse = parseJSON(fromFile: "transactions", type: TransactionResponse.self) {
        return transactionResponse.transactions
    } else {
        return []
    }
}
func getUserInfoFromServer() -> UserInfo {
    if let userResponse = parseJSON(fromFile: "user", type: UserResponse.self) {
        return userResponse.user
    } else {
        return UserInfo(id: "0", name: "", email: "", balance: 0.00)
    }
}

// a basic transaction structure
struct Transaction: Identifiable, Codable {
    let id: String // unique id of transaction
    var user: String // other user involved in the transaction
    var msg: String // message attached to the transaction
    var datetime: String
    var amt: Double // amount
    var recipient: Bool // whether the current user recieved or paid
}

// a user information structure
struct UserInfo: Identifiable, Codable {
    var id: String // unique id of user
    var name: String
    var email: String
    var balance: Double
}

