//
//  PHPhotoLibraryExtension.swift
//  ssg
//
//  Created by mykim on 2018. 2. 21..
//  Copyright © 2018년 emart. All rights reserved.
//

import UIKit
import Photos

extension PHPhotoLibrary {
    // MARK: - PHPhotoLibrary+SaveImage

    // MARK: - Public

    public func savePhoto(image: UIImage, albumName: String, completion: BoolClosure?) {
        func save(_ albumName: String) {
            if let album: PHAssetCollection = PHPhotoLibrary.shared().findAlbum(albumName: albumName) {
                PHPhotoLibrary.shared().saveImage(image: image, album: album, completion: completion)
            }
            else {
                PHPhotoLibrary.shared().createAlbum(albumName: albumName, completion: { collection in
                    if let collection = collection {
                        PHPhotoLibrary.shared().saveImage(image: image, album: collection, completion: completion)
                    }
                    else {
                        completion?(false)
                    }
                })
            }
        }

        WG_CommonFunc.authorizationPhotoLibraryStatus { status, isAccess in
            if isAccess {
                if #available(iOS 14, *) {
                    if status == PHAuthorizationStatus.authorized.rawValue {
                        save(albumName)
                    }
                    else if status == PHAuthorizationStatus.limited.rawValue {
                        self.bool_closure = completion
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageWriteToSavedPhotosAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
                else {
                    save(albumName)
                }
            }
        }
    }

    @objc public func imageWriteToSavedPhotosAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        if let _ = error {
            self.bool_closure?(false)
        }
        else {
            self.bool_closure?(true)
        }
    }

    // MARK: - Private

    fileprivate func findAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions: PHFetchOptions = PHFetchOptions()

        if albumName.isValid {
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            guard let photoAlbum = fetchResult.firstObject else {
                return nil
            }
            return photoAlbum
        }
        else {
            let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)
            guard let photoAlbum = fetchResult.firstObject else {
                return nil
            }
            return photoAlbum
        }
    }

    fileprivate func createAlbum(albumName: String, completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, _ in
            if success {
                guard let placeholder = albumPlaceholder else {
                    completion(nil)
                    return
                }
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                guard let album = fetchResult.firstObject else {
                    completion(nil)
                    return
                }
                completion(album)
            }
            else {
                completion(nil)
            }
        })
    }

    fileprivate func saveImage(image: UIImage, album: PHAssetCollection, completion: BoolClosure?) {
//        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
//            placeholder = photoPlaceholder
            let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
            albumChangeRequest.addAssets(fastEnumeration)
        }, completionHandler: { success, _ in
//            guard let placeholder = placeholder else {
//                completion?(false)
//                return
//            }
            if success {
//                let assets:PHFetchResult<PHAsset> =  PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
//                let asset:PHAsset? = assets.firstObject
                completion?(true)
            }
            else {
                completion?(false)
            }
        })
    }
}
