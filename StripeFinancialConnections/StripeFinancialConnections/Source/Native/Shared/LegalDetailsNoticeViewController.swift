//
//  LegalDetailsNoticeViewController.swift
//  StripeFinancialConnections
//
//  Created by Krisjanis Gaidis on 1/3/24.
//

import Foundation
@_spi(STP) import StripeUICore
import UIKit

final class LegalDetailsNoticeViewController: SheetViewController {

    private let legalDetailsNotice: FinancialConnectionsLegalDetailsNotice
    private let theme: FinancialConnectionsTheme
    private let didSelectUrl: (URL) -> Void

    init(
        legalDetailsNotice: FinancialConnectionsLegalDetailsNotice,
        theme: FinancialConnectionsTheme,
        didSelectUrl: @escaping (URL) -> Void
    ) {
        self.legalDetailsNotice = legalDetailsNotice
        self.theme = theme
        self.didSelectUrl = didSelectUrl
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(
            withContentView: PaneLayoutView.createContentView(
                iconView: RoundedIconView(
                    image: .imageUrl(legalDetailsNotice.icon?.default),
                    style: .circle,
                    theme: theme
                ),
                title: legalDetailsNotice.title,
                subtitle: legalDetailsNotice.subtitle,
                contentView: CreateMultiLinkView(
                    linkItems: legalDetailsNotice.body.links,
                    theme: theme,
                    didSelectURL: didSelectUrl
                ),
                isSheet: true
            ),
            footerView: PaneLayoutView.createFooterView(
                primaryButtonConfiguration: PaneLayoutView.ButtonConfiguration(
                    title: legalDetailsNotice.cta,
                    action: { [weak self] in
                        guard let self = self else { return }
                        self.dismiss(animated: true)
                    }
                ),
                secondaryButtonConfiguration: nil,
                topText: legalDetailsNotice.disclaimer,
                theme: theme,
                didSelectURL: didSelectUrl
            ).footerView
        )
    }
}

private func CreateMultiLinkView(
    linkItems: [FinancialConnectionsLegalDetailsNotice.Body.Link],
    theme: FinancialConnectionsTheme,
    didSelectURL: @escaping (URL) -> Void
) -> UIView {
    let verticalStackView = HitTestStackView()
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 16
    verticalStackView.addArrangedSubview(CreateSeparatorView())
    linkItems.forEach { linkItem in
        verticalStackView.addArrangedSubview(
            CreateSingleLinkView(
                title: linkItem.title,
                content: linkItem.content,
                theme: theme,
                didSelectURL: didSelectURL
            )
        )
        verticalStackView.addArrangedSubview(CreateSeparatorView())
    }
    return verticalStackView
}

private func CreateSingleLinkView(
    title: String,
    content: String?,
    theme: FinancialConnectionsTheme,
    didSelectURL: @escaping (URL) -> Void
) -> UIView {
    let verticalLabelStackView = HitTestStackView()
    verticalLabelStackView.axis = .vertical
    verticalLabelStackView.spacing = 0

    let titleLabelFont: FinancialConnectionsFont = .label(.largeEmphasized)
    let titleLabel = AttributedTextView(
        font: titleLabelFont,
        boldFont: titleLabelFont,
        linkFont: titleLabelFont,
        textColor: .textDefault,
        linkColor: theme.textActionColor,
        showLinkUnderline: false
    )
    titleLabel.setText(title, action: didSelectURL)
    verticalLabelStackView.addArrangedSubview(titleLabel)

    if let content = content {
        let contentFont: FinancialConnectionsFont = .label(.medium)
        let contentLabel = AttributedTextView(
            font: contentFont,
            boldFont: contentFont,
            linkFont: contentFont,
            textColor: .textSubdued,
            linkColor: theme.textActionColor,
            showLinkUnderline: false
        )
        contentLabel.setText(content, action: didSelectURL)
        verticalLabelStackView.addArrangedSubview(contentLabel)
    }

    return verticalLabelStackView
}

private func CreateSeparatorView() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = .borderDefault
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.nativeScale)
    ])
    return separatorView
}
