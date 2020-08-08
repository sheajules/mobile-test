//
//  ImageCachingService.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//


import UIKit

struct ImageCachingService {

    static func retrieveImageData(url: URL) -> Data? {
        guard let (_, fileURL) = getFilePaths(url: url) else {
            return nil
        }
        return FileManager.default.contents(atPath: fileURL.path)
    }

    static func saveImageData(_ data: Data, url: URL) {
        guard let (folderUrl, fileURL) = getFilePaths(url: url) else {
            return
        }
        let folderExists = FileManager.default.fileExists(atPath: folderUrl.path)

        if !folderExists {
            do {
                try FileManager.default.createDirectory(
                    at: folderUrl,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                debugPrint(error)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch {
            debugPrint(error)
        }
    }

    static func getFilePaths(url: URL) -> (URL, URL)? {
        if url.pathComponents.count < 2 {
            return nil
        }
        guard var fileURL: URL = getDocumentDirectory() else {
            return nil
        }
        var urlCopy = url
        let filename: String = urlCopy.lastPathComponent
        urlCopy.deleteLastPathComponent()
        let folderName: String = urlCopy.lastPathComponent

        fileURL.appendPathComponent(folderName)
        let folderUrl = fileURL

        fileURL.appendPathComponent(filename)
        return (folderUrl, fileURL)
    }

    static func getDocumentDirectory() -> URL? {
        return try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}

