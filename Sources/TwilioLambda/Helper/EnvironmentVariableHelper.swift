//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/10/23.
//

import Foundation
struct EnvironmentVariableHelper {
  static func getEnvironmentVariables() -> [String: String] {
    var envVars: [String: String] = [:]
    for (key, value) in ProcessInfo.processInfo.environment {
      envVars[key] = value
    }
    return envVars
  }
}
