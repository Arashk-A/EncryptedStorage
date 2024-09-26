//
//  EncryptedStorageTests.swift
//
//
//  Created by zero on 9/26/24.
//


import XCTest
@testable import EncryptedStorage

final class EncryptedStorageTests: XCTestCase {
  let fileName = "Storage"
  let message = "Message to be encrypted and saved".data(using: .utf8)!
  let password = "12345678"
  
  var fileManager: FileManager!
  var sut: EncryptedStorage!
  var localPath: URL!
  
  override func setUp() {
    fileManager = FileManager()
    
    localPath = LocalStoragePath.localPath(fileName).url
    sut = EncryptedStorage(crypto: Crypto(type: .AES))

  }
  
  override func tearDown() {
    
    if fileManager.fileExists(atPath: localPath.path, isDirectory: nil) {
      try! fileManager.removeItem(atPath: localPath.path)
    }
    
    sut = nil
    localPath = nil
    fileManager = nil
  }
    
  func testNoItemIsSavedOnPath() {
    XCTAssertFalse(fileManager.fileExists(atPath: localPath.path, isDirectory: nil))
  }
  
  func testStoringData_ShouldFailStoringIfFilenameIsEmpty() {
    XCTAssertThrowsError(try sut.store(to: "", message: message, password: password)) { error in
      XCTAssertEqual((error as! StorageError), StorageError.failedToSave)
    }
  }
  
  func testStoringDataToFileName() {
      try! sut.store(to: fileName, message: message, password: password)

      XCTAssertTrue(fileManager.fileExists(atPath: localPath!.path, isDirectory: nil))
  }
  
  func testLoadingData_ShouldFailLoadingIfFilenameIsEmpty() {
    XCTAssertThrowsError(try sut.load(fileName: "", password: password)) { error in
      XCTAssertEqual((error as! StorageError), StorageError.failedToLoad)
    }
  }
  
  func testLoadingData_ShouldFailIfFileDoNotExist() {
    XCTAssertThrowsError(try sut.load(fileName: fileName, password: password)) { error in
      XCTAssertEqual((error as! StorageError), StorageError.fileNotFound)
    }
  }
  
  func testLoadingData() {
      try! sut.store(to: fileName, message: message, password: password)
      
      let savedData = try! sut.load(fileName: fileName, password: password)
      let savedMessage = String(data: savedData, encoding: .utf8)
      
      XCTAssertEqual(savedMessage, "Message to be encrypted and saved")
  }
  
  func testRemoveData() {
    let isCreated = fileManager.createFile(atPath: localPath.path, contents: nil)
    XCTAssertTrue(isCreated)
    
    try! sut.remove(fileName: fileName)
    XCTAssertFalse(fileManager.fileExists(atPath: localPath.path, isDirectory: nil))
  }
  
  func testPerformanceForStorage() {
    self.measure {
      try! sut.store(to: fileName, message: message, password: password)
    }
  }
  
  func testPerformanceForRetrievingData() {
    self.measure {
      testLoadingData()
    }
  }
}
