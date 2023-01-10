//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation

public struct TwilioLambdaInput: Codable {
  let message: String
  let phoneNumber: String
}
