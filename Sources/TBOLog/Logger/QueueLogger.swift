//
// Created by TobyoTenma on 15/12/2017.
//

import Foundation

class QueueLogger: BaseLogger {
	private let logQueue = DispatchQueue(label: "tbolog.logqueue")
}

extension QueueLogger {

	func flush(_ info: LogInfo, isAsynchronously: Bool) {
		let workItem: DispatchWorkItem = DispatchWorkItem {
			self.write(_: info)
		}
		if isAsynchronously {
			logQueue.async(execute: workItem)
		} else {
			logQueue.sync(execute: workItem)
		}
	}
}
