//
//  ResourceDetailComponentCell.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

final class ResourceDetailComponentCell: UITableViewCell {
    enum SocialIcon: Int {
        case facebook, twitter, youtube
    }
    static let cellID = "ResourceDetailComponentCell"
    private var iconLinks: [Int: String] = [:]
    private lazy var stack: UIStackView = {
        let v: UIStackView = UIStackView()
        v.axis = .horizontal
        v.distribution = .fill
        v.spacing = 20
        v.alignment = .leading
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    weak var delegate: ResourceDetailsDelegate?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: ResourceDetailComponentCell.cellID)
        backgroundColor = .white
        detailTextLabel?.numberOfLines = 0

        let backgroundView = UIView()
        backgroundView.backgroundColor = .tertiaryRed
        selectedBackgroundView = backgroundView
        textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textLabel?.textColor = .primaryRed
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)

        setIconView()
    }

    func setModel(_ detailComp: DetailComponent) {
        textLabel?.text = detailComp.title.uppercased()
        detailTextLabel?.text = detailComp.text

        if let icons = detailComp.iconTypes {
            icons.forEach { icon in
                createButtonsWithSocialLinks(icon)
            }
            if stack.arrangedSubviews.count > 0 {
                let v = UIView()
                v.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                stack.addArrangedSubview(v)
            }
        }
    }

    func setIconView() {
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func createButtonsWithSocialLinks(_ socialLink: SocialIconType) {
        let btn = UIButton()
        var imgStr = ""
        switch socialLink {
            case .facebook(let v):
                iconLinks[SocialIcon.facebook.rawValue] = v
                imgStr = "facebook"
                btn.tag = SocialIcon.facebook.rawValue
            case .twitter(let v):
                iconLinks[SocialIcon.twitter.rawValue] = v
                imgStr = "twitter"
                btn.tag = SocialIcon.twitter.rawValue
            case .youtube(let v):
                iconLinks[SocialIcon.youtube.rawValue] = v
                imgStr = "youtube"
                btn.tag = SocialIcon.youtube.rawValue
        }
        if let img = UIImage(named: imgStr) {
            btn.setImage(img, for: .normal)
            btn.contentMode = .scaleAspectFit
        }

        btn.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        stack.addArrangedSubview(btn)
    }

    @objc func openLink(btn: UIButton) {
        if iconLinks.keys.contains(btn.tag) {
            delegate?.openWebBrowser(iconLinks[btn.tag]!)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
      self.layoutIfNeeded()
      var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
      if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel {
        let detailHeight = detailTextLabel.frame.size.height
        if detailTextLabel.frame.origin.x > textLabel.frame.origin.x { // style = Value1 or Value2
          let textHeight = textLabel.frame.size.height
          if (detailHeight > textHeight) {
            size.height += detailHeight - textHeight
          }
        } else { // style = Subtitle, so always add subtitle height
          size.height += detailHeight
        }
      }
      return size
    }
}

