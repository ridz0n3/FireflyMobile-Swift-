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
    
    func aesEncrypt(encryStr: String, key: String, iv: String) throws -> String{
        let data = encryStr.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    
    func aesDecrypt(encryStr: String, key: String, iv: String) throws -> String {
        let data = NSData(base64EncodedString: encryStr, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
    }

}
