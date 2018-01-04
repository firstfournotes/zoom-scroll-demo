//
//  ViewController.swift
//  zoom-scroll-demo-app
//
//  Created by Tetsuo Yutani on 2018/01/04.
//  Copyright © 2018 Tetsuo Yutani. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.delegate = self

        // Scale factor can be changed from 0.0 to 2.0
        scrollView.minimumZoomScale = 0.0
        scrollView.maximumZoomScale = 2.0

        imageView = UIImageView(image: UIImage(named: "sample.jpg"))
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let image = imageView.image {
            let w_scale = scrollView.frame.width / image.size.width
            let h_scale = scrollView.frame.height / image.size.height

            // Fit longer edge to screen
            // let scale = min(w_scale, h_scale)

            // Fit shorter edge to screen
            let scale = max(w_scale, h_scale)
           
            // Not zoom, only scroll
            // scrollView.minimumZoomScale = scale
            // scrollView.maximumZoomScale = scale
            
            scrollView.zoomScale = scale
            scrollView.contentSize = imageView.frame.size

            // In case that the image is larger than screen, calculate offset to show the center of image at initial launch
            let offset = CGPoint(x: (imageView.frame.width - scrollView.frame.width) / 2.0, y: (imageView.frame.height - scrollView.frame.height) / 2.0)
            scrollView.setContentOffset(offset, animated: false)

            os_log("----- viewDidLayoutSubviews")
            os_log("scale = %f", scale)
            os_log("scroll view size (%f, %f)", scrollView.frame.size.width, scrollView.frame.size.height)
            os_log("image view size (%f, %f)", imageView.frame.size.width, imageView.frame.size.height)
            os_log("content inset top: %f, left: %f, bottom: %f, right: %f", scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)
            os_log("content offset (%f, %f)", offset.x, offset.y)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        os_log("----- scrollViewDidZoom")
        
        // Keep the image at center of the screen in case that the image is smaller than the screen
        scrollView.contentInset = UIEdgeInsetsMake(
            max((scrollView.frame.height - imageView.frame.height)/2.0, 0.0),
            max((scrollView.frame.width - imageView.frame.width)/2.0, 0.0),
            0,
            0
        );
        
        os_log("scale = %f", scrollView.zoomScale)
        os_log("scroll view size (%f, %f)", scrollView.frame.size.width, scrollView.frame.size.height)
        os_log("image view size (%f, %f)", imageView.frame.size.width, imageView.frame.size.height)
        os_log("content inset top: %f, left: %f, bottom: %f, right: %f", scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

