//
//  EncryptManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 12/2/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import CryptoSwift

class EncryptManager {
    static let sharedInstance = EncryptManager()
    
    func aesEncrypt(_ encryStr: String, key: String, iv: String) throws -> String{
        let data = encryStr.data(using: String.Encoding.utf8)
        let enc = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(data!.bytes)
        //let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result!
    }
    
    func aesDecrypt(_ encryStr: String, key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: encryStr, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(data!.bytes)
        //let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }

}
