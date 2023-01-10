//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation

public struct TwilioResponse: Codable {
  let sid: String
  let body: String
  let to: String
  let from: String
}
