//
//  GithubCell.swift
//  github
//
//  Created by Harry on 2022/03/27.
//

import UIKit
import RxSwift
import Kingfisher

class GithubCell: UITableViewCell {

    enum ButtonState {
        case normal
        case selected
        case hidden
    }

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var starButton: UIButton!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setItem(avatarURL: String?, name: String?, buttonState: ButtonState) {
        profileImage.kf.setImage(with: URL(string: avatarURL ?? ""))
        nameLabel.text = name ?? ""


        switch buttonState {
        case .normal:
            starButton.isHidden = false

            starButton.setAttributedTitle(
                .init(string: "☆", attributes: [.font: UIFont.systemFont(ofSize: 40)]), for: .normal)
            starButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .selected:
            starButton.isHidden = false
            starButton.setAttributedTitle(
                .init(string: "★", attributes: [.font: UIFont.systemFont(ofSize: 40)]), for: .normal)
            starButton.tintColor = #colorLiteral(red: 1, green: 0.8350377679, blue: 0, alpha: 1)
        case .hidden:
            starButton.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
