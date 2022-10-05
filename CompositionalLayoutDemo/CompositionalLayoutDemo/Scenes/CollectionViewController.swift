//
//  CollectionViewController.swift
//  CompositionalLayoutDemo
//
//  Created by thoonk on 2022/10/05.
//

import UIKit
import SnapKit

enum SectionStyle: Int {
    case grid = 0
    case nestedGroup = 1
    case Orthogonal = 2
}

final class CollectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout(style: style))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        
        return collectionView
    }()
    
    private let style: SectionStyle
    private let photoAPIService: PhotoAPIServiceProtocol
    private var photos: [PhotosResponseModel] = []
    
    init(
        style: SectionStyle,
        photoAPIService: PhotoAPIServiceProtocol = PhotoAPIService()
    ) {
        self.style = style
        self.photoAPIService = photoAPIService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension CollectionViewController {
    func setup() {
        view.backgroundColor = .white
        setupLayout()
        fetchPhotos()
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchPhotos() {
        photoAPIService.fetchPhotos { [weak self] photos, error in
            if let photos = photos {
                self?.photos = photos
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupCollectionViewLayout(style: SectionStyle) -> UICollectionViewLayout {
        switch style {
        case .grid:
            let fraction: CGFloat = 1 / 3
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(fraction))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
            
        case .nestedGroup:
            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 2)
                
                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), subitems: [leadingItem, trailingGroup])
                
                let section = NSCollectionLayoutSection(group: nestedGroup)
                
                return section
            }
            
            return layout
            
        case .Orthogonal:
            let fraction: CGFloat = 1 / 3
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(fraction))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let url = photos[indexPath.item].urls.url,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,  for: indexPath) as? PhotoCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: url)
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        fetchMorePhots(index: indexPath.item)
    }
    
    func fetchMorePhots(index: Int) {
        if index > photos.count - 6 {
            photoAPIService.fetchPhotos { [weak self] photos, error in
                guard let self = self else { return }
                if let photos = photos {
                    self.photos += photos
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
