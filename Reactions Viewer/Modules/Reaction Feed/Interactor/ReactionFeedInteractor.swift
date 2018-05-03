//
//  ReactionFeedInteractor.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class ReactionFeedInteractor {
    public weak var output: ReactionFeedInteractorOutput?
    
    private var _webService: WebService
    private var _imageService: ImageService
    private var _databaseService: DatabaseService
    private var _token: DatabaseNotificationToken?
    private var _startKey: String?
    private var _reactionObjects: [ReactionObject] = []
    private var _isPendingFeedResponse: Bool = false {
        didSet {
            output?.update(isLoading: _isPendingFeedResponse,
                              isFirstPage: _startKey == nil)
        }
    }
    
    public init(webService: WebService,
                imageService: ImageService,
                databaseService: DatabaseService) {
        _webService = webService
        _imageService = imageService
        _databaseService = databaseService
    }
    
    deinit {
        _token?.invalidate()
    }
    
    private func _createViewModel(fromReaction reaction: ReactionObject) -> ReactionFeedViewModel? {
        guard let user = reaction.reactionOwner.first else {
            return nil
        }
        
        return ReactionFeedViewModel(id: reaction.id,
                                     videoTitle: reaction.title,
                                     displayname: user.displayname,
                                     username: user.username,
                                     likesCount: reaction.likesCount,
                                     commentsCount: reaction.commentsCount,
                                     thumbnail: _imageService.cachedImage(withKey: reaction.thumbnailKey),
                                     avatar: _imageService.cachedImage(withKey: user.avatarKey))
    }
}

extension ReactionFeedInteractor: ReactionFeedInteractorInput {
    public func getMoreReactions(shouldRefresh: Bool) {
        guard !_isPendingFeedResponse else {
            return
        }
        _isPendingFeedResponse = true
        
        if shouldRefresh {
            _startKey = nil
        }
        _webService.getReactions(startKey: _startKey) { (response, error) in
            DispatchQueue.main.async {
                self._isPendingFeedResponse = false
            }
            guard let response = response, error == nil else {
                return
            }
            self._startKey = response.startKey
            var reactionObjects = response.items?.compactMap(ReactionObject.init) ?? []
            let userObjects = response.users?.compactMap(UserObject.init) ?? []
            
            func appendReactions() {
                #if DEBUG
                //Shuffle to simulate new reaction set
                reactionObjects = reactionObjects.shuffled()
                #endif
                
                self._databaseService.reactionListAppend(reactions: reactionObjects,
                                                         users: userObjects,
                                                         completion: { (success) in
                                                            if shouldRefresh {
                                                                
                                                            }
                })
            }
            
            if shouldRefresh {
                DispatchQueue.main.async {
                    #if DEBUG
                    //Delete all objects to simulate new reaction set
                    self._databaseService.deleteAllReactions(completion: { (success) in
                        if success {
                            appendReactions()
                        }
                    })
                    #else
                    self._databaseService.purgeReactionFeed(completion: { (success) in
                        if success {
                            appendReactions()
                        }
                    })
                    #endif
                }
            } else {
                appendReactions()
            }
        }
    }
    
    public func downloadThumbnail(id: String) {
        if let index = _reactionObjects.index(where: { $0.id == id }) {
            let reaction = _reactionObjects[index]
            self._imageService.downloadImage(withKey: reaction.thumbnailKey, completion: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.output?.update(withThumbnail: image, forID: id)
                    }
                }
            })
        }
    }
    
    public func downloadAvatar(id: String) {
        if let index = _reactionObjects.index(where: { $0.id == id }),
            let reactionOwner = _reactionObjects[index].reactionOwner.first {
            self._imageService.downloadImage(withKey: reactionOwner.avatarKey, completion: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.output?.update(withAvatar: image, forID: id)
                    }
                }
            })
        }
    }
    
    public func cancelDownload(id: String) {
        if let index = _reactionObjects.index(where: { $0.id == id }) {
            let reaction = _reactionObjects[index]
            self._imageService.cancelDownload(withKey: reaction.thumbnailKey)
        }
    }
    
    public func stopObservingReactions() {
        _token?.invalidate()
        _token = nil
    }
    
    public func observeReactions() {
        guard _token == nil else {
            return
        }
        _token = _databaseService.observeReactionList(
            onSubscribed: { (reactions) in
                self._reactionObjects = reactions
                let viewModels = self._reactionObjects.compactMap(self._createViewModel)
                DispatchQueue.main.async {
                    self.output?.update(withReactions: viewModels)
                }
        }, onUpdated: { (reactions, _, _, _) in
            self._reactionObjects = reactions
            let viewModels = self._reactionObjects.compactMap(self._createViewModel)
            DispatchQueue.main.async {
                self.output?.update(withReactions: viewModels)
            }
        }) { (error) in
            //TODO: present error
        }
    }
}
