//
//  Secrets.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import Foundation

/// Contains sensitive information such as API URLs and keys.
///
/// The `Secrets` enum stores constants for accessing external services like Supabase.
///
/// **Example:**
/// ```swift
/// let url = Secrets.apiUrl
/// let key = Secrets.apiKey
/// ```
///
/// - Warning: Do not expose this information in a production environment. Use secure storage mechanisms to safeguard sensitive data.
enum Secrets {
    /// The base URL of the Supabase API.
    static let apiUrl = URL(string: "https://tzlzckugcjusyuzqzkyl.supabase.co")!
    
    /// The API key for authenticating with the Supabase service.
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6bHpja3VnY2p1c3l1enF6a3lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0NDM4NDQsImV4cCI6MjA1MTAxOTg0NH0.gDE-E3QxfZiQYjaV0WDkv7W3gZBioTrhGOKYT9U57kk"
}
