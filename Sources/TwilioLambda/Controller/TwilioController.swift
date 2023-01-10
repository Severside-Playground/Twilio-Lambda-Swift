//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents

final class TwilioController {
  static func route(context: LambdaContext, routeKey: String, input: TwilioLambdaInput) async -> APIGatewayV2Response {
    context.logger.info("Trying to route: \(routeKey)")
    switch routeKey {
    case "POST /twilio/text", "ANY /twilio/text":
      let result = await TwilioService().sendSMS(context: context, message: input.message, phoneNumber: input.phoneNumber)
      switch result {
      case .success(let response):
        return TwilioResponseBuilder.handle(success: response)
      case .failure(let error):
        return TwilioResponseBuilder.handle(failure: error)
      }
    default:
      return TwilioResponseBuilder.handleInvalidRoute()
    }
  }
}
