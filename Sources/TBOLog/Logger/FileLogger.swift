//
// Created by TobyoTenma on 15/12/2017.
//

import Foundation

open class FileLogger: QueueLogger {

	var fileHandler: FileHandle? = nil
    var fileURL: URL? = nil
	var canAppend: Bool = false
	var fileHeader: String? = nil

	override
	private init(identifier: String = "default-file-logger") {
		super.init(identifier: identifier)
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
	}

	override
	func write(_ info: LogInfo) {
		guard let infoData = info.contentDescription.data(using: .utf8) else {
			return
		}
		write(data: infoData)
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
