//
// Created by TobyoTenma on 15/12/2017.
//

import Foundation

class FileLogger: QueueLogger {

	var fileHandler: FileHandle? = nil
	var fileURL: URL? = nil
	var canAppend: Bool = false
	var fileHeader: String? = nil

	convenience
	init(fileURL: URL, canAppend: Bool, fileHeader: String? = nil) {
		self.init()
		self.fileURL = fileURL
		self.canAppend = canAppend

		var header = fileHeader
		if fileHeader == nil {
			let dateComponents = DateComponents()
			 header = "========== TBOLogger " +
					 String(describing: dateComponents.year) + "-" +
					 String(describing: dateComponents.month) + "-" +
					 String(describing: dateComponents.day) + "-" +
					 String(describing: dateComponents.hour) + ":" +
					 String(describing: dateComponents.minute) + ":" +
					 String(describing: dateComponents.second) + ":" +
					 String(describing: dateComponents.nanosecond) +
					" ========="
		}
		self.fileHeader = header
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
		let path = url.path
		let isFileExists = checkFileExists(at: path)
		if !isFileExists {
			createFile(at: path)
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

	func prepareFileHandler(at url: URL, fileIsExists: Bool, canAppend: Bool) -> FileHandle? {
		let fileHandler = try? FileHandle(forWritingTo: url)
		if fileIsExists && canAppend {
			fileHandler?.seekToEndOfFile()
			if let header = fileHeader,
				let headerData = "\(header)\n".data(using: .utf8) {
				write(data: headerData)
			}
		}
		return fileHandler
	}

	func createFile(at path: String) {
		FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
	}
}

// MARK: - File Handle
extension FileLogger {
	func write(data: Data) {
		fileHandler?.write(data)
	}
}
