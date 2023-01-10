//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation

struct TwilioRequest: Codable {
  let from: String
  let to: String
  let body: String
}
