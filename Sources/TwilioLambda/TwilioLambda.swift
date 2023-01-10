import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

@main
struct TwilioLambda: SimpleLambdaHandler {
  func handle(_ request: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response {
    
    context.logger.info("In the lambda - beginning request -- Body: \(request.body ?? "No body found.")")
    guard
      let requestBody = request.body,
      let input = try? JSONDecoder().decode(TwilioLambdaInput.self, from: Data(requestBody.utf8))
    else {
      return TwilioResponseBuilder.handleInvalidInput()
    }
    return await TwilioController.route(context: context, routeKey: request.routeKey, input: input)
  }
}
