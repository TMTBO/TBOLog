//
//  FileLoggerTest.swift
//  Nimble-iOS
//
//  Created by TobyoTenma on 19/12/2017.
//

import Quick
import Nimble
@testable import TBOLog

class FileLoggerSpec: QuickSpec {
	override
	func spec() {
		describe("FileLogger") {
			var logger1: FileLogger?
            
            beforeEach {
                LogInfo.prepareLogInfoDateFormat()
            }

			describe("Create File Logger") {
				it("With URL") {
                    guard let url = self.getDocumentURL() else { return }
					logger1 = FileLogger(fileURL: url.appendingPathComponent("file_logger_1"), canAppend: true)
				}
                
                it ("Wit URL In Dictionary") {
                    guard var url = self.getDocumentURL() else { return }
                    url.appendPathComponent("/TBOLog/file_log/file_logger_1")
                    logger1 = FileLogger(fileURL: url, canAppend: false, identifier: "tbolog_file_logger")
                }
                
                describe("Motheds test") {
                    beforeEach {
                        guard let url = self.getDocumentURL() else { return }
                        logger1 = FileLogger(fileURL: url, canAppend: true)
                    }
                    
                    it("Create File") {
                        guard var url = self.getDocumentURL() else { return }
                        url.appendPathComponent("/TBOLog/file_log/1/file_logger_1")
                        let result = logger1!.createFile(at: url)
                        expect(result).to(equal(true))
                    }
                }
			}

		}
	}
    
    func getDocumentURL() -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let url = URL(string: path) else {
                print("path error")
                return nil
        }
        return url
    }
}
