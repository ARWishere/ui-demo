//
//  payment.swift
//  ui_demo
//
//  Created by Andrew Welling on 3/9/25.
//

import SwiftUI
import CoreNFC

struct PaymentView: View {
    @State private var paymentMessage: String = ""
    @State private var isScanning: Bool = false
    @State private var nfcReader: NFCReader? = nil

    var body: some View {
        VStack {
            VStack {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Tap to Pay with NFC")
                    .font(.title2)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            Spacer()
            
            Text(paymentMessage)
                .padding()
            
            Button(action: {
                startNFCSession()
            }) {
                Text("Scan NFC Card")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isScanning)
            .padding(.bottom, 30)
        }
        .navigationTitle("Pay")
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func startNFCSession() {
        nfcReader = NFCReader { message in
            DispatchQueue.main.async {
                self.paymentMessage = message
                self.isScanning = false
            }
        }
        isScanning = true
        nfcReader?.beginScanning()
    }
}

// taken from Apple NFC documentation:
class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession?
    private var onMessageReceived: (String) -> Void
    
    init(onMessageReceived: @escaping (String) -> Void) {
        self.onMessageReceived = onMessageReceived
    }
    
    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            onMessageReceived("NFC is not supported on this device.")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the NFC tag."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        onMessageReceived("NFC Session Invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if let record = messages.first?.records.first, let payload = String(data: record.payload, encoding: .utf8) {
            onMessageReceived("NFC Data: \(payload)")
            // TODO: communicate payload information with banking apis
        } else {
            onMessageReceived("No valid NFC data found.")
        }
    }
}
