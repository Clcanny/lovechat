//
//  PictureMessageDetailViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/6.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class PictureMessageDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let imageView = UIImageView()
    
    public var image: UIImage?
    
    private static let maxScale: CGFloat = 5
    private static let minScale: CGFloat = 0.8
    
    @IBAction func exit(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func scale(_ sender: UIPinchGestureRecognizer) {
        let currentScale = scrollView.frame.size.width / scrollView.bounds.size.width
        var newScale = currentScale * sender.scale
        if newScale < PictureMessageDetailViewController.minScale {
            newScale = PictureMessageDetailViewController.minScale
        }
        else if newScale > PictureMessageDetailViewController.maxScale {
            newScale = PictureMessageDetailViewController.maxScale
        }
        
        if sender.state == .ended || sender.state == .changed {
            scrollView.transform = CGAffineTransform(scaleX: newScale, y: newScale);
            sender.scale = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let width = scrollView.frame.size.width
        let scaleFactor = width / image!.size.width
        let height = image!.size.height * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image!.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.contentMode = .scaleToFill
        imageView.image = newImage
        imageView.frame.size.width = width
        imageView.frame.size.height = height
        
        scrollView.addSubview(imageView)
        scrollView.contentSize = newImage!.size
        
        imageView.snp.makeConstraints {
            (make) -> Void in
            make.center.equalTo(scrollView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PictureMessageDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat) {
    }
    
}
