//
//  ViewController.swift
//  ZoomTap
//
//  Created by techmaster on 11/4/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var ViewScroll: UIScrollView!
    var subScrollView: [UIScrollView] = []
    var photo: [UIImageView?] = []
    var pageImgs: [String] = []
    var first = false
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImgs = ["shop1-0","shop1-1","shop1-2"]
        pageController.currentPage = currentPage
        pageController.numberOfPages = pageImgs.count
        ViewScroll.minimumZoomScale = 0.5
        ViewScroll.maximumZoomScale = 2
    }

    override func viewDidLayoutSubviews() {
        if (!first) {
            first = true
            
            let pageScrollViewSize = ViewScroll.frame.size
            ViewScroll.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageImgs.count), height: 0)
            ViewScroll.contentOffset = CGPoint(x: CGFloat(currentPage) * ViewScroll.frame.size.width, y: 0)
            
            for i in 0..<pageImgs.count {
                let imgView = UIImageView(image: UIImage(named: pageImgs[i]+".jpg"))
                imgView.frame = CGRect(x: 0, y: 0, width: ViewScroll.frame.size.width, height: ViewScroll.frame.size.height)
                imgView.contentMode = .scaleAspectFit
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                
                ViewScroll.backgroundColor = UIColor.black
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg(_:)))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dblTapImg(_:)))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.require(toFail: doubleTap)
                
                photo.append(imgView)
                
                let subView = UIScrollView(frame: CGRect(x: CGFloat(i) * ViewScroll.frame.size.width, y: 0, width: ViewScroll.frame.size.width, height: ViewScroll.frame.size.height))
                
                subView.minimumZoomScale = 0.5
                subView.maximumZoomScale = 2
                subView.delegate = self
                subView.addSubview(imgView)
                subScrollView.append(subView)
                self.ViewScroll.addSubview(subView)
//                self.ViewScroll.addSubview(imgView)
            }
        }
    }

    func tapImg(_ gesture: UITapGestureRecognizer) {
        let position = gesture.location(in: photo[pageController.currentPage])
        imgScale(subScrollView[pageController.currentPage].zoomScale * 2, position)
    }
    
    func dblTapImg(_ gesture: UITapGestureRecognizer) {
        let position = gesture.location(in: photo[pageController.currentPage])
        imgScale(subScrollView[pageController.currentPage].zoomScale * 0.5, position)
    }
    
    func imgScale(_ scale: CGFloat,_ center: CGPoint) {
//        if (scale < 1.0)
//        {
//            return
//        }
        var zoomRect = CGRect()
        let scrollViewSize = ViewScroll.bounds.size
        
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        subScrollView[pageController.currentPage].zoom(to: zoomRect, animated: true)
    }
    
    @IBAction func onChange(_ sender: UIPageControl) {
        ViewScroll.contentOffset = CGPoint(x: CGFloat(pageController.currentPage) * ViewScroll.frame.size.width, y: 0)
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if currentPage == (pageImgs.count-1) {
            currentPage = 0
        } else {
            currentPage += 1
        }
        ViewScroll.contentOffset = CGPoint(x: CGFloat(currentPage) * ViewScroll.frame.size.width, y: 0)
    }
    
    @IBAction func prevBtn(_ sender: UIButton) {
        if currentPage == 0 {
            currentPage = pageImgs.count - 1
        } else {
            currentPage -= 1
        }
        ViewScroll.contentOffset = CGPoint(x: CGFloat(currentPage) * ViewScroll.frame.size.width, y: 0)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo[pageController.currentPage]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((self.ViewScroll.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        if (pageController.currentPage != page) {
            pageController.currentPage = page
        }
    }
}

