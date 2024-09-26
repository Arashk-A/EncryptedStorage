//
//  CryptoTest.swift
//
//
//  Created by zero on 9/26/24.
//

import XCTest
@testable import EncryptedStorage

struct TestObject: Codable, Equatable {
  let name: String
  let testSubject: String
  let summery: String
}

final class CryptoTest: XCTestCase {
  let testObject = TestObject(name: "Crypto", testSubject: "Cryptographic test case using CommonCrypto", summery: "Tests for real use cases CommonCrypto functionality to encrypt messages and decrypt them when is necessary")
  
  let encryptionKey = "qqlugcmxlngvbpyfexlimwgksdeflkwx"
  let message = "message to encrypt".data(using: .utf8)!
  
  override func setUp() {
    
  }
  
  override func tearDown() {
  }
  
  
  func testEncryption_ShouldFailWithEmptyMessage() {
    let sut = Crypto(type: EncryptionType.AES)
    let message = Data()
    
    XCTAssertThrowsError(try sut.encrypt(message: message, key: encryptionKey)) { error in
      XCTAssertEqual((error as! CryptoError), .failedToEncodeParams)
    }
    
  }
  
  func testDecryption_ShouldFailWithEmptyMessage() {
    let sut = Crypto(type: EncryptionType.AES)
    let encryptedMessage = ""
    
    XCTAssertThrowsError(try sut.decrypt(message: encryptedMessage, key: encryptionKey)) { error in
      XCTAssertEqual((error as! CryptoError), .failedToDecodeParams)
    }
    
  }
  
  // MARK: - AES
  func testAESEncryptionWithTestObject() {
    let sut = Crypto(type: EncryptionType.AES)
    let testObjectData = try! JSONEncoder().encode(testObject)
    let encrypt = try! sut.encrypt(message: testObjectData, key: encryptionKey)
    let decrypt = try! sut.decrypt(message: encrypt, key: encryptionKey)
    let decryptedTestObject = try! JSONDecoder().decode(TestObject.self, from: decrypt)
    
    XCTAssertEqual(decryptedTestObject, testObject)

  }
  
  func testAESEncryption() {
    let sut = Crypto(type: EncryptionType.AES)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    XCTAssertEqual(encrypt, "q8CyfH1oFpgJYZKFncRdLMR7ZOhCV9g05a6RIGO1USY=")
  }
  
  func testAESDecryption() {
    let sut = Crypto(type: EncryptionType.AES)
    
    let encryptedMessage = "q8CyfH1oFpgJYZKFncRdLMR7ZOhCV9g05a6RIGO1USY="
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
    
  }
  
  func testAESDecryption_ShouldFailWithWrongPassword() {
    let sut = Crypto(type: EncryptionType.AES)
    
    let encryptedMessage = "q8CyfH1oFpgJYZKFncRdLMR7ZOhCV9g05a6RIGO1USY="
    let encryptionKey = ""
    
    XCTAssertThrowsError(try sut.decrypt(message: encryptedMessage, key: encryptionKey)) { error in
      XCTAssertEqual((error as! CryptoError), .decryptionFailed)
    }
  }
  
  func testPerformanceAESEncryption() {
    let sut = Crypto(type: EncryptionType.AES)
    
    self.measure {
      _ = try! sut.encrypt(message: message, key: encryptionKey)
    }
  }
  
  func testPerformanceAESDecryption() {
    let sut = Crypto(type: EncryptionType.AES)
    
    let encryptedMessage = "q8CyfH1oFpgJYZKFncRdLMR7ZOhCV9g05a6RIGO1USY="
    
    self.measure {
      _ = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    }
  }
  
  // MARK: - Blowfish
  func testBlowfishEncryption() {
    let sut = Crypto(type: EncryptionType.Blowfish)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    
    XCTAssertEqual(encrypt, "gX2ZLZQ3MsMWJdHXhAnCzm+eHMl5zPRP")
  }
  
  func testBlowfishDecryption() {
    let sut = Crypto(type: EncryptionType.Blowfish)
    
    let encryptedMessage = "gX2ZLZQ3MsMWJdHXhAnCzm+eHMl5zPRP"
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
    
  }
  
  // MARK: - DES
  func testDESEncryption() {
    let sut = Crypto(type: EncryptionType.DES)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    
    XCTAssertEqual(encrypt, "eu/dhiMz/TX687rn6bebJ1zPMkEL7gqD")
  }
  
  func testDEShDecryption() {
    let sut = Crypto(type: EncryptionType.DES)
    
    let encryptedMessage = "eu/dhiMz/TX687rn6bebJ1zPMkEL7gqD"
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
    
  }
  
  // MARK: - TripleDES
  func testTripleDESEncryption() {
    let sut = Crypto(type: EncryptionType.TripleDES)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    XCTAssertEqual(encrypt, "wBCxgceNTN8hUwCgzj4KvP8qM8xXrn4I")
  }
  
  func testTripleDESDecryption() {
    let sut = Crypto(type: EncryptionType.TripleDES)
    
    let encryptedMessage = "wBCxgceNTN8hUwCgzj4KvP8qM8xXrn4I"
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
    
  }
  
  // MARK: - CAST
  func testCASTEncryption() {
    let sut = Crypto(type: EncryptionType.CAST)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    XCTAssertEqual(encrypt, "MfLi/1LcjbhVU5Xz5gUx3tPVP7OLibxJ")
  }
  
  func testCASTDecryption() {
    let sut = Crypto(type: EncryptionType.CAST)
    
    let encryptedMessage = "MfLi/1LcjbhVU5Xz5gUx3tPVP7OLibxJ"
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
  }
  
  // MARK: - RC4
  func testRC4Encryption() {
    let sut = Crypto(type: EncryptionType.RC4)
    
    let encrypt = try! sut.encrypt(message: message, key: encryptionKey)
    XCTAssertEqual(encrypt, "w+WO5O4ezHalqsjntmmc9FRp")
  }
  
  func testRC4Decryption() {
    let sut = Crypto(type: EncryptionType.RC4)
    
    let encryptedMessage = "w+WO5O4ezHalqsjntmmc9FRp"
    
    let decrypt = try! sut.decrypt(message: encryptedMessage, key: encryptionKey)
    let message = String(data: decrypt, encoding: .utf8)
    
    XCTAssertEqual(message, "message to encrypt")
  }
  
}
