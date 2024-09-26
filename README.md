# EncryptedStorage

![](https://img.shields.io/badge/Swift-5.4-green.svg)
![](https://img.shields.io/badge/iOS-13-green.svg)
![](https://img.shields.io/badge/macOS-10.13-green.svg)
![](https://img.shields.io/badge/license-MIT-blue.svg)

---

`EncryptedStorage` is a Swift library that allows you to securely store and retrieve encrypted data using various encryption algorithms, such as AES, Blowfish, and DES. The library provides an easy-to-use interface for storing, loading, and removing encrypted files on the local filesystem. 

## Features

- Securely store data using encryption algorithms (AES, Blowfish, DES, etc.).
- Load encrypted data with password protection.
- Remove securely stored files from the local storage.
- Pluggable cryptographic system with `CryptoProtocol`.
- Customizable encryption types (AES, Blowfish, DES, etc.).

---

## Installation

### Swift Package Manager (SPM)

To install `EncryptedStorage` using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Arashk-A/EncryptedStorage.git", from: "1.0.0")
]
```

Alternatively, you can add it directly via Xcode:

1. Open your project in Xcode.
2. Go to **File > Add Packages**.
3. Enter the repository URL: `https://github.com/your-repo/EncryptedStorage.git`.
4. Select your project and the appropriate target.

### Manual Installation

To manually include the library:

1. Clone or download the `EncryptedStorage` repository.
2. Drag and drop the `EncryptedStorage` folder into your Xcode project.
3. Make sure you have linked the necessary cryptographic libraries (e.g., `CommonCrypto`) by adding the appropriate flags in your target settings.

---

## Usage

### 1. Basic Setup

You need to configure `EncryptedStorage` with a `Crypto` provider that implements the `CryptoProtocol` for encryption and decryption.

```swift
import EncryptedStorage

// Initialize with AES encryption
let crypto = Crypto(type: .AES)
let storage = EncryptedStorage(crypto: crypto)
```

### 2. Storing Data

You can securely store data to a file using a password:

```swift
let message = "Sensitive Data".data(using: .utf8)!
let fileName = "secure_file.dat"
let password = "strongPassword123"

do {
    try storage.store(to: fileName, message: message, password: password)
    print("Data successfully stored.")
} catch {
    print("Failed to store data: \(error)")
}
```

### 3. Loading Data

To load the encrypted data from a file, use the same password that was used to store the data:

```swift
do {
    let decryptedData = try storage.load(fileName: fileName, password: password)
    let message = String(data: decryptedData, encoding: .utf8)
    print("Decrypted message: \(message ?? "")")
} catch {
    print("Failed to load data: \(error)")
}
```

### 4. Removing a File

To remove an encrypted file from local storage:

```swift
do {
    try storage.remove(fileName: fileName)
    print("File successfully removed.")
} catch {
    print("Failed to remove file: \(error)")
}
```

---

## Encryption Types

The library supports various encryption types defined in the `EncryptionType` enum:

- `.AES`
- `.Blowfish`
- `.DES`
- `.TripleDES`
- `.CAST`
- `.RC4`

You can initialize the `Crypto` class with any of these types:

```swift
let crypto = Crypto(type: .AES) // Or choose any supported type
```

---

## License

This library is available under the MIT license. See the LICENSE file for more details.

---

## Contributions

Feel free to contribute to `EncryptedStorage` by submitting issues, feature requests, or pull requests. Ensure that all new code is covered by tests, and the tests pass before submitting any pull request.
