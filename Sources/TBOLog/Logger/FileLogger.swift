//
// Created by TobyoTenma on 15/12/2017.
//

import Foundation

class FileLoggerBlockOperation: BlockOperation {
}

open class FileLogger: BaseLogger {
    struct Const {
        static let maxLogInfoCount = 200
        /// 10s write one
        static let flushMaxTime: TimeInterval = 10
    }

	var fileHandler: FileHandle? = nil
    var fileURL: URL? = nil
	var canAppend: Bool = false
	var fileHeader: String? = nil
    
    let queue = OperationQueue()
    let semaphore = DispatchSemaphore(value: 1)
    var caches: [LogInfo] = []
    var writerTimer: Timer? = nil

	override
	private init(identifier: String = "default-file-logger") {
		super.init(identifier: identifier)
        queue.name = "tbolog.file.logqueue"
        queue.maxConcurrentOperationCount = 1
	}

	convenience
	init(fileURL: URL, canAppend: Bool, identifier: String = "default-file-logger", fileHeader: String? = nil) {
		self.init(identifier: identifier)
		self.fileURL = fileURL
		self.canAppend = canAppend

		var header = fileHeader
		if fileHeader == nil {
			 header = "========== TBOLogger " +
					 LogInfo.formatter.string(from: Date()) +
					" ========="
		}
		self.fileHeader = header

		openFile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flush), name: Notification.Name("UIApplicationWillEnterForegroundNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flush), name: Notification.Name("UIApplicationDidEnterBackgroundNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flush), name: Notification.Name("UIApplicationDidReceiveMemoryWarningNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flush), name: Notification.Name("UIApplicationWillTerminateNotification"), object: nil)
	}
    
    override
    func output(_ info: LogInfo) {
        semaphore.wait()
        caches.append(info)
        if caches.count >= Const.maxLogInfoCount {
            asyncWrite()
        } else {
            startTimer()
        }
        // output to console
        ConsoleLogger.default.output(info)
        semaphore.signal()
    }

	func write(_ infos: [LogInfo]) {
        guard infos.count > 0 else { return }
        if fileHandler == nil {
            openFile()
        }
        _ = infos.map { (info) in
            guard let infoData = info.description.data(using: .utf8) else {
                return
            }
            write(data: infoData)
        }
        fileHandler?.synchronizeFile()
	}
}

//MARK: - Flush logs

extension FileLogger {
    @objc func timeToWrite() {
        semaphore.wait()
        asyncWrite()
        semaphore.signal()
    }
    
    func asyncWrite() {
        clearTimer()
        guard caches.count > 0 else { return }
        let logInfos = Array(caches)
        let op = FileLoggerBlockOperation { [weak self] in
            guard let `self` = self else { return }
            self.write(logInfos)
        }
        queue.addOperation(op)
        caches.removeAll()
        //TODO: keep off the file to large
    }
    
    @objc func flush() {
        clearTimer()
        semaphore.wait()
        // dump the queue loginfo to file sync
        queue.isSuspended = true
        let ops = queue.operations
        _ = ops.map { (op) in
            guard op.isKind(of: FileLoggerBlockOperation.self),
                let fileLoggerOp = op as? FileLoggerBlockOperation,
                fileLoggerOp.isExecuting == false else { return }
            fileLoggerOp.start()
        }
        queue.cancelAllOperations()
        queue.isSuspended = false
        // dump the caches to file sync
        write(caches)
        caches.removeAll()
        semaphore.signal()
    }
}

// Mark: - Timer

extension FileLogger {
    func startTimer() {
        guard writerTimer == nil else { return }
        writerTimer = Timer.scheduledTimer(timeInterval: Const.flushMaxTime, target: self, selector: #selector(timeToWrite), userInfo: nil, repeats: false)
    }
    
    func clearTimer() {
        semaphore.wait()
        writerTimer?.invalidate()
        writerTimer = nil
        semaphore.signal()
    }
}

// MARK: - File && Dictionary

extension FileLogger {

	func openFile() {
		if fileHandler != nil {
			closeFile()
		}
        guard let url = fileURL else { return }
		let isFileExists = checkFileExists(at: url.path)
		if !isFileExists {
			createFile(at: url)
		}
		fileHandler = prepareFileHandler(at: url, fileIsExists: isFileExists, canAppend: canAppend)
	}

	func closeFile() {
		fileHandler?.synchronizeFile()
		fileHandler?.closeFile()
		fileHandler = nil
	}

	func checkFileExists(at path: String) -> Bool {
	    return FileManager.default.fileExists(atPath: path)
	}

    @discardableResult
    func createFile(at url: URL) -> Bool {
        let dicURL = url.deletingLastPathComponent()
        try? FileManager.default.createDirectory(atPath: dicURL.path, withIntermediateDirectories: true, attributes: nil)
        return FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
    
	func prepareFileHandler(at url: URL, fileIsExists: Bool, canAppend: Bool) -> FileHandle? {
		let fileHandler = try? FileHandle(forWritingTo: url)
		if fileIsExists && canAppend {
			fileHandler?.seekToEndOfFile()
		}
        
        if !fileIsExists,
            let header = fileHeader,
            let headerData = "\(header)\n".data(using: .utf8) {
            fileHandler?.write(headerData)
        }
        
		return fileHandler
	}
}

// MARK: - File Handle
extension FileLogger {
	func write(data: Data) {
		fileHandler?.write(data)
	}
}
