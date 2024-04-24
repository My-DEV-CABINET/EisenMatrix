//
//  FileManageService.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/24/24.
//

import Foundation

final class FileManageService {
    static let shared = FileManageService()
    
    func makeFileAndWrite(json: String) {
        let fileManager = FileManager.default
        // 도큐먼트 URL
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // 도큐먼트 URL에 생성할 폴더명
        let directoryURL = documentURL.appendingPathComponent("Eisen Matrix")
        
        do {
            // 폴더 생성
            try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
        } catch let e as NSError {
            print(e.localizedDescription)
        }
            
        // 저장할 파일명 (확장자 필수)
        let fileName = directoryURL.appendingPathComponent("\(Date.now.format("YYYY-MM-dd hh:mm:ss")) - Eisen Matrix.txt")
        // 파일에 넣을 텍스트
        
        print("#### JSON :: \(json)")
        let text = json
            
        do {
            // 파일 생성
            try text.write(to: fileName, atomically: false, encoding: .utf8)
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func findAndReadJSON(fileURL: URL) -> Data? {
        do {
            // 파일 내용을 Data 형태로 읽어옴
            let contents = try Data(contentsOf: fileURL)
            print("#### File find and read: \(contents.count) bytes")
            return contents
        } catch {
            // 에러 처리
            print("Error reading file: \(error)")
        }
        
        return nil
    }
    
    private init() {}
}
