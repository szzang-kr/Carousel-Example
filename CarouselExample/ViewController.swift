//
//  ViewController.swift
//  CarouselExample
//
//  Created by AhnSangHoon on 2021/05/27.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI Property
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Datasource
    private let dataSource: [UIColor] = [.orange, .brown, .blue, .gray, .cyan]
    private lazy var increasedDataSource: [UIColor] = {
       dataSource + dataSource + dataSource
    }()
    private var originalDataSourceCount: Int {
        dataSource.count
    }
    
    // MARK: - Control Property
    private var scrollToEnd: Bool = false
    private var scrollToBegin: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        carouselCollectionViewAttribute()
    }
    
    private func layout() {
        view.addSubview(carouselCollectionView)
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carouselCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func carouselCollectionViewAttribute() {
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(SimpleCarouselCell.self, forCellWithReuseIdentifier: SimpleCarouselCell.description())
        carouselCollectionView.backgroundColor = .white
        carouselCollectionView.isPagingEnabled = true
        
        collectionViewFlowLayout.scrollDirection = .horizontal
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carouselCollectionView.scrollToItem(at: IndexPath(item: originalDataSourceCount, section: 0),
                                            at: .centeredHorizontally,
                                            animated: false)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let beginOffset = carouselCollectionView.frame.width * CGFloat(originalDataSourceCount)
        let endOffset = carouselCollectionView.frame.width * CGFloat(originalDataSourceCount * 2 - 1)
        
        if scrollView.contentOffset.x < beginOffset && velocity.x < .zero {
            scrollToEnd = true
        } else if scrollView.contentOffset.x > endOffset && velocity.x > .zero {
            scrollToBegin = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollToBegin {
            carouselCollectionView.scrollToItem(at: IndexPath(item: originalDataSourceCount, section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToBegin.toggle()
            return
        }
        if scrollToEnd {
            carouselCollectionView.scrollToItem(at: IndexPath(item: originalDataSourceCount * 2 - 1 , section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToEnd.toggle()
            return
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return increasedDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleCarouselCell.description(), for: indexPath) as? SimpleCarouselCell else { return UICollectionViewCell() }
        cell.backgroundColor = increasedDataSource[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}


fileprivate class SimpleCarouselCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(_ content: String) {
        titleLabel.text = content
    }
}
