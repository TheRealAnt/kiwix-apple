//
//  BookmarkCollectionController.swift
//  Kiwix
//
//  Created by Chris Li on 1/12/17.
//  Copyright © 2017 Chris Li. All rights reserved.
//

import UIKit
import CoreData

class BookmarkCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate {

    private(set) var itemWidth: CGFloat = 0.0
    private(set) var shouldReloadCollectionView = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    var book: Book? {
        didSet {
            title = book?.title ?? "All"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureItemWidth(collectionViewWidth: collectionView.frame.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureItemWidth(collectionViewWidth: collectionView.frame.width)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureItemWidth(collectionViewWidth: CGFloat) {
        let itemsPerRow = ((collectionViewWidth - 10) / 300).rounded()
        self.itemWidth = floor((collectionViewWidth - (itemsPerRow + 1) * 10) / itemsPerRow)
    }
    
    // MARK: - UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BookmarkCollectionCell
        let article = fetchedResultController.object(at: indexPath)
        cell.titleLabel.text = article.title
        cell.snippetLabel.text = article.snippet
//        cell.thumbImageView.image 
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    var blockOperations: [BlockOperation] = []
    let managedObjectContext = AppDelegate.persistentContainer.viewContext
    lazy var fetchedResultController: NSFetchedResultsController<Article> = {
        let fetchRequest = Article.fetchRequest()
        let titleDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [titleDescriptor]
        if let book = self.book {fetchRequest.predicate = NSPredicate(format: "book == %@", book)}
        
        let cacheName = ["BookmarkFRC", self.book?.title ?? "All", Bundle.buildVersion].joined(separator: "_")
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
//        controller.delegate = self
        try? controller.performFetch()
        return controller as! NSFetchedResultsController<Article>
    }()
}

