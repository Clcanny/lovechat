//
//  ChatViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class ChatViewController: UIViewController {

    @IBOutlet weak var messagesView: UIView!
    
    let collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        return adapter
    }()
    
    // Subclasses can override this method as needed to perform more precise layout of their subviews.
    // You should override this method only if the autoresizing and constraint-based behaviors
    // of the subviews do not offer the behavior you want.
    // You can use your implementation to set the frame rectangles of your subviews directly.
    // 简而言之，该方法管理子控件的布局，自适应也应该写在此方法内
    func layoutSubviews() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
        messagesView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            (make) -> Void in
            make.top.left.bottom.right.equalTo(messagesView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layoutSubviews()
        adapter.performUpdates(animated: false, completion: nil)
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

extension ChatViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return ["Hello" as ListDiffable, "Hi" as ListDiffable, "Hi1" as ListDiffable, "Hi2" as ListDiffable, "Hi3" as ListDiffable, "Hi4" as ListDiffable, "Hi5" as ListDiffable, "Hi6" as ListDiffable, "Hi7" as ListDiffable, "Hi9" as ListDiffable, "Hi10" as ListDiffable, "Hi11" as ListDiffable, "Hi12" as ListDiffable, "Hi13" as ListDiffable, "Hi14" as ListDiffable, "Hi15" as ListDiffable, "Hi16" as ListDiffable, "Hi17" as ListDiffable, "Hi18" as ListDiffable, "Hi19" as ListDiffable, "Hi20" as ListDiffable, "Hi21" as ListDiffable, "Hi22" as ListDiffable, "Hi23" as ListDiffable, "Hi24" as ListDiffable, "Hi25" as ListDiffable, "Hi26" as ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return TextMessageSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
