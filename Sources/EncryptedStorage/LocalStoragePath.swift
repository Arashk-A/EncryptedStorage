//
//  File.swift
//  
//
//  Created by zero on 6/26/24.
//

import Foundation

public enum LocalStoragePath {
  case localPath(String)
  case folderPath
  
  public var url: URL? {
    switch self {
      
    case .localPath(let name):
      guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
      return url.appendingPathComponent(name)
      
    case .folderPath:
      guard let url = try? FileManager.default.url(for: .userDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
      return url
    }
  }

}
