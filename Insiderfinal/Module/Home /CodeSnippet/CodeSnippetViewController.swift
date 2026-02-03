import UIKit

class CodeSnippetViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var cardContainerView: UIView!

    var newsItem: NewsItem! // Passed from previous screen

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Safely use properties now defined in NewsItem.swift
        languageLabel.text = newsItem.snippetLanguage ?? "Swift"
        codeTextView.text = newsItem.codeSnippet ?? "// No code snippet available for this news item."
    }
    
    private func setupUI() {
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.clipsToBounds = true
        
        codeTextView.isEditable = false
        codeTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        codeTextView.backgroundColor = .systemGray6
        codeTextView.layer.cornerRadius = 12
    }
}
