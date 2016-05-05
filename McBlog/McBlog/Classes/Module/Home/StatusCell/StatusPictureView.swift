//
//  StatusPictureView.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class StatusPictureView: UICollectionView {

    private let pictureViewCellId = "pictureViewCellId"
    var status: Status? {
        didSet {
            sizeToFit()
            reloadData()
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcPictureViewSize()
    }
    
    private func calcPictureViewSize() -> CGSize {
        let itemSize = CGSizeMake(90, 90)
        let margin: CGFloat = 10
        let rowCount = 3
        pictureLayout.itemSize = itemSize
        
        let count = status?.picURLs?.count ?? 0
        
        if count == 0 {
            return CGSizeZero
        }
        
        if count == 1 {
            let size = CGSizeMake(150, 150)
            pictureLayout.itemSize = size
            return size
        }
        
        if count == 4 {
            let w = 2 * itemSize.width + margin
            return CGSizeMake(w, w)
        }
        
        let row = (count - 1)/rowCount + 1
        let w = itemSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itemSize.height * CGFloat(row) + margin * CGFloat(row - 1)
        return CGSizeMake(w, h)
    }
    
    private var pictureLayout = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        backgroundColor = UIColor.whiteColor()
        self.dataSource = self
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: pictureViewCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension StatusPictureView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pic_urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let pictureCell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureViewCellId, forIndexPath: indexPath) as! PictureViewCell
        pictureCell.picUrl = status!.picURLs![indexPath.item]
        return pictureCell
    }
}

class PictureViewCell: UICollectionViewCell {
    
    var picUrl: NSURL? {
        didSet {
            pictureImageView.sd_setImageWithURL(picUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(pictureImageView)
        pictureImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private lazy var pictureImageView: UIImageView = UIImageView()
}



