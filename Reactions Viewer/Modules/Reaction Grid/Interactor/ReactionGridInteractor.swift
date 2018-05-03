//
//  ReactionGridInteractor.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class ReactionGridInteractor {
    public weak var presenter: ReactionGridPresenter?
    
    private var _imageService: ImageService
    private var _databaseService: DatabaseService
    
    private var _token: DatabaseNotificationToken?
    private var _reactionObjects: [ReactionObject] = []
    
    public init(imageService: ImageService,
                databaseService: DatabaseService) {
        _imageService = imageService
        _databaseService = databaseService
    }
    
    deinit {
        _token?.invalidate()
    }
    
    private func _createViewModel(fromReaction reaction: ReactionObject) -> ReactionGridViewModel? {
        return ReactionGridViewModel(id: reaction.id,
                                     thumbnail: _imageService.cachedImage(withKey: reaction.thumbnailKey))
    }
}

extension ReactionGridInteractor: ReactionGridInteractorInput {
    public func downloadThumbnail(id: String) {
        if let index = _reactionObjects.index(where: { $0.id == id }) {
            let reaction = _reactionObjects[index]
            self._imageService.downloadImage(withKey: reaction.thumbnailKey, completion: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.presenter?.update(withThumbnail: image, forID: id)
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
        _token = _databaseService.observe(objectType: ReactionObject.self,
                                          predicate: nil,
                                          initialBlock: { (reactions) in
                                            self._reactionObjects = reactions
                                            let viewModels = self._reactionObjects.compactMap(self._createViewModel)
                                            DispatchQueue.main.async {
                                                self.presenter?.update(withReactions: viewModels)
                                            }
        },
                                          updateBlock: { (reactions, _, _, _) in
                                            self._reactionObjects = reactions
                                            let viewModels = self._reactionObjects.compactMap(self._createViewModel)
                                            DispatchQueue.main.async {
                                                self.presenter?.update(withReactions: viewModels)
                                            }
        }) { (error) in
            //TODO: present error
        }
    }
}
