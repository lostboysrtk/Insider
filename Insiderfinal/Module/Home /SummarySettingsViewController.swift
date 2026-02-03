import UIKit

class SummarySettingsViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI Summary Settings"
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Manage your AI-generated article summaries. Summaries are cached locally to provide consistent results and reduce API usage."
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Cache Stats Card
    private let statsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cachedCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.textColor = .label
        return lbl
    }()
    
    private let oldestDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Clear Cache Button
    private let clearButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Clear All Cached Summaries", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    // Info Card
    private let infoCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let infoTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "💡 How it works"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    private let infoBodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        • Summaries are generated once using Grok AI
        • Results are stored locally on your device
        • Cached summaries remain consistent across app restarts
        • Clear cache to regenerate all summaries
        """
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCacheStats()
        
        clearButton.addTarget(self, action: #selector(clearCacheTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCacheStats()
    }
    
    private func setupUI() {
        title = "Summary Settings"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        // Add header
        contentStack.addArrangedSubview(headerLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        
        // Setup stats card
        statsCard.addSubview(statsStack)
        statsStack.addArrangedSubview(cachedCountLabel)
        statsStack.addArrangedSubview(oldestDateLabel)
        contentStack.addArrangedSubview(statsCard)
        
        // Add clear button
        contentStack.addArrangedSubview(clearButton)
        
        // Setup info card
        infoCard.addSubview(infoStack)
        infoStack.addArrangedSubview(infoTitleLabel)
        infoStack.addArrangedSubview(infoBodyLabel)
        contentStack.addArrangedSubview(infoCard)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            statsStack.topAnchor.constraint(equalTo: statsCard.topAnchor),
            statsStack.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),
            statsStack.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor),
            
            infoStack.topAnchor.constraint(equalTo: infoCard.topAnchor),
            infoStack.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor),
            infoStack.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor)
        ])
    }
    
    private func updateCacheStats() {
        let info = GrokAIService.shared.getCacheInfo()
        
        cachedCountLabel.text = "📦 Cached Summaries: \(info.count)"
        
        if let oldest = info.oldestDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            oldestDateLabel.text = "Oldest cache entry: \(formatter.string(from: oldest))"
        } else {
            oldestDateLabel.text = "No cached summaries yet"
        }
    }
    
    @objc private func clearCacheTapped() {
        let alert = UIAlertController(
            title: "Clear Cache?",
            message: "This will remove all cached AI summaries. New summaries will be generated when you view articles again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            GrokAIService.shared.clearCache()
            self?.updateCacheStats()
            
            // Show success message
            let successAlert = UIAlertController(
                title: "Cache Cleared",
                message: "All cached summaries have been removed.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
}
