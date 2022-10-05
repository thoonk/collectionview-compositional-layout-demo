//
//  PhotoCell.swift
//  CompositionalLayoutDemo
//
//  Created by thoonk on 2022/10/05.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with urlString: URL) {
        imageView.kf.setImage(with: urlString)
    }
}

private extension PhotoCell {
    func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
