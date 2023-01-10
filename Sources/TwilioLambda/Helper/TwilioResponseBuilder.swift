//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/10/23.
//

import Foundation
import AWSLambdaEvents

struct TwilioResponseBuilder {
  static func handle(success response: TwilioResponse) -> APIGatewayV2Response {
    guard
      let jsonData = try? JSONEncoder().encode(response),
      let bodyAsString = String(data: jsonData, encoding: String.Encoding.utf8)
    else {
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: "Invalid response structure from provider"
      )
    }
    
    let apigwResponse = APIGatewayV2Response(
      statusCode: .ok,
      headers: ["content-type": "application/json"],
      body: bodyAsString
    )
    return apigwResponse
  }
  
  static func handle(failure error: TwilioLambdaError) -> APIGatewayV2Response {
    switch error {
    case .catastrophic(let message):
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: message
      )
    case .noValidResponse(let message):
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: message
      )
    }
  }
  
  static func handleInvalidRoute() -> APIGatewayV2Response {
    APIGatewayV2Response(
      statusCode: .badRequest,
      headers: ["content-type": "application/json"],
      body: "Invalid route"
    )
  }
  
  static func handleInvalidInput() -> APIGatewayV2Response {
    APIGatewayV2Response(
      statusCode: .badRequest,
      headers: ["content-type": "application/json"],
      body: "Invalid body provided"
    )
  }
}
