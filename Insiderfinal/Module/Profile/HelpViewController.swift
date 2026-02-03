//
//  HelpViewController.swift
//  Insiderfinal
//
//  Created by user@1 on 01/02/26.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    private var webView: WKWebView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHelpContent()
    }
    
    private func setupUI() {
        title = "Help & Support"
        view.backgroundColor = .black
        
        // Setup navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Configure WebView
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.scrollView.backgroundColor = .black
        webView.backgroundColor = .black
        webView.isOpaque = false
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup loading indicator
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadHelpContent() {
        loadingIndicator.startAnimating()
        
        let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Help & Support</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    background-color: #000000;
                    color: #ffffff;
                    padding: 20px;
                    line-height: 1.6;
                }
                
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }
                
                h1 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 10px;
                    color: #ffffff;
                }
                
                .subtitle {
                    font-size: 15px;
                    color: #8e8e93;
                    margin-bottom: 30px;
                }
                
                .search-box {
                    background: #1c1c1e;
                    border-radius: 12px;
                    padding: 12px 16px;
                    margin-bottom: 30px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                
                .search-box input {
                    background: none;
                    border: none;
                    color: #ffffff;
                    font-size: 16px;
                    flex: 1;
                    outline: none;
                }
                
                .search-box input::placeholder {
                    color: #8e8e93;
                }
                
                .section {
                    margin-bottom: 30px;
                }
                
                .section-title {
                    font-size: 13px;
                    font-weight: 700;
                    color: #8e8e93;
                    margin-bottom: 12px;
                    letter-spacing: 0.5px;
                }
                
                .card {
                    background: #1c1c1e;
                    border-radius: 16px;
                    overflow: hidden;
                    margin-bottom: 12px;
                }
                
                .faq-item {
                    padding: 18px;
                    cursor: pointer;
                    border-bottom: 0.5px solid #2c2c2e;
                }
                
                .faq-item:last-child {
                    border-bottom: none;
                }
                
                .faq-question {
                    font-size: 16px;
                    font-weight: 600;
                    color: #ffffff;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                
                .faq-question::after {
                    content: '›';
                    font-size: 24px;
                    color: #8e8e93;
                    font-weight: 300;
                }
                
                .faq-answer {
                    font-size: 15px;
                    color: #8e8e93;
                    margin-top: 10px;
                    display: none;
                    line-height: 1.5;
                }
                
                .faq-item.active .faq-answer {
                    display: block;
                }
                
                .faq-item.active .faq-question::after {
                    content: '‹';
                    transform: rotate(-90deg);
                }
                
                .contact-card {
                    background: linear-gradient(135deg, #0D7DFF 0%, #0A5FCC 100%);
                    border-radius: 16px;
                    padding: 24px;
                    text-align: center;
                    margin-top: 30px;
                }
                
                .contact-card h2 {
                    font-size: 20px;
                    font-weight: 700;
                    margin-bottom: 8px;
                }
                
                .contact-card p {
                    font-size: 15px;
                    opacity: 0.9;
                    margin-bottom: 20px;
                }
                
                .contact-button {
                    background: rgba(255, 255, 255, 0.2);
                    color: #ffffff;
                    border: none;
                    border-radius: 12px;
                    padding: 12px 24px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    backdrop-filter: blur(10px);
                }
                
                .emoji {
                    font-size: 20px;
                    margin-right: 8px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>How can we help?</h1>
                <p class="subtitle">Find answers to common questions about Insider</p>
                
                <div class="search-box">
                    <span style="color: #8e8e93;"></span>
                    <input type="text" placeholder="Search for help..." id="searchInput">
                </div>
                
                <!-- Getting Started Section -->
                <div class="section">
                    <div class="section-title">GETTING STARTED</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What is Insider?</span>
                            </div>
                            <div class="faq-answer">
                                Insider is your intelligent tech news companion that cuts through the noise. We deliver curated, relevant tech updates and discussions in bite-sized formats - helping developers stay informed without drowning in information.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How do I get started?</span>
                            </div>
                            <div class="faq-answer">
                                Simply create an account, set your preferences for the technologies you're interested in (like Swift, React, AI, etc.), and start exploring your personalized feed. You'll receive 10-15 curated posts daily based on your interests.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How does personalization work?</span>
                            </div>
                            <div class="faq-answer">
                                Your feed is tailored using ultra filters and your upvoting behavior. The more you interact with content, the better we understand your interests. You can also manually adjust your preferences in the Personalize Feed section.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Daily DeckDrop Section -->
                <div class="section">
                    <div class="section-title">DAILY DECKDROP</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What is Daily DeckDrop?</span>
                            </div>
                            <div class="faq-answer">
                                Daily DeckDrop is your main feed featuring 10-15 curated tech posts each day. Each post includes a summary of articles and tech news, similar to DevBytes, with options to like, save, upvote/downvote, and discuss.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How do discussions work?</span>
                            </div>
                            <div class="faq-answer">
                                Each post has a dedicated discussion section where you can engage with other developers. Hot topics and most-impressed comments appear at the top, making it easy to see what's trending in the community.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>Can I read the full article?</span>
                            </div>
                            <div class="faq-answer">
                                Yes! Each post includes a redirect link if you want to dive deeper into the original article or news source. We provide the summary, you decide if you want to read more.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What's the difference between likes and upvotes?</span>
                            </div>
                            <div class="faq-answer">
                                Likes show appreciation for content, while upvotes/downvotes help filter your feed. Use upvotes for content you want to see more of, and downvotes to refine what appears in your personalized feed.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- AI Chatbot Section -->
                <div class="section">
                    <div class="section-title">AI CHATBOT</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How is this chatbot different?</span>
                            </div>
                            <div class="faq-answer">
                                Our chatbot has complete knowledge of each article in your feed. Instead of reading lengthy articles, you can ask questions and get instant, accurate answers about the content - saving you time while ensuring understanding.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What can I ask the chatbot?</span>
                            </div>
                            <div class="faq-answer">
                                You can ask specific questions about any article, request clarifications, get code examples, or have general tech discussions. The chatbot can help with both article-specific queries and general tech topics.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Audio News Section -->
                <div class="section">
                    <div class="section-title">5-MIN AUDIO NEWS</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How does Audio News work?</span>
                            </div>
                            <div class="faq-answer">
                                Listen to personalized tech news summaries with play/pause controls, 10-second skip forward/back buttons, and a lyrics-style view showing the content in real-time. Choose between top 10 or 25-30 news items per day.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What is the lyrics view?</span>
                            </div>
                            <div class="faq-answer">
                                Similar to Apple Music's lyrics feature, you can follow along with a line-by-line text display of what's being narrated. Perfect for when you want to read and listen simultaneously.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>Can I go back to previous audio?</span>
                            </div>
                            <div class="faq-answer">
                                Yes! Access your audio history to replay previous news sessions. All saved audio segments are available in your listening history.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Trends Section -->
                <div class="section">
                    <div class="section-title">TRENDS</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What are Trends?</span>
                            </div>
                            <div class="faq-answer">
                                Trends show the most upvoted and discussed topics across the community. You can view global trends or India-specific trends, with ultra filters for "Need to Know" vs "Nice to Know" content.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>Are Trends personalized?</span>
                            </div>
                            <div class="faq-answer">
                                No, Trends show what's popular across all users or in your region (India). This gives you visibility into what the broader developer community is talking about, beyond your personal interests.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What are ultra filters?</span>
                            </div>
                            <div class="faq-answer">
                                Ultra filters let you categorize content as "Need to Know" (critical updates, breaking changes) or "Nice to Know" (interesting but not urgent). This helps you prioritize what to read first.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Streak Section -->
                <div class="section">
                    <div class="section-title">STREAK SYSTEM</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How do streaks work?</span>
                            </div>
                            <div class="faq-answer">
                                Build your streak by checking in daily and engaging with your DeckDrop posts. Your current streak and record appear on both your profile and home feed, motivating consistent learning.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>When does my streak reset?</span>
                            </div>
                            <div class="faq-answer">
                                Your streak continues as long as you engage with content daily. Miss a day, and your streak resets to zero, but your record (longest streak) is preserved.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>What counts as activity for streaks?</span>
                            </div>
                            <div class="faq-answer">
                                Reading through your daily posts, engaging with discussions, listening to audio news, or using the chatbot all count toward maintaining your streak. Just stay active daily!
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Account & Settings Section -->
                <div class="section">
                    <div class="section-title">ACCOUNT & SETTINGS</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How do I change my preferences?</span>
                            </div>
                            <div class="faq-answer">
                                Go to Profile > Personalize Feed to adjust your technology interests, content filters, and notification settings. Changes take effect immediately.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>Where can I find saved content?</span>
                            </div>
                            <div class="faq-answer">
                                Access all your saved posts, articles, and audio content from Profile > Saved Library. Content stays saved until you remove it.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>How do notifications work?</span>
                            </div>
                            <div class="faq-answer">
                                Enable Daily Drop Alerts in your Profile to get notified when new content is available. You can also receive notifications when someone shares content with you.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Troubleshooting Section -->
                <div class="section">
                    <div class="section-title">TROUBLESHOOTING</div>
                    <div class="card">
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>App not loading content?</span>
                            </div>
                            <div class="faq-answer">
                                Check your internet connection, then try refreshing by pulling down on the feed. If issues persist, try logging out and back in, or reinstalling the app.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji">🎵</span>Audio not playing?</span>
                            </div>
                            <div class="faq-answer">
                                Ensure your device isn't on silent mode and volume is up. Check that the app has audio permissions in Settings. Try closing and reopening the app.
                            </div>
                        </div>
                        
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span><span class="emoji"></span>Lost my streak?</span>
                            </div>
                            <div class="faq-answer">
                                Streaks require daily engagement. If you believe your streak was lost due to a technical issue, contact support with details about when you last used the app.
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Card -->
                <div class="contact-card">
                    <h2>Still need help?</h2>
                    <p>Can't find what you're looking for? Our support team is here to help.</p>
                    <button class="contact-button" onclick="contactSupport()">Contact Support</button>
                </div>
            </div>
            
            <script>
                function toggleFAQ(element) {
                    element.classList.toggle('active');
                }
                
                function contactSupport() {
                    window.webkit.messageHandlers.contactSupport.postMessage('contact');
                }
                
                // Search functionality
                document.getElementById('searchInput').addEventListener('input', function(e) {
                    const searchTerm = e.target.value.toLowerCase();
                    const faqItems = document.querySelectorAll('.faq-item');
                    
                    faqItems.forEach(item => {
                        const question = item.querySelector('.faq-question').textContent.toLowerCase();
                        const answer = item.querySelector('.faq-answer').textContent.toLowerCase();
                        
                        if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                            item.style.display = 'block';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate
extension HelpViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showErrorAlert()
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to load help content. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadHelpContent()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - WKScriptMessageHandler
extension HelpViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "contactSupport" {
            // Handle contact support action
            let alert = UIAlertController(
                title: "Contact Support",
                message: "Send us an email at support@insider.app or reach out through the app.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
