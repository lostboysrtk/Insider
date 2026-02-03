import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    var webView: WKWebView!
    var urlString: String? // URL string passed from CardTableViewCell
    var progressView: UIProgressView!
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup UI
        setupWebView()
        setupNavigationBar()
        setupProgressView()
        setupActivityIndicator()
        
        // 2. Load URL
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Force Navigation Bar to stay visible and NOT hide on scroll
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.hidesBarsOnSwipe = false
        
        // Ensure small titles are forced even if the previous screen used large titles
        navigationItem.largeTitleDisplayMode = .never
        
        // Add observer for loading progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove observer to prevent crashes
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    // MARK: - Setup Methods
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        // Force small centered title and disable large title expansion
        navigationItem.largeTitleDisplayMode = .never
        
        // Make the bar opaque to prevent content overlap issues
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        
        // Customize the title color to Black for visibility
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Back button
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // Refresh button
        let refreshButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshButtonTapped)
        )
        
        // Safari button
        let safariButton = UIBarButtonItem(
            image: UIImage(systemName: "safari"),
            style: .plain,
            target: self,
            action: #selector(openInSafari)
        )
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [safariButton, refreshButton]
        
        // Set initial title based on the host domain
        if let urlString = urlString, let url = URL(string: urlString) {
            navigationItem.title = url.host ?? "Loading..."
        }
    }
    
    private func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .clear
        
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBlue
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func refreshButtonTapped() {
        webView.reload()
    }
    
    @objc private func openInSafari() {
        if let urlString = webView.url?.absoluteString, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - KVO Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress == 1.0 {
                UIView.animate(withDuration: 0.2) { self.progressView.alpha = 0.0 }
            } else {
                self.progressView.alpha = 1.0
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        // Update the title with the actual page title once loaded
        if let title = webView.title {
            navigationItem.title = title
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
