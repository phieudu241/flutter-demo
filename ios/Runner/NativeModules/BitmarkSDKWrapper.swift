//
//  Test.swift
//  Runner
//
//  Created by Dung Le on 2019/1/31.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import BitmarkSDK
import KeychainAccess

@objc(BitmarkSDKWrapper)
class BitmarkSDKWrapper: NSObject {
    static let accountNotFound = "Account not found in native layer"
    static var account: Account?
    
    @objc(register:)
    static func register(_ controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "bitmark.com/bitmarkSDK", binaryMessenger: controller)
        
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case "initialize":
                initialize(call, result)
                break
            case "createAccount":
                createAccount(call, result)
                break
            case "generatePhrase":
                generatePhrase(call, result)
                break
            case "tryPhrase":
                tryPhrase(call, result)
                break
            case "accountInfo":
                accountInfo(call, result)
                break
            case "authenticate":
                authenticate(call, result)
                break
            case "removeAccount":
                removeAccount(call, result)
                break
            case "issue":
                issue(call, result)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
    }
    
    @objc(initialize::)
    static func initialize(_ call: FlutterMethodCall,_ result: FlutterResult) -> Void {
        let resultStatus = "OK";
        let error: Error? = nil;

        let arguments: NSDictionary = call.arguments as! NSDictionary;
        let apiKey: String = arguments .value(forKey: "apiKey") as! String
        let network: String = arguments .value(forKey: "network") as! String
        
        BitmarkSDK.initialize(config: SDKConfig(apiToken: apiKey,
                                                network: BitmarkSDKWrapper.networkWithName(name: network),
                                                urlSession: URLSession.shared))

        let response:NSDictionary = ["status" : resultStatus, "error": error as Any]
        result(response);
    }
    
    @objc(createAccount::)
    static func createAccount(_ call: FlutterMethodCall,_ result: FlutterResult) {
        let authentication: Bool = call.arguments as! Bool;
        var resultStatus = "OK";
        var error: Error? = nil;
        do {
            let account = try Account()
            try KeychainUtil.saveCore(account.seed.core, version: BitmarkSDKWrapper.stringFromVersion(account.seed.version), authentication: authentication)
            self.account = account
        }
        catch let e {
            if let status = e as? KeychainAccess.Status,
                status == KeychainAccess.Status.userCanceled || status == KeychainAccess.Status.authFailed {
                resultStatus = "OK"
            }
            else {
                resultStatus = "Error"
                error = e;
            }
        }
        
        let response:NSDictionary = ["status" : resultStatus, "error": error as Any]
        result(response)
    }
    
    @objc(generatePhrase::)
    static func generatePhrase(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        var data: [Any]? = nil;
        
        do {
            let account = try Account()
            data = [account.accountNumber,
                      try account.getRecoverPhrase(language: .english),
                      BitmarkSDKWrapper.stringFromVersion(account.seed.version)]
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "data": data as Any, "error": error as Any]
        result(response)
    }
    
    @objc(tryPhrase::)
    static func tryPhrase(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        var data: String? = nil;
        let pharse: [String] = call.arguments as! [String]
        
        do {
            let account = try Account(recoverPhrase: pharse, language: .english)
            data = account.accountNumber;
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "data": data as Any, "error": error as Any]
        result(response)
    }
    
    @objc(accountInfo::)
    static func accountInfo(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        var data: [Any]? = nil;
        
        do {
            guard let account = self.account else {
                status = "Error"
                error = BitmarkSDKWrapper.accountNotFound;
                
                let response:NSDictionary = ["status" : status, "error": error as Any]
                result(response);
                return
            }
            
            data = [account.accountNumber,
                     try account.getRecoverPhrase(language: .english),
                     BitmarkSDKWrapper.stringFromVersion(account.seed.version)]
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "data": data as Any, "error": error as Any]
        result(response)
    }
    
    @objc(authenticate::)
    static func authenticate(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        
        do {
            let message: String = call.arguments as! String;
            guard let core = try KeychainUtil.getCore(reason: message) else {
                status = "Error"
                error = BitmarkSDKWrapper.accountNotFound;
                
                let response:NSDictionary = ["status" : status, "error": error as Any]
                result(response);
                return
            }
            
            let seed = try Seed.fromCore(core, version: KeychainUtil.getAccountVersion())
            self.account = try Account(seed: seed)
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "error": error as Any]
        result(response)
    }
    
    @objc(removeAccount::)
    static func removeAccount(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        
        do {
            try KeychainUtil.clearCore()
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "error": error as Any]
        result(response)
    }
    
    @objc(issue::)
    static func issue(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var status = "OK";
        var error: Error? = nil;
        var data: [Any]? = nil;
        
        do {
            guard let account = self.account else {
                status = "Error"
                error = BitmarkSDKWrapper.accountNotFound;
                
                let response:NSDictionary = ["status" : status, "error": error as Any]
                result(response);
                return
            }
            
            let params: [String: Any] = call.arguments as! [String: Any]
            
            guard let fileURL = params["url"] as? String,
                let name = params["property_name"] as? String,
                let metadata = params["metadata"] as? [String: String],
                let quantity = params["quantity"] as? Int else {
                    status = "Error"
                    error = "Invalid fingerprint"

                    let response:NSDictionary = ["status" : status, "error": error as Any]
                    result(response);
                    return
                }
            
            // Register asset
            var assetParams = try Asset.newRegistrationParams(name: name,
                                                              metadata: metadata)
            
            try assetParams.setFingerprint(fromFileURL: fileURL)
            try assetParams.sign(account)
            let assetId = try Asset.register(assetParams)
            
            // Issue bitmarks
            
            var issueParams = try Bitmark.newIssuanceParams(assetID: assetId,
                                                            owner: account.accountNumber,
                                                            quantity: quantity)
            try issueParams.sign(account)
            let bitmarkIds = try Bitmark.issue(issueParams)
            
            data = [bitmarkIds, assetId]
        }
        catch let e {
            status = "Error"
            error = e;
        }
        
        let response:NSDictionary = ["status" : status, "data": data as Any, "error": error as Any]
        result(response)
    }
}

extension BitmarkSDKWrapper {
    
    static func networkWithName(name: String) -> Network {
        switch(name) {
        case "livenet":
            return Network.livenet
        case "testnet":
            return Network.testnet
        default:
            return Network.livenet
        }
    }
    
    static func versionFromString(_ version: String) -> SeedVersion {
        if version == "v2" {
            return SeedVersion.v2
        } else {
            return SeedVersion.v1
        }
    }
    
    static func stringFromVersion(_ version: SeedVersion) -> String {
        switch version {
        case .v1:
            return "v1"
        case .v2:
            return "v2"
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

