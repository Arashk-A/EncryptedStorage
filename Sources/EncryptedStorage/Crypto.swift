//
//  Crypto.swift
//
//
//  Created by zero on 9/26/24.
//

import Foundation
import CommonCrypto

public protocol CryptoProtocol {
  func encrypt(message: Data, key: String) throws -> String
  func decrypt(message: String, key: String) throws -> Data
}

public enum CryptoError: Error {
  case failedToEncodeParams
  case encryptionFailed
  case failedToDecodeParams
  case decryptionFailed
}

public struct Crypto: CryptoProtocol {
  let options: UInt32 = UInt32(kCCOptionPKCS7Padding)
  let type: EncryptionType
  
  public init(type: EncryptionType) {
    self.type = type
  }
  
  public func encrypt(message: Data, key: String) throws -> String {
    var numBytesEncrypted: size_t = 0
    
    guard !message.isEmpty, let keyData = key.data(using: .utf8),
          let cryptData = NSMutableData(length: message.count + type.keyLength) else {
      throw CryptoError.failedToEncodeParams
    }
    
    let cryptStatus = CCCrypt(
      UInt32(kCCEncrypt),
      type.algorithm,
      options,
      (keyData as NSData).bytes,
      type.keyLength,
      nil,
      (message as NSData).bytes,
      message.count,
      cryptData.mutableBytes,
      cryptData.length,
      &numBytesEncrypted
    )
    
    if cryptStatus == kCCSuccess {
      cryptData.length = Int(numBytesEncrypted)
      let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
      return base64cryptString
      
    } else {
      throw CryptoError.encryptionFailed
    }
  }
  
  public func decrypt(message: String, key: String) throws -> Data {
    guard !message.isEmpty, let messageData = NSData(base64Encoded: message, options: .ignoreUnknownCharacters),
          let keyData = key.data(using: .utf8),
          let cryptData = NSMutableData(length: messageData.length + type.keyLength) else {
      throw CryptoError.failedToDecodeParams
    }
    
    var numBytesEncrypted: size_t = 0
    
    let cryptStatus = CCCrypt(
      UInt32(kCCDecrypt),
      type.algorithm,
      options,
      (keyData as NSData).bytes,
      type.keyLength,
      nil,
      messageData.bytes,
      messageData.length,
      cryptData.mutableBytes,
      cryptData.length,
      &numBytesEncrypted
    )
    
    
    if cryptStatus == kCCSuccess {
      cryptData.length = Int(numBytesEncrypted)
      return cryptData as Data
    }
    
    throw CryptoError.decryptionFailed
  }
  
}

public enum EncryptionType {
  case AES
  case Blowfish
  case DES
  case TripleDES
  case CAST
  case RC4
  
  var algorithm: UInt32 {
    switch self {
      case .AES:
        UInt32(kCCAlgorithmAES)
      case .Blowfish:
        UInt32(kCCAlgorithmBlowfish)
      case .DES:
        UInt32(kCCAlgorithmDES)
      case .TripleDES:
        UInt32(kCCAlgorithm3DES)
      case .CAST:
        UInt32(kCCAlgorithmCAST)
      case .RC4:
        UInt32(kCCAlgorithmRC4)
    }
  }
  
  var keyLength: Int {
    switch self {
    case .AES:
      kCCKeySizeAES128
    case .Blowfish:
      kCCKeySizeMinBlowfish
    case .DES:
      kCCKeySizeDES
    case .TripleDES:
      kCCKeySize3DES
    case .CAST:
      kCCKeySizeMaxCAST
    case .RC4:
      kCCKeySizeMinRC4
    }
  }
  
}
