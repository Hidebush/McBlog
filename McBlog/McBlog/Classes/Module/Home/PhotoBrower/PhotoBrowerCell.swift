//
//  PhotoBrowerCell.swift
//  McBlog
//
//  Created by admin on 16/6/3.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowerCell: UICollectionViewCell {
    
    var url: NSURL? {
        didSet {
            
            indicator.startAnimating()
            resetScrollView()
            
            imageView.image = nil
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "compose_image_placeholder"), options: SDWebImageOptions(rawValue: 10), progress: nil) { (image, error, _, _) in
                self.indicator.stopAnimating()
                if image == nil {
                    print("下载图像错误")
                    return
                }
                self.setUpImagePostion()
            }
        }
    }
    
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
    }
    
    private func setUpImagePostion() {
        let s = displayImageSize(imageView.image!)
        
        if s.height < scrollView.bounds.height {
            let y = (scrollView.bounds.size.height - s.height) * 0.5
            imageView.frame = CGRect(origin: CGPointZero, size: s)
            scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        } else {
            imageView.frame = CGRect(origin: CGPointZero, size: s)
            scrollView.contentSize = s
        }
        
    }
    
    private func displayImageSize(image: UIImage) -> CGSize {
        let scale = image.size.height / image.size.width
        let height = scale * scrollView.bounds.size.width
        return CGSizeMake(scrollView.bounds.size.width, height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicator)
        indicator.hidesWhenStopped = true
        
        scrollView.snp_makeConstraints { (make) in
            make.top.left.bottom.equalTo(contentView)
            make.right.equalTo(contentView.snp_right).offset(-20)
        }
        
        indicator.snp_makeConstraints { (make) in
            make.center.equalTo(contentView.snp_center)
        }
        
        prepareScrollView()
        layoutIfNeeded()
    }
    
    private func prepareScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        print("----------------\(scrollView)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    private lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    
}


extension PhotoBrowerCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
//        imageView.center = contentView.center
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        
        var offsexY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsexY = offsexY < 0 ? 0 : offsexY
        
        scrollView.contentInset = UIEdgeInsets(top: offsexY, left: offsetX, bottom: 0, right: 0)
        
    }
    
    
}





