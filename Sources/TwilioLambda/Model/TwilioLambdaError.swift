//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation

enum TwilioLambdaError: Error {
  case catastrophic(message: String)
  case noValidResponse(message: String)
}
