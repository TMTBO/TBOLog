//
// Created by TobyoTenma on 15/12/2017.
//

import Foundation

open class QueueLogger: BaseLogger {
	internal let logQueue = OperationQueue()
    
    override init(identifier: String) {
        logQueue.name = "tbolog.logqueue"
        logQueue.maxConcurrentOperationCount = 1
        super.init(identifier: identifier)
    }

	override
	func output(_ info: LogInfo) {
		if info.isAsynchronously {
            logQueue.addOperation { [weak self] in
                guard let `self` = self else { return }
                self.write(info)
            }
		} else {
			self.write(info)
		}
	}
    
    internal
    func write(_ info: LogInfo) {
        precondition(false, "This Method Must Be Override!")
    }
}
