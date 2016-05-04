//
//  NewFeautureController.swift
//  McBlog
//
//  Created by admin on 16/4/29.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NewFeatureCell"

class NewFeautureController: UICollectionViewController {

    private let imageCount = 4
    private let yhLayout = YHFlowLayout()
    
    init() {
        super.init(collectionViewLayout: yhLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
    
        cell.index = indexPath.item
        return cell
    }

}


class NewFeatureCell: UICollectionViewCell {
    
    var index: Int = 0 {
        didSet {
            imageView.image = UIImage(named: "new_feature_\(index + 1)")
            button.hidden = !(index == 3)
            (index == 3) ? buttonAnim() : ()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        prepareUI()
    }
    
    private func prepareUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        button.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX)
            make.bottom.equalTo(contentView.snp_bottom).offset(-100)
        }
    }
    
    private func buttonAnim() {
        button.userInteractionEnabled = false
        button.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.button.transform = CGAffineTransformIdentity
            }) { (_) in
                self.button.userInteractionEnabled = true
        }
    }
    
    @objc func startButtonClick() {
        print("start")
        NSNotificationCenter.defaultCenter().postNotificationName(YHRootViewControllerSwitchNotification, object: true)
    }
    
    private lazy var imageView = UIImageView()
    private lazy var button: UIButton = {
        let button = UIButton(type: .Custom)
        
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setTitle("开始体验", forState: UIControlState.Normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(startButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
}

private class YHFlowLayout: UICollectionViewFlowLayout {
    private override func prepareLayout() {
        itemSize = collectionView!.bounds.size
        scrollDirection = .Horizontal
        minimumLineSpacing = 0
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
}





