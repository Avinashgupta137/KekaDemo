//
//  NetworkMonitor.swift
//  DemoArticle
//
//  Created by Avinash on 04/11/24.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false {
        didSet {
            print("Network status changed. Connected: \(isConnected)")
        }
    }
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Network is connected.")
                self?.isConnected = true
            } else {
                print("Network is disconnected.")
                self?.isConnected = false
            }
        }
        monitor.start(queue: queue)
    }
}
