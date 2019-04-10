import UIKit

final fileprivate class TabsView: UIView, Themeable {
    let buttons: [UIButton]

    required init(buttons: [UIButton]) {
        self.buttons = buttons
        super.init(frame: .zero)
        let stackView = UIStackView(arrangedSubviews: buttons)
        wmf_addSubview(stackView, withConstraintsToEdgesWithInsets: UIEdgeInsets(top: 16, left: 12, bottom: 0, right: 12))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(theme: Theme) {
        for button in buttons {
            button.setTitleColor(theme.colors.secondaryText, for: .normal)
            button.tintColor = theme.colors.link
        }
    }
}

final class TabbedViewController: ViewController {
    private let viewControllers: [UIViewController & Themeable]

    private lazy var tabsView: TabsView = {
        var underlineButtons = [UnderlineButton]()
        for (index, viewController) in viewControllers.enumerated() {
            let underlineButton = UnderlineButton()
            underlineButton.setTitle(viewController.title, for: .normal)
            underlineButton.underlineHeight = 2
            underlineButton.useDefaultFont = false
            underlineButton.titleLabel?.font = UIFont.wmf_font(.body)
            underlineButton.tag = index
            underlineButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            underlineButton.addTarget(self, action: #selector(didSelectViewController(_:)), for: .touchUpInside)
            underlineButtons.append(underlineButton)
        }
        return TabsView(buttons: underlineButtons)
    }()

    init(viewControllers: [UIViewController & Themeable]) {
        self.viewControllers = viewControllers
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.displayType = .hidden
        navigationBar.addUnderNavigationBarView(tabsView)
    }

    @objc private func didSelectViewController(_ sender: UIButton) {
        print("")
    }

    // MARK: Themeable

    override func apply(theme: Theme) {
        super.apply(theme: theme)
        view.backgroundColor = theme.colors.paperBackground
        tabsView.apply(theme: theme)
    }
}