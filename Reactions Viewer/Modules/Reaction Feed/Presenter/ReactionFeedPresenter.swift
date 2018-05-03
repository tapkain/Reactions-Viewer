//
//  ReactionFeedPresenter.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit
import DeepDiff

public final class ReactionFeedPresenter: NSObject {
    private weak var _view: ReactionFeedViewInput?
    private var _tableView: UITableView? {
        return _view?.reactionsTableView
    }
    private var _interactor: ReactionFeedInteractorInput
    private var _router: ReactionFeedRouterInput
    private var _feedViewModels: [ReactionFeedViewModel] = []
    
    public init(view: ReactionFeedViewInput,
                interactor: ReactionFeedInteractorInput,
                router: ReactionFeedRouterInput) {
        _view = view
        _interactor = interactor
        _router = router
    }
}

extension ReactionFeedPresenter: ReactionFeedInteractorOutput {
    public func update(withThumbnail thumbnail: UIImage, forID id: String) {
        if let index = _feedViewModels.index(where: { $0.id == id }) {
            _feedViewModels[index].thumbnail = thumbnail
            if let cell = _tableView?.cellForRow(at: IndexPath(row: index, section: 0)) as? ReactionCell {
                cell.thumbnail.image = thumbnail
            }
        }
    }
    
    public func update(withAvatar avatar: UIImage, forID id: String) {
        if let index = _feedViewModels.index(where: { $0.id == id }) {
            _feedViewModels[index].avatar = avatar
            if let cell = _tableView?.cellForRow(at: IndexPath(row: index, section: 0)) as? ReactionCell {
                cell.avatar.image = avatar
            }
        }
    }
    
    public func update(withReactions reactions: [ReactionFeedViewModel]) {
        DispatchQueue.main.async {
            let changes = diff(old: self._feedViewModels, new: reactions)
            self._feedViewModels = reactions
            self._tableView?.reload(changes: changes, completion: { (finished) in
                //no-op
            })
        }
    }
    
    public func update(isLoading: Bool, isFirstPage: Bool) {
        if isLoading {
            if isFirstPage {
                if let refreshControl = _tableView?.refreshControl,
                    !refreshControl.isRefreshing {
                    refreshControl.beginRefreshing()
                }
            } else {
                if let tableView = _tableView,
                    let activityIndicator = _view?.activityIndicator {
                    tableView.contentInset =
                        UIEdgeInsets(top: 0,
                                     left: 0,
                                     bottom: activityIndicator.bounds.height,
                                     right: 0)
                    activityIndicator.startAnimating()
                    activityIndicator.isHidden = false
                }
            }
        } else {
            if let refreshControl = _tableView?.refreshControl,
                refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            _view?.activityIndicator.stopAnimating()
            _view?.activityIndicator.isHidden = true
            _tableView?.contentInset = UIEdgeInsets.zero
        }
    }
}

extension ReactionFeedPresenter: ReactionFeedViewOutput {
    public func handleViewDidLoad() {
        self._setup()
        self._interactor.getMoreReactions(shouldRefresh: true)
    }
    
    public func handleViewDidAppear() {
        _interactor.observeReactions()
    }
    
    public func handleViewDidDisappear() {
        _interactor.stopObservingReactions()
    }
    
    private func _setup() {
        let customTabBarItem = UITabBarItem(title: "Feed",
                                            image: nil,
                                            selectedImage: nil)
        _view?.setTabBarItem(customTabBarItem, navigationBarTitle: "Reaction Feed")
        _tableView?.register(ReactionCell.nib,
                             forCellReuseIdentifier: ReactionCell.identifier)
        _tableView?.refreshControl = UIRefreshControl()
        _tableView?.refreshControl?.addTarget(self,
                                              action: #selector(_refreshFeed),
                                              for: .valueChanged)
        _view?.activityIndicator.isHidden = true
        _tableView?.dataSource = self
        _tableView?.delegate = self
        _tableView?.reloadData()
    }
    
    @objc private func _refreshFeed() {
        self._interactor.getMoreReactions(shouldRefresh: true)
    }
}

extension ReactionFeedPresenter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReactionCell.identifier, for: indexPath) as! ReactionCell
        guard indexPath.row < _feedViewModels.count else {
            return cell
        }
        let reaction = _feedViewModels[indexPath.row]
        cell.title.text = reaction.videoTitle
        cell.details.text = "\(reaction.likesCount) likes | \(reaction.commentsCount) comments"
        cell.displayname.text = reaction.displayname
        cell.username.text = reaction.username
        if let image = reaction.thumbnail {
            cell.thumbnail.image = image
        } else {
            _interactor.downloadThumbnail(id: reaction.id)
        }
        if let image = reaction.avatar {
            cell.avatar.image = image
        } else {
            _interactor.downloadAvatar(id: reaction.id)
        }
        if indexPath.row == _feedViewModels.count - 1 {
            _interactor.getMoreReactions(shouldRefresh: false)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _feedViewModels.count
    }
}

extension ReactionFeedPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < _feedViewModels.count else {
            return
        }
        let reaction = _feedViewModels[indexPath.row]
        _interactor.cancelDownload(id: reaction.id)
    }
}
