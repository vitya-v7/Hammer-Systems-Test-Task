//
//  PendingOperations.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import UIKit

// MARK: - ManagingOperations

public final class PendingOperations {
    
	lazy var downloadsInProgress: [IndexPath: Operation] = [:]
	lazy var downloadQueue: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Download queue"
		queue.maxConcurrentOperationCount = 6
		return queue
	}()

	func suspendAllOperations() {
		downloadQueue.isSuspended = true
	}

	func resumeAllOperations() {
		downloadQueue.isSuspended = false
	}
}
