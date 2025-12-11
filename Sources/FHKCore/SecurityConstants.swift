//
//  SecurityConstants.swift
//  FHKCore
//
//  Created by Fredy Leon on 11/12/25.
//

import Foundation

public enum SecurityConstants {
    
    /// **Obfuscation Byte:** This static field holds the single-byte key used for the XOR operation.
    /// It serves as the **root obfuscation seed** to conceal the AES-256 Symmetric Key and the GCM Nonce (IV)
    /// when they are stored in the application's binary.
    ///
    /// This technique is a defense against **static reverse engineering** (string scanning)
    /// by ensuring that critical cryptographic inputs are not stored as plain, readable data in the executable,
    /// requiring the attacker to first identify and reverse the XOR logic.
    public static let XOR_KEY: UInt8 = 0xAA
    
    
    /// **Obfuscated AES-256 Symmetric Key (Root Key):** This array holds the 32-byte (256-bit) Symmetric Key
    /// used by the `SecureKeyManager` to decrypt the application's sensitive data (e.g., the Supabase Anon Key).
    ///
    /// **Protection Mechanism:** This key is protected against static analysis by being stored in its **XOR-obfuscated** state.
    /// The bytes must be reversed using the static `XOR_KEY` during application runtime before they can be loaded
    /// into the `CryptoKit.SymmetricKey` type for the final decryption process.
    public static let OBSCURED_KEY_BYTES: [UInt8] = [
        72, 178, 244, 2, 217, 57, 174, 146, 48, 172, 94, 104, 203, 218, 179, 128,
        31, 169, 134, 83, 43, 94, 70, 216, 78, 166, 134, 222, 57, 242, 241, 132
    ]
    
    
    /// **Obfuscated GCM Nonce (Initialization Vector):** This 12-byte array holds the Initialization Vector (IV)
    /// required by the AES-256 GCM mode of operation. The IV ensures that encrypting the same plaintext
    /// with the same key yields a unique ciphertext, preventing certain cryptographic attacks.
    ///
    /// **Protection Mechanism:** Similar to the Root Key, the IV bytes are stored in an **XOR-obfuscated** state
    /// within the application binary. The `SecureKeyManager` must reverse the XOR operation at runtime
    /// to recover the pure IV before it can be used to open the `AES.GCM.SealedBox`.
    public static let OBSCURED_IV_BYTES: [UInt8] = [
        204, 87, 221, 44, 80, 186, 58, 93, 63, 45, 89, 30
    ]
    
    
    /// **Ciphertext Body (Encrypted Supabase Key):** This large array of bytes represents the actual,
    /// encrypted content of the sensitive Supabase Anon Key. This data is the output of the
    /// AES-256 GCM encryption operation.
    ///
    /// **Protection Mechanism:** This array is the core payload of the security mechanism. It is
    /// unintelligible without the correctly recovered AES Root Key and GCM Nonce (IV).
    /// It is *not* further XOR-obfuscated because it is already mathematically protected by
    /// the strong AES-256 encryption algorithm itself.
    public static let ENCRYPTED_DATA_BYTES: [UInt8] = [
        131, 39, 225, 201, 13, 227, 242, 44, 68, 222, 4, 28, 24, 229, 134, 19, 46, 77, 19, 147, 57, 20, 31, 18, 83, 138, 175, 192, 27, 8, 142, 2, 63, 42, 227, 87, 209, 67, 148, 173, 254, 146, 186, 124, 160, 165, 132, 188, 185, 112, 59, 222, 40, 219, 70, 23, 134, 92, 135, 4, 170, 216, 102, 68, 2, 27, 244, 62, 241, 38, 59, 88, 115, 234, 236, 97, 215, 193, 193, 102, 164, 127, 139, 47, 118, 80, 183, 227, 98, 15, 112, 21, 185, 179, 221, 246, 40, 47, 180, 131, 204, 185, 20, 39, 172, 19, 10, 142, 131, 139, 239, 38, 104, 85, 49, 0, 54, 103, 250, 133, 220, 52, 127, 61, 88, 31, 0, 250, 118, 65, 91, 143, 182, 46, 214, 107, 83, 177, 253, 243, 106, 64, 204, 195, 205, 217, 80, 189, 137, 56, 176, 71, 55, 250, 199, 71, 48, 78, 59, 195, 107, 130, 124, 34, 108, 87, 52, 68, 22, 69, 201, 53, 119, 85, 108, 73, 190, 50, 117, 60, 90, 156, 75, 191, 218, 216, 65, 181, 166, 247, 0, 245, 6, 39, 38, 175, 178, 230, 46, 34, 154, 114, 181, 4, 144, 202, 73, 161
    ]
    
    
    /// **Obfuscated GCM Authentication Tag:** This 16-byte array holds the cryptographic authentication tag
    /// generated during the AES-256 GCM sealing process.
    ///
    /// **Function:** The Tag serves as a critical integrity check (or digital seal). When the data is decrypted
    /// at runtime, the computed tag must exactly match this stored tag. If they do not match,
    /// it indicates that the encrypted data was tampered with, and the decryption process will fail,
    /// preventing the use of a compromised key.
    ///
    /// **Protection Mechanism:** This tag is stored in its **XOR-obfuscated** state to protect it from static analysis
    /// and to ensure the entire security package (Root Key, IV, and Tag) is equally concealed within the binary.
    public static let OBSCURED_TAG_BYTES: [UInt8] = [
        149, 25, 93, 113, 63, 210, 38, 251, 42, 89, 113, 255, 167, 27, 87, 175
    ]
}
