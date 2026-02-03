//
//  CodeSnippets.swift
//  Insiderfinal
//
//  Created by krishna lodha on 12/11/25.
//

import Foundation

struct CodeSnippetStore {
    
    // Maps a unique identifier (like the news title) to the actual code block
    static let snippets: [String: String] = [
        "18 New Enhancements Powering AI, Security, and Performance With 8-Year Long Term Support": """
// Java 25 Dependency Example (Maven)
<dependency>
    <groupId>org.jsoup</groupId>
    <artifactId>jsoup</artifactId>
    <version>1.13.1</version>
</dependency>
""",
        "Apple Announces New M5 Pro and M5 Max Chips": """
// Swift Code Example: Using concurrency with M5 chips
func calculateHeavyJob() async -> Int {
    print("Starting CPU-intensive task...")
    // Simulate heavy calculation
    await Task.sleep(nanoseconds: 2_000_000_000) 
    return 42
}

Task {
    let result = await calculateHeavyJob()
    print("Job finished with result: \\(result)")
}
""",
        "GitHub Copilot X Introduces AI-Powered Chat and Voice": """
// GitHub Copilot Prompt Example
/*
 * Prompt: 
 * // Function to calculate Fibonacci sequence recursively
 */

func fibonacci(n: Int) -> Int {
    if n <= 1 {
        return n
    }
    return fibonacci(n - 1) + fibonacci(n - 2)
}
""",
        "Google Announces Gemini: Most Capable AI Model Yet": """
// Python AI/ML Setup (Gemini Context)
import tensorflow as tf
from tensorflow import keras

# Define model structure for multimodal input
model = keras.Sequential([
    keras.layers.Dense(64, activation='relu', input_shape=(input_dims,)),
    keras.layers.Dense(10, activation='softmax')
])

model.compile(optimizer='adam', loss='mse')
"""
    ]
    
    /// Retrieves a code snippet based on the full news title.
    static func getSnippet(for title: String) -> String {
        return snippets[title] ?? "// Snippet not available for this article."
    }
}
