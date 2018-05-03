//
//  ReactionGridPresenter.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit
import DeepDiff

public final class ReactionGridPresenter: NSObject {
    private weak var _view: ReactionGridViewInput?
    private var _interactor: ReactionGridInteractorInput
    private var _router: ReactionGridRouterInput
    
    private var _gridView: UICollectionView? {
        return _view?.gridView
    }
    private var _gridViewModels: [ReactionGridViewModel] = []
    
    public init(view: ReactionGridViewInput,
                interactor: ReactionGridInteractorInput,
                router: ReactionGridRouterInput) {
        _view = view
        _interactor = interactor
        _router = router
    }
    
    private func _setup() {
        let customTabBarItem = UITabBarItem(title: "Grid",
                                            image: nil,
                                            selectedImage: nil)
        _view?.setTabBarItem(customTabBarItem, navigationBarTitle: "Reaction Grid")
        _gridView?.register(ReactionGridCell.nib,
                            forCellWithReuseIdentifier: ReactionGridCell.identifier)
        _gridView?.dataSource = self
        _gridView?.delegate = self
    }
}

extension ReactionGridPresenter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ReactionGridPresenter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _gridViewModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionGridCell.identifier, for: indexPath) as! ReactionGridCell
        guard indexPath.row < _gridViewModels.count else {
            return cell
        }
        let reaction = _gridViewModels[indexPath.row]
        if let image = reaction.thumbnail {
            cell.thumbnail.image = image
        } else {
            _interactor.downloadThumbnail(id: reaction.id)
        }
        return cell
    }
}

extension ReactionGridPresenter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < _gridViewModels.count else {
            return
        }
        let reaction = _gridViewModels[indexPath.row]
        _interactor.cancelDownload(id: reaction.id)
    }
}

extension ReactionGridPresenter: ReactionGridViewOutput {
    public func handleViewDidAppear() {
        _interactor.observeReactions()
    }
    
    public func handleViewDidDisappear() {
        _interactor.stopObservingReactions()
    }
    
    public func handleViewDidLoad() {
        self._setup()
    }
}

extension ReactionGridPresenter: ReactionGridInteractorOutput {
    public func update(withThumbnail thumbnail: UIImage,
                       forID id: String) {
        if let index = _gridViewModels.index(where: { $0.id == id }) {
            _gridViewModels[index].thumbnail = thumbnail
            
            if let cell = _gridView?.cellForItem(at: IndexPath(row: index, section: 0)) as? ReactionGridCell {
                cell.thumbnail.image = thumbnail
            }
        }
    }
    
    public func update(withReactions reactions: [ReactionGridViewModel]) {
        let newViewModels = reactions.sorted { (lhs, rhs) -> Bool in
            lhs.id < rhs.id
        }
        let changes = diff(old: _gridViewModels, new: newViewModels)
        _gridViewModels = newViewModels
        _gridView?.reload(changes: changes, completion: { (finished) in
            //no-op
        })
    }
}
