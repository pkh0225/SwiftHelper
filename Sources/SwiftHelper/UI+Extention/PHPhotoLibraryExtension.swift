//
//  PHPhotoLibraryExtension.swift
//  ssg
//
//  Copyright © 2018년 emart. All rights reserved.
//

import UIKit
import Photos

extension PHPhotoLibrary {
    // MARK: - Public

    public static func authorizationPhotoLibraryStatus() async -> (status: PHAuthorizationStatus, isAccess: Bool) {
        let status = authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            return (status, true)
        default:
            let newStatus = await requestAuthorization(for: .readWrite)
            let isAccess = newStatus == .authorized || newStatus == .limited
            return (newStatus, isAccess)
        }
    }

    public func savePhoto(image: UIImage, albumName: String) async -> Bool {
        let (_, isAccess) = await PHPhotoLibrary.authorizationPhotoLibraryStatus()
        guard isAccess else { return false }

        if let album = findAlbum(albumName: albumName) {
            return await saveImage(image: image, album: album)
        }

        if let album = await createAlbum(albumName: albumName) {
            return await saveImage(image: image, album: album)
        }

        // limited 등 앨범 생성/접근이 불가한 경우 라이브러리에만 저장
        return await saveImageToLibrary(image: image)
    }

    // MARK: - Private

    private func findAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let fetchResult: PHFetchResult<PHAssetCollection>

        if albumName.isValid {
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        }
        else {
            fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)
        }

        return fetchResult.firstObject
    }

    private func createAlbum(albumName: String) async -> PHAssetCollection? {
        var albumPlaceholder: PHObjectPlaceholder?
        do {
            try await performChanges {
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }
            guard let placeholder = albumPlaceholder else { return nil }
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            return fetchResult.firstObject
        }
        catch {
            return nil
        }
    }

    private func saveImage(image: UIImage, album: PHAssetCollection) async -> Bool {
        do {
            try await performChanges {
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                      let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
                albumChangeRequest.addAssets([photoPlaceholder] as NSArray)
            }
            return true
        }
        catch {
            return false
        }
    }

    private func saveImageToLibrary(image: UIImage) async -> Bool {
        do {
            try await performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            return true
        }
        catch {
            return false
        }
    }
}
