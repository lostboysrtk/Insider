import UIKit

class ProfileStatsView: UIView {
    
    private func createStatCard(title: String, value: String, subValue: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        
        let titleLabel = UILabel()
        titleLabel.text = "/// " + title.uppercased()
        titleLabel.font = .systemFont(ofSize: 9, weight: .black)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = UIColor(red: 0.0, green: 0.45, blue: 0.95, alpha: 1.0)
        
        let subLabel = UILabel()
        subLabel.text = subValue
        subLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        subLabel.textColor = .tertiaryLabel
        
        [titleLabel, valueLabel, subLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.heightAnchor.constraint(equalToConstant: 95)
        ])
        
        return view
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let streakCard = createStatCard(title: "Streak", value: "28D", subValue: "Record: 67")
        let badgeCard = createStatCard(title: "Badges", value: "12", subValue: "Top 2%")
        
        let stack = UIStackView(arrangedSubviews: [streakCard, badgeCard])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
