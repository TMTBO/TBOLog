//
//  ASLLoggerTest.swift
//  Pods
//
//  Created by TobyoTenma on 15/10/2017.
//

import Quick
import Nimble

import os.log
import asl
@testable import TBOLog

class ASLLoggerTest: QuickSpec {
    override func spec() {
        describe("ASLLogger") {
            var info: LogInfo!
            var logger: ASLLogger! = ASLLogger.default
            
            afterEach {
                info = nil
            }
            
            afterSuite {
                logger = nil
            }
            
            describe("apple system log") {
                afterEach {
                    logger.testASLWrite(info)
                }
                
                it("verbose") {
                    info = LogInfo(level: .verbose, content: ["Hello ASLLogger", "TBOLog", "ASL", "Verbose"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("debug") {
                    info = LogInfo(level: .debug, content: ["Hello ASLLogger", "TBOLog", "ASL", "Debug"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("info") {
                    info = LogInfo(level: .info, content: ["Hello ASLLogger", "TBOLog", "ASL", "Info"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("warning") {
                    info = LogInfo(level: .warning, content: ["Hello ASLLogger", "TBOLog", "ASL", "Warning"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("error") {
                    info = LogInfo(level: .error, content: ["Hello ASLLogger", "TBOLog", "ASL", "Error"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("none") {
                    info = LogInfo(level: .none, content: ["Hello ASLLogger", "TBOLog", "ASL", "None"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
            }
            
            describe("os log") {
                afterEach {
                    if #available(OSX 10.12, *) {
                        logger.testOSLogWrite(info)
                    }
                }
                
                it("verbose") {
                    info = LogInfo(level: .verbose, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "Verbose"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("debug") {
                    info = LogInfo(level: .debug, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "Debug"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("info") {
                    info = LogInfo(level: .info, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "Info"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("warning") {
                    info = LogInfo(level: .warning, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "Warning"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("error") {
                    info = LogInfo(level: .error, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "Error"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
                
                it("none") {
                    info = LogInfo(level: .none, content: ["Hello ASLLogger", "TBOLog", "OSLOG", "None"], file: #file, line: #line, function: #function, tempInfoFlag: .full, tag: "ASLLogger")
                }
            }
            
            describe("convert") {
                if #available(OSX 10.12, *) {
                    it("Level to OSLogType") {
                        let levels: [Level] = [.verbose, .debug, .info, .warning, .error, .none]
                        let osTypes: [OSLogType] = [.debug, .debug, .default, .fault, .error, .info]
                        
                        let result = levels.map { logger.testOSLogType($0) }
                    
                        expect(result).to(equal(osTypes))
                    }
                } else {
                    it("Level to ASL Level") {
                        let levels: [Level] = [.verbose, .debug, .info, .warning, .error, .none]
                        let aslLevels = ["\(ASL_LEVEL_EMERG)", "\(ASL_LEVEL_EMERG)", "\(ASL_LEVEL_WARNING)", "\(ASL_LEVEL_ERR)", "\(ASL_LEVEL_CRIT)", "\(ASL_LEVEL_NOTICE)"]
                        
                        let result = levels.map { logger.testASLLevel($0) }
                        
                        expect(result).to(equal(aslLevels))
                    }
                }
            }
        }
    }
}
