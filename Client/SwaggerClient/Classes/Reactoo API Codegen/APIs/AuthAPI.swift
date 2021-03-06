//
// AuthAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class AuthAPI {
    /**
     Change password
     
     - parameter requestAuthChangePassword: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func changePassword(requestAuthChangePassword: RequestAuthChangePassword, completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        changePasswordWithRequestBuilder(requestAuthChangePassword: requestAuthChangePassword).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Change password
     - POST /auth/changePassword
     - Changes user password. Returns empty response on success.
     - examples: [{output=none}]
     
     - parameter requestAuthChangePassword: (body)  

     - returns: RequestBuilder<String> 
     */
    open class func changePasswordWithRequestBuilder(requestAuthChangePassword: RequestAuthChangePassword) -> RequestBuilder<String> {
        let path = "/auth/changePassword"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthChangePassword)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Confirm forgot password
     
     - parameter requestAuthConfirmForgotPassword: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func confirmForgotPassword(requestAuthConfirmForgotPassword: RequestAuthConfirmForgotPassword, completion: @escaping ((_ data: ResponseAuthSignIn?,_ error: Error?) -> Void)) {
        confirmForgotPasswordWithRequestBuilder(requestAuthConfirmForgotPassword: requestAuthConfirmForgotPassword).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Confirm forgot password
     - POST /auth/confirmForgotPassword
     - Resets user password by providing one-time code and new password and returns new access tokens on success.
     - examples: [{contentType=application/json, example={
  "expiresIn" : 0,
  "idToken" : "idToken",
  "tokenType" : "Bearer",
  "accessToken" : "accessToken",
  "refreshToken" : "refreshToken"
}}]
     
     - parameter requestAuthConfirmForgotPassword: (body)  

     - returns: RequestBuilder<ResponseAuthSignIn> 
     */
    open class func confirmForgotPasswordWithRequestBuilder(requestAuthConfirmForgotPassword: RequestAuthConfirmForgotPassword) -> RequestBuilder<ResponseAuthSignIn> {
        let path = "/auth/confirmForgotPassword"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthConfirmForgotPassword)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignIn>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     User registration confirmation
     
     - parameter requestAuthConfirmSignUp: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func confirmSignUp(requestAuthConfirmSignUp: RequestAuthConfirmSignUp, completion: @escaping ((_ data: ResponseAuthSignIn?,_ error: Error?) -> Void)) {
        confirmSignUpWithRequestBuilder(requestAuthConfirmSignUp: requestAuthConfirmSignUp).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User registration confirmation
     - POST /auth/confirmSignUp
     - Confirms user registration by providing valid confirmation code and returns new access tokens on success.
     - examples: [{contentType=application/json, example={
  "expiresIn" : 0,
  "idToken" : "idToken",
  "tokenType" : "Bearer",
  "accessToken" : "accessToken",
  "refreshToken" : "refreshToken"
}}]
     
     - parameter requestAuthConfirmSignUp: (body)  

     - returns: RequestBuilder<ResponseAuthSignIn> 
     */
    open class func confirmSignUpWithRequestBuilder(requestAuthConfirmSignUp: RequestAuthConfirmSignUp) -> RequestBuilder<ResponseAuthSignIn> {
        let path = "/auth/confirmSignUp"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthConfirmSignUp)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignIn>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Forgot password
     
     - parameter requestAuthForgotPassword: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func forgotPassword(requestAuthForgotPassword: RequestAuthForgotPassword, completion: @escaping ((_ data: ResponseAuthSignUp?,_ error: Error?) -> Void)) {
        forgotPasswordWithRequestBuilder(requestAuthForgotPassword: requestAuthForgotPassword).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Forgot password
     - POST /auth/forgotPassword
     - Sends one-time code for resetting password via medium specified on sign-up (EMAIL or SMS).
     - examples: [{contentType=application/json, example={
  "userConfirmed" : false,
  "codeDeliveryDestination" : "codeDeliveryDestination",
  "codeDeliveryMedium" : "NONE"
}}]
     
     - parameter requestAuthForgotPassword: (body)  

     - returns: RequestBuilder<ResponseAuthSignUp> 
     */
    open class func forgotPasswordWithRequestBuilder(requestAuthForgotPassword: RequestAuthForgotPassword) -> RequestBuilder<ResponseAuthSignUp> {
        let path = "/auth/forgotPassword"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthForgotPassword)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignUp>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Refresh token sign-in
     
     - parameter requestAuthRefreshToken: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func refreshToken(requestAuthRefreshToken: RequestAuthRefreshToken, completion: @escaping ((_ data: ResponseAuthSignIn?,_ error: Error?) -> Void)) {
        refreshTokenWithRequestBuilder(requestAuthRefreshToken: requestAuthRefreshToken).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Refresh token sign-in
     - POST /auth/refreshToken
     - Signs user in with refresh token flow, returns access tokens on success.
     - examples: [{contentType=application/json, example={
  "expiresIn" : 0,
  "idToken" : "idToken",
  "tokenType" : "Bearer",
  "accessToken" : "accessToken",
  "refreshToken" : "refreshToken"
}}]
     
     - parameter requestAuthRefreshToken: (body)  

     - returns: RequestBuilder<ResponseAuthSignIn> 
     */
    open class func refreshTokenWithRequestBuilder(requestAuthRefreshToken: RequestAuthRefreshToken) -> RequestBuilder<ResponseAuthSignIn> {
        let path = "/auth/refreshToken"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthRefreshToken)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignIn>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Confirmation code resend
     
     - parameter requestAuthResendConfirmationCode: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func resendConfirmationCode(requestAuthResendConfirmationCode: RequestAuthResendConfirmationCode, completion: @escaping ((_ data: ResponseAuthSignUp?,_ error: Error?) -> Void)) {
        resendConfirmationCodeWithRequestBuilder(requestAuthResendConfirmationCode: requestAuthResendConfirmationCode).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Confirmation code resend
     - POST /auth/resendConfirmationCode
     - Resends confirmation code via medium specified on sign-up (EMAIL or SMS).
     - examples: [{contentType=application/json, example={
  "userConfirmed" : false,
  "codeDeliveryDestination" : "codeDeliveryDestination",
  "codeDeliveryMedium" : "NONE"
}}]
     
     - parameter requestAuthResendConfirmationCode: (body)  

     - returns: RequestBuilder<ResponseAuthSignUp> 
     */
    open class func resendConfirmationCodeWithRequestBuilder(requestAuthResendConfirmationCode: RequestAuthResendConfirmationCode) -> RequestBuilder<ResponseAuthSignUp> {
        let path = "/auth/resendConfirmationCode"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthResendConfirmationCode)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignUp>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     User sign-in
     
     - parameter requestAuthSignIn: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func signIn(requestAuthSignIn: RequestAuthSignIn, completion: @escaping ((_ data: ResponseAuthSignIn?,_ error: Error?) -> Void)) {
        signInWithRequestBuilder(requestAuthSignIn: requestAuthSignIn).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User sign-in
     - POST /auth/signIn
     - Signs user in with basic user password flow, returns access tokens on success.
     - examples: [{contentType=application/json, example={
  "expiresIn" : 0,
  "idToken" : "idToken",
  "tokenType" : "Bearer",
  "accessToken" : "accessToken",
  "refreshToken" : "refreshToken"
}}]
     
     - parameter requestAuthSignIn: (body)  

     - returns: RequestBuilder<ResponseAuthSignIn> 
     */
    open class func signInWithRequestBuilder(requestAuthSignIn: RequestAuthSignIn) -> RequestBuilder<ResponseAuthSignIn> {
        let path = "/auth/signIn"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthSignIn)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignIn>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     User registration
     
     - parameter requestAuthSignUp: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func signUp(requestAuthSignUp: RequestAuthSignUp, completion: @escaping ((_ data: ResponseAuthSignUp?,_ error: Error?) -> Void)) {
        signUpWithRequestBuilder(requestAuthSignUp: requestAuthSignUp).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User registration
     - POST /auth/signUp
     - Creates user in assigned Cognito user pool and primary backend database, returns confirmation code delivery details.
     - examples: [{contentType=application/json, example={
  "userConfirmed" : false,
  "codeDeliveryDestination" : "codeDeliveryDestination",
  "codeDeliveryMedium" : "NONE"
}}]
     
     - parameter requestAuthSignUp: (body)  

     - returns: RequestBuilder<ResponseAuthSignUp> 
     */
    open class func signUpWithRequestBuilder(requestAuthSignUp: RequestAuthSignUp) -> RequestBuilder<ResponseAuthSignUp> {
        let path = "/auth/signUp"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestAuthSignUp)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ResponseAuthSignUp>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Test authentication
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func testCredentials(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        testCredentialsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Test authentication
     - GET /auth/testCredentials
     - Verifies supplied idToken
     - API Key:
       - type: apiKey Authorization 
       - name: cognito-g1
     - examples: [{output=none}]

     - returns: RequestBuilder<String> 
     */
    open class func testCredentialsWithRequestBuilder() -> RequestBuilder<String> {
        let path = "/auth/testCredentials"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
