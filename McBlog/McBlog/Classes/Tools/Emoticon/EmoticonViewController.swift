//
//  EmoticonViewController.swift
//  Emoticon
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

private let reuseId = "reuseId"
class EmoticonViewController: UIViewController {

    var selectedEmoticonCallBack: (emoticon: Emoticon) -> ()
    
    init(selectedEmoticon: (emoticon: Emoticon) -> ()) {
        selectedEmoticonCallBack = selectedEmoticon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    
    
    func itemClick(item: UIBarButtonItem) {
        let indexPath = NSIndexPath(forRow: 0, inSection: item.tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    private func setUpUI() {
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["toolBar": toolBar, "collectionView": collectionView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[collectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        setUpToolBar()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: reuseId)
    }
    
    private func setUpToolBar() {
        var items = [UIBarButtonItem]()
        var index = 0
        for p in packages {
            let item = UIBarButtonItem(title: p.groupName, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(itemClick))
            item.tag = index
            item.tintColor = UIColor.blackColor()
            items.append(item)
            let flexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            items.append(flexItem)
            index += 1
        }
        items.removeLast()
        toolBar.items = items
        
    }
    
    private lazy var packages = EmoticonPackage.packages()
    private lazy var toolBar = UIToolbar()
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: YHFlowLayout())
    
    private class YHFlowLayout: UICollectionViewFlowLayout {
        private override func prepareLayout() {
            let w = collectionView!.bounds.size.width/7.0
            itemSize = CGSizeMake(w, w)
            let y = (collectionView!.bounds.size.height - w * 3.0) * 0.499
            sectionInset = UIEdgeInsetsMake(y, 0, 0, 0)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            collectionView?.pagingEnabled = true
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.backgroundColor = UIColor.whiteColor()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! EmoticonCell
        cell.emotcion = packages[indexPath.section].emoticons![indexPath.item]
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        selectedEmoticonCallBack(emoticon: emoticon)
    }
    
}

private class EmoticonCell: UICollectionViewCell {
    var emotcion: Emoticon? {
        didSet {
            emoticonBtn.setImage(UIImage(contentsOfFile: emotcion!.imagePath), forState: UIControlState.Normal)
            emoticonBtn.setTitle(emotcion?.emoji, forState: UIControlState.Normal)
            
            if emotcion?.emoticonRemove == true {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emoticonBtn.frame = CGRectInset(bounds, 4, 4)
        emoticonBtn.backgroundColor = UIColor.whiteColor()
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        emoticonBtn.userInteractionEnabled = false
        contentView.addSubview(emoticonBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emoticonBtn: UIButton = UIButton()
}











