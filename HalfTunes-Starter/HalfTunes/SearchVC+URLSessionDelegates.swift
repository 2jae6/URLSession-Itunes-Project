//
//  SearchVC+URLSessionDelegates.swift
//  HalfTunes
//
//  Created by 1 on 2020/04/29.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

extension SearchViewController: URLSessionDownloadDelegate{
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
    
    //print("Finishied downloading to \(location)")
    //1
    guard let sourceURL = downloadTask.originalRequest?.url else{ return }
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    
    //2
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    
    //3
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do{
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.track.downloaded = true
    }catch let error{
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    //4
    if let index = download?.track.index{
      DispatchQueue.main.async{
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
  }
}
