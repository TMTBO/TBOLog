import Quick
import Nimble
@testable import TBOLog

class TBOLogSpec: QuickSpec {
    override func spec() {
        afterEach {
            TBOLog.stop()
        }
        
        describe("TBOLog") {
            describe("start loger") {
                var canLog = StartResult(isSuccess: false, reason: "")
                it("success start") {
                    canLog = TBOLog.start(.verbose)
                    expect(canLog.isSuccess).to(equal(true))
                }
                
                it("start with config") {
                    let config = StartConfiguration(
                        level: .verbose,
                        loggers: [ConsoleLogger.default],
                        flag: .full,
                        path: "TBOLog",
                        tag: nil,
                        isAsynchronously: true)
                    canLog = TBOLog.start(config)
                    TBOLog.i("Start with config")
                    TBOLog.d("Start with config", flag: .level)
                    expect(canLog.isSuccess).to(equal(true))
                }
                
                it("start with tag") {
                    var config = StartConfiguration()
                    config.tag = ">>>"
                    canLog = TBOLog.start(config)
                    TBOLog.i("Start with tag")
                }
                
                it("fail start") {
                    TBOLog.start(.verbose)
                    canLog = TBOLog.start(.verbose)
                    expect(canLog.isSuccess).to(equal(false))
                }
            }
            
            describe("Log content") {
                beforeEach {
                    let canLog = TBOLog.start(.debug)
                    expect(canLog.isSuccess).to(equal(true))
                }
                it("Log items") {
                    TBOLog.i("hello", "world")
                }
                
                it("Log json to console") {
                    let dict = ["hello": "world",
                               "swift": "language"]
                    TBOLog.d(dict)
                }
                
                it("Log json array to console") {
                    let dict = ["hello": "world",
                                "swift": "language"]
                    TBOLog.d(dict, dict)
                }
                
                it("Log v to console") {
                    TBOLog.v("Log verbose", "Log verbose2", "Log verbose3")
                }
                
                it("Log struct Model to console") {
                    struct Person {
                        let name: String
                        let age: Int
                        let gender: String
                    }
                    
                    let p1 = Person(name: "Tobyo", age: 20, gender: "Male")
                    TBOLog.v("Person", p1)
                }
                
                it("Log mutable struct Model to console") {
                    struct Person {
                        let name: String
                        let age: Int
                        let gender: String
                    }
                    
                    let p1 = Person(name: "Tobyo", age: 20, gender: "Male")
                    let p2 = Person(name: "Tenma", age: 27, gender: "Male")
                    TBOLog.v(p1, p2)
                }
                
                it("Log nest struct Model to console") {
                    struct Person {
                        let name: String
                        let age: Int
                        let gender: String
                        let friends: [Person]
                    }
                    
                    let p1 = Person(name: "Tobyo", age: 20, gender: "Male", friends: [])
                    let p2 = Person(name: "Tenma", age: 27, gender: "Male", friends: [])
                    
                    let p3 = Person(name: "Tobyo", age: 20, gender: "Male", friends: [p1,p2])
                    TBOLog.v(p1, p2, p3)
                }
                
                it("Log json struct Model array to console") {
                    struct Person {
                        let name: String
                        let age: Int
                        let gender: String
                    }
                    
                    let p1 = Person(name: "Tobyo", age: 20, gender: "Male")
                    let p2 = Person(name: "Tenma", age: 27, gender: "Male")
                    TBOLog.v(["person": [p1, p2], "hello": ["hello", "world"]])
                }
                
                it("Log async") {
                    let queue = DispatchQueue(label: "TBOLog queue")
                    queue.async {
                        TBOLog.d("async log")
                    }
                }
                
                it("Log with tag") {
                    TBOLog.e("Log with tag", tag: "------>")
                }
                
                describe("log to file") {
                    var defaultId: LoggerIdentifier?
                    beforeEach {
                        guard var url = self.getDocumentURL() else { return }
                        url = url.appendingPathComponent("/log1")
                        let fileLogger = FileLogger(fileURL: url, canAppend: true)
                        defaultId = fileLogger.identifier
                        TBOLog.append(logger: fileLogger)
                        TBOLog.start(.verbose)
                    }
                    
                    it("default file logger") {
                        TBOLog.i("Log to file logger", loggers: [defaultId!])
                        TBOLog.v(["person": ["p1", "p2"], "hello": ["hello", "world"]], loggers: [defaultId!])
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
