//
//  YHImagePickerController.swift
//  YHImagePicker
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "YHPickerCell"
private let kSelectImageMaxCount = 9

class YHImagePickerController: UICollectionViewController, YHImagePickerCellDelegate {
    
    // 照片数组
    lazy var photos: [UIImage] = [UIImage]()
    private var currentIndex: Int = 0 //选中的cell Index
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.backgroundColor = UIColor.whiteColor()
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(80, 80)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        self.collectionView!.registerClass(YHImagePickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (photos.count == kSelectImageMaxCount) ? photos.count : photos.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YHImagePickerCell
        cell.delegate = self
        cell.image = indexPath.item < photos.count ? photos[indexPath.item] : nil
        return cell
    }
    
    // MARK: YHImagePickerCellDelegate Method
    private func yhImagePickerCellphotoBtnClick(cell: YHImagePickerCell) {
        print(#function)

        currentIndex = collectionView!.indexPathForCell(cell)!.item
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("不能访问照片库")
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    private func yhImagePickerCellremoverBtnClick(cell: YHImagePickerCell) {
        print(#function)
        let index = collectionView!.indexPathForCell(cell)!.item
        photos.removeAtIndex(index)
        collectionView?.reloadData()
    }

}


extension YHImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: UIImagePickerControllerDelegate Method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print(image)
        print(editingInfo)
        let  scaleImage = image.scaleImage(300)
        
        if currentIndex == photos.count {
            photos.append(scaleImage)
        } else {
            photos[currentIndex] = scaleImage
        }
        collectionView?.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("取消")
    }
}


private protocol YHImagePickerCellDelegate: NSObjectProtocol {
    
    // 添加按钮
    func yhImagePickerCellphotoBtnClick(cell: YHImagePickerCell)
    // 删除按钮
    func yhImagePickerCellremoverBtnClick(cell: YHImagePickerCell)
}


private class YHImagePickerCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
      
            if image == nil {
                photoBtn.setUpImage("compose_pic_add")
            } else {
                photoBtn.setImage(image, forState: UIControlState.Normal)
            }
            
            removeBtn.hidden = (image == nil)
        }
    }
    
    weak var delegate: YHImagePickerCellDelegate?
    
    @objc func photoBtnClick() {
        delegate?.yhImagePickerCellphotoBtnClick(self)
    }
    
    @objc func removeBtnClick() {
        delegate?.yhImagePickerCellremoverBtnClick(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(photoBtn)
        addSubview(removeBtn)
        photoBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        let dict = ["photoBtn":photoBtn, "removeBtn": removeBtn]
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[photoBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[photoBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[removeBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[removeBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        photoBtn.addTarget(self, action: #selector(photoBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        removeBtn.addTarget(self, action: #selector(removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    private lazy var photoBtn: UIButton = UIButton(imageNamed: "compose_pic_add")
    private lazy var removeBtn: UIButton = UIButton(imageNamed: "compose_photo_close")
    
}





