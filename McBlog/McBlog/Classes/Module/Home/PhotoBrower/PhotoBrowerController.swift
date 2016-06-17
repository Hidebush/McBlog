//
//  PhotoBrowerController.swift
//  McBlog
//
//  Created by admin on 16/6/3.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SVProgressHUD

let PhotoBrowerCellResueId = "PhotoBrowerCellResueId"

class PhotoBrowerController: UIViewController {
    
    // 图片数组
    var urls: [NSURL]?
    // 选中的图片index
    var selectedIndex: Int = 0
    
    init(urls: [NSURL], index: Int) {
        self.urls = urls
        self.selectedIndex = index
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        var screenBounds = UIScreen.mainScreen().bounds
        screenBounds.size.width += 20
        view = UIView(frame: screenBounds)
        setUpUI()
    }
    
    private func setUpUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
//        collectionView.snp_makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
        
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(30)
            make.bottom.equalTo(view.snp_bottom).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(view.snp_right).offset(-50)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.width.equalTo(closeBtn.snp_width)
            make.height.equalTo(closeBtn.snp_height)
        }
        
        closeBtn.addTarget(self, action: #selector(closeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        collectionView.registerClass(PhotoBrowerCell.self, forCellWithReuseIdentifier: PhotoBrowerCellResueId)
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urls)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        var screenBounds = UIScreen.mainScreen().bounds
//        screenBounds.size.width += 20
//        view.frame = screenBounds
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        print("保存点击")
        let cell = collectionView.visibleCells().last as! PhotoBrowerCell
        print(cell)
        print(collectionView.visibleCells())
        
        guard let image = cell.imageView.image else {
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowerController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error != nil {
            print(error)
            SVProgressHUD.showErrorWithStatus("保存失败")
        } else {
            SVProgressHUD.showSuccessWithStatus("保存成功")
        }
    }

    deinit {
        print("88")
    }
    
    private lazy var collectionView = UICollectionView (frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var closeBtn: UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
    private lazy var saveBtn: UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension PhotoBrowerController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowerCellResueId, forIndexPath: indexPath) as! PhotoBrowerCell
        cell.url = urls![indexPath.item]
        
        return cell
    }
}   



