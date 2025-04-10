import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "Messages"

    var body: some View {
        NavigationStack {
            VStack {
                
                // start concurrent func to retrieve info from server?
                //https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
                Spacer()

                // display current page
                switch selectedTab {
                case "Messages":
                    MessagesView()
                case "Pay":
                    PaymentView()
                case "Profile":
                    ProfileView()
                default:
                    MessagesView()
                }

                //Divider()

                // the navigation menu
                HStack {
                    Button(action: { selectedTab = "Messages" }) {
                        VStack {
                            Image(systemName: "message.fill")
                            Text("Messages")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: { selectedTab = "Pay" }) {
                        VStack {
                            Image(systemName: "creditcard.fill")
                            Text("Pay")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: { selectedTab = "Profile" }) {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }
        }
    }
}

// retrieve data from server from server_responses
func retrieveData() -> serverResponse {
    return retrieveFromServer()
}

// generate the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
