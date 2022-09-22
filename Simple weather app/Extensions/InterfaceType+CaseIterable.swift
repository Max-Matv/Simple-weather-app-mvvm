//
//  InterfaceType+CaseIterable.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 20.Sep.22.
//

import Foundation
import Network

extension NWInterface.InterfaceType: CaseIterable {
  public static var allCases: [NWInterface.InterfaceType] = [
  .other,
  .wifi,
  .cellular,
  .loopback,
  .wiredEthernet
  ]
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}
