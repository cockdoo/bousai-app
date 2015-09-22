////
////  ViewController.swift
////  bousai
////
////  Created by wtnv009 on 2015/08/13.
////  Copyright (c) 2015年 TaigaSano. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    var pageViewController: UIPageViewController!
//    var pageTitles: NSArray!
//    var pageImages: NSArray!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.pageTitles = NSArray(objects: "Explore", "Today Widget", "how")
//        self.pageImages = NSArray(objects: "page1", "page2", "page3")
//        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
//        
//        self.pageViewController.dataSource = self
//        var startVC = self.viewControllerAtIndex(0) as ContentViewController
//        var viewControllers = NSArray(object: startVC)
//        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
//        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
//        self.addChildViewController(self.pageViewController)
//        
//        self.view.addSubview(self.pageViewController.view)
//        
//        self.pageViewController.didMoveToParentViewController(self)
//    }
//    
//    @IBAction func restartAction(sender: AnyObject) {
//        print("A")
//        var startVC = self.viewControllerAtIndex(0) as ContentViewController
//        var viewControllers = NSArray(object: startVC)
//        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
//    }
//
//    func viewControllerAtIndex(index: Int) -> ContentViewController {
//        print("B")
//        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
//            return ContentViewController()
//        }
//        let vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
//        vc.imageFile = self.pageImages[index] as! String
//        vc.titleText = self.pageTitles[index] as! String
//        vc.pageIndex = index
//        
//        return vc
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        print("C")
//        let vc = viewController as! ContentViewController
//        var index = vc.pageIndex as Int
//        if (index == 0 || index == NSNotFound) {
//            return nil
//        }
//        index--
//        
//        return self.viewControllerAtIndex(index)
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        print("D")
//        let vc = viewController as! ContentViewController
//        var index = vc.pageIndex as Int
//        if (index == NSNotFound) {
//            
//            return nil
//        }
//        index++
//    
//        if (index == self.pageTitles.count) {
//            return nil
//        }
//        
//        return self.viewControllerAtIndex(index)
//    }
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        print("E")
//        return self.pageTitles.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        print("F")
//        return 0
//    }
//}
//
