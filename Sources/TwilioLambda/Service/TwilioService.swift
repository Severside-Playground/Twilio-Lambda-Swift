//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/9/23.
//

import Foundation
import AsyncHTTPClient
import AWSLambdaRuntime
import AWSLambdaEvents
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif


final class TwilioService {
  public  func sendSMS(context: LambdaContext, message: String, phoneNumber: String) async -> Result<TwilioResponse, TwilioLambdaError>{

    let envVars = EnvironmentVariableHelper.getEnvironmentVariables()
    
    guard
      let urlBase = envVars["twilioBaseURL"],
      let accountSID = envVars["twilioSID"],
      let authToken = envVars["twilioAuthToken"],
      let twilioPhoneNumber = envVars["twilioPhoneNumber"]
    else {
      return .failure(TwilioLambdaError.catastrophic(message: "Missing necessary environment variables"))
    }
    
    let urlString = "\(urlBase)/Accounts/\(accountSID)/Messages.json"    
    
    let requestBodyString = "From=\(twilioPhoneNumber)&To=\(phoneNumber)&Body=\(message)"
    
    guard
      let requestEncoded = requestBodyString.data(using: .utf8)
    else {
      return .failure(TwilioLambdaError.catastrophic(message: "Cant make a URL"))
    }
    
    // Create HTTP Client
    let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
    var request: HTTPClientRequest = .init(url: urlString)
    request.method = .POST
    
    request.body = .bytes(requestEncoded)
    
    let encodedAuthInfo = String(format: "%@:%@", accountSID, authToken)
              .data(using: String.Encoding.utf8)!
              .base64EncodedString()
    request.headers.add(name: "Authorization", value: "Basic \(encodedAuthInfo)")
    request.headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
    
    guard
      let responseObject = await makeRequest(context: context, request: request)
    else {
      try? await httpClient.shutdown()
      return .failure(TwilioLambdaError.catastrophic(message: "Invalid response from Twilio"))
    }
    try? await httpClient.shutdown()
    return .success(responseObject)
  }
  
  private func makeRequest(context: LambdaContext, request: HTTPClientRequest) async -> TwilioResponse? {
    let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)

    do {
      let response = try await httpClient.execute(request, timeout: .seconds(30))
      try? await httpClient.shutdown()
      context.logger.info("Request MADE to : \(request.url)")
      guard var body = try? await response.body.collect(upTo: 1024 * 1024) else {
        context.logger.info("Nothing in body")
        return nil
      }
  
      guard
        let responseBody = body.readString(length: body.writerIndex, encoding: .utf8),
        let responseData = responseBody.data(using: .utf8)
      else {
        context.logger.info("couldn't read from body as a string")
        return nil
      }
      context.logger.info("Response Body is to : \(responseBody)")
      let result = try JSONDecoder().decode(TwilioResponse.self, from: responseData)
      context.logger.info("Created the response object!")
      return result
    } catch {
      try? await httpClient.shutdown()
      return nil
    }
  }
 }
