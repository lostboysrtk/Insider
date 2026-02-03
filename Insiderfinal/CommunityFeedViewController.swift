//
//  CommunityFeedViewController.swift
//  Insiderfinal
//
//  Created by Krishna Lodha on 11/11/25.
//

import UIKit

class CommunityFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discussions"
        label.font = .boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let replyChart: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let startedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Started By Me", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let joinedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Joined By Me", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Most Recent ▼"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Data
    private let posts: [CommunityPost] = [
        CommunityPost(title: "Released Java 25", desc: "Will the new AI capabilities shift how Java is used in ML/AI space, or does Python still dominate?"),
        CommunityPost(title: "Apple's new M-series chip is out!", desc: "Will this reshape the laptop market, or is it just incremental progress?"),
        CommunityPost(title: "Startup X raised record funding", desc: "Is remote work here to stay, or will we see a shift back to office culture?")
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        [titleLabel, replyChart, startedButton, joinedButton, filterLabel, tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(CommunityPostCell.self, forCellReuseIdentifier: "CommunityPostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            replyChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            replyChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            replyChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            replyChart.heightAnchor.constraint(equalToConstant: 120),
            
            startedButton.topAnchor.constraint(equalTo: replyChart.bottomAnchor, constant: 16),
            startedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startedButton.widthAnchor.constraint(equalToConstant: 140),
            startedButton.heightAnchor.constraint(equalToConstant: 36),
            
            joinedButton.centerYAnchor.constraint(equalTo: startedButton.centerYAnchor),
            joinedButton.leadingAnchor.constraint(equalTo: startedButton.trailingAnchor, constant: 10),
            joinedButton.widthAnchor.constraint(equalToConstant: 140),
            joinedButton.heightAnchor.constraint(equalToConstant: 36),
            
            filterLabel.topAnchor.constraint(equalTo: startedButton.bottomAnchor, constant: 24),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityPostCell", for: indexPath) as! CommunityPostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}
