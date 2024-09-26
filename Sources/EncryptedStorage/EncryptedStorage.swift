//
//  EncryptedStorage.swift
//
//
//  Created by zero on 9/26/24.
//

import Foundation

public protocol EncryptedStorable {
  func store(to fileName: String, message: Data, password: String) throws
  func load(fileName: String, password: String) throws -> Data
  func remove(fileName: String) throws
}

public enum StorageError: LocalizedError, Equatable {
  case unarchivedFailed
  case publicKeyISNotTheSame
  case fileNotFound
  case failedToSave
  case failedToLoad
  case failedToDelete
  case failedToEncodeSaveData
}

public struct EncryptedStorage {
  let crypto: CryptoProtocol
  
  public init(crypto: CryptoProtocol) {
    self.crypto = crypto
  }
  
  public func store(to fileName: String, message: Data, password: String) throws {
    guard !fileName.isEmpty, let path = LocalStoragePath.localPath(fileName).url else { throw StorageError.failedToSave }
    
    let saveData = try prepareData(message, password: password)
    let archiver = try NSKeyedArchiver.archivedData(withRootObject: saveData, requiringSecureCoding: true)
    try archiver.write(to: path)
  }
  
  public func load(fileName: String, password: String) throws -> Data {
    guard !fileName.isEmpty, let path = LocalStoragePath.localPath(fileName).url else { throw StorageError.failedToLoad }
    
    guard FileManager.default.fileExists(atPath: path.path, isDirectory: nil) else { throw StorageError.fileNotFound }
    
    let archivedData = try Data(contentsOf: path)
    if let archive = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSData.self, NSNumber.self], from: archivedData) as? Data {
      
      let sec = try JSONDecoder().decode(Secure.self, from: archive)
      let data = try crypto.decrypt(message: sec.message, key: password)
      return data
    } else {
      throw StorageError.unarchivedFailed
    }
    
  }
  
  
  public func remove(fileName: String) throws {
    guard !fileName.isEmpty, let path = LocalStoragePath.localPath(fileName).url else { throw StorageError.failedToLoad }
    guard FileManager.default.fileExists(atPath: path.path, isDirectory: nil) else { throw StorageError.fileNotFound }
    
    try FileManager.default.removeItem(atPath: path.path)
  }
  
  private func prepareData(_ message: Data, password: String) throws -> Data {
      let encrypt = try crypto.encrypt(message: message, key: password)
      
      let sec = Secure(message: encrypt)
      return try JSONEncoder().encode(sec)
  }
}
