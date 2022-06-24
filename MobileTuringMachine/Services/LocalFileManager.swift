//
//  LocalFileManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import Foundation

class LocalFileManager {
    static let shared = LocalFileManager()
    
    func saveData(algorithms: [Algorithm]) {
        do {
            guard let path = getPathForData() else { return }
            print(1)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData = try encoder.encode(algorithms) // takes a while to encode
            print(2)
            try encodedData.write(to: path)
            print(String(data: encodedData, encoding: .utf8)!)
//            print("Data's saved.")
        } catch {
            print("Failed to save data. \(error.localizedDescription)")
        }
    }
    
    func getData() -> [Algorithm]? {
        guard
            let path = getPathForData(),
            FileManager.default.fileExists(atPath: path.path) else {
            print("Failed to find the path.")
            return nil
        }
        guard let data = try? Data(contentsOf: path) else {
            print("Failed getting data from url: \(path)")
            return nil
        }
        guard let algorithms = try? PropertyListDecoder().decode([Algorithm].self, from: data) else {
            print("Failed decoding file.")
            return nil
        }
        return algorithms
    }
    
    func testSaveData(algorithm: Algorithm) {
        do {
            guard let path = getPathForData() else { return }
            print(1)
            let encodedData = try JSONEncoder().encode(algorithm) // takes a while to encode
            print(2)
            try encodedData.write(to: path)
        } catch {
            print("Failed to save data. \(error.localizedDescription)")
        }
    }
    
    func testGetData() -> Algorithm? {
        guard
            let path = getPathForData(),
            FileManager.default.fileExists(atPath: path.path) else {
            print("Failed to find the path.")
            return nil
        }
        guard let data = try? Data(contentsOf: path) else {
            print("Failed getting data from url: \(path)")
            return nil
        }
        guard let algorithm = try? PropertyListDecoder().decode(Algorithm.self, from: data) else {
            print("Failed decoding file.")
            return nil
        }
        return algorithm
    }
    
    func testGetPathForData(algorithmID: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(algorithmID)") else {
            print("Failed to get path to the directory.")
            return nil
        }
        return path
    }
    
    func getPathForData(fileName: String = "algorithms") -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(fileName).mtms") else {
            print("Failed to get path to the directory.")
            return nil
        }
        return path
    }
    
}

/*
[
  {
    "id" : "F410696C-4838-491C-A4C1-E3AFCF0139C7",
    "states" : [
      {
        "nameID" : 0,
        "id" : "D075EB40-226F-44C4-B649-EB287552F636",
        "options" : [
          {
            "id" : "4850C2FC-4504-4163-B85A-ABDC09032119",
            "toState" : {
              "nameID" : 0,
              "id" : "D075EB40-226F-44C4-B649-EB287552F636",
              "options" : [
                {
                  "id" : "9A3C6F00-E9E1-42DE-9AE5-001D36F7283D",
                  "toState" : {
                    "nameID" : 0,
                    "id" : "D075EB40-226F-44C4-B649-EB287552F636",
                    "options" : [

                    ],
                    "isStarting" : true
                  },
                  "combinations" : [
                    {
                      "id" : "25493C09-6DFA-4B40-A934-AA7ED217AAD3",
                      "character" : "_",
                      "toCharacter" : "_",
                      "direction" : "arrow.counterclockwise"
                    }
                  ]
                }
              ],
              "isStarting" : true
            },
            "combinations" : [
              {
                "id" : "57E2B254-DDA6-4E55-BCDE-7C237CC53A0B",
                "character" : "A",
                "toCharacter" : "A",
                "direction" : "arrow.counterclockwise"
              }
            ]
          },
          {
            "id" : "5CC642EE-0412-4783-93DA-FB535E3A7B71",
            "toState" : {
              "nameID" : 0,
              "id" : "D075EB40-226F-44C4-B649-EB287552F636",
              "options" : [
                {
                  "id" : "9A3C6F00-E9E1-42DE-9AE5-001D36F7283D",
                  "toState" : {
                    "nameID" : 0,
                    "id" : "D075EB40-226F-44C4-B649-EB287552F636",
                    "options" : [

                    ],
                    "isStarting" : true
                  },
                  "combinations" : [
                    {
                      "id" : "25493C09-6DFA-4B40-A934-AA7ED217AAD3",
                      "character" : "_",
                      "toCharacter" : "_",
                      "direction" : "arrow.counterclockwise"
                    }
                  ]
                }
              ],
              "isStarting" : true
            },
            "combinations" : [
              {
                "id" : "2F7D37AF-3671-4515-AE30-23B8ABC8359F",
                "character" : "_",
                "toCharacter" : "_",
                "direction" : "arrow.counterclockwise"
              }
            ]
          }
        ],
        "isStarting" : true
      }
    ],
    "stateForReset" : {
      "nameID" : 0,
      "id" : "D075EB40-226F-44C4-B649-EB287552F636",
      "options" : [
        {
          "id" : "9A3C6F00-E9E1-42DE-9AE5-001D36F7283D",
          "toState" : {
            "nameID" : 0,
            "id" : "D075EB40-226F-44C4-B649-EB287552F636",
            "options" : [

            ],
            "isStarting" : true
          },
          "combinations" : [
            {
              "id" : "25493C09-6DFA-4B40-A934-AA7ED217AAD3",
              "character" : "_",
              "toCharacter" : "_",
              "direction" : "arrow.counterclockwise"
            }
          ]
        }
      ],
      "isStarting" : true
    },
    "name" : "New Algorithm",
    "description" : "",
    "tapes" : [
      {
        "nameID" : 0,
        "id" : "0F9E6FD0-50D2-4ADA-B0FA-C081C45D7189",
        "headIndex" : 0,
        "alphabet" : "A",
        "input" : "",
        "components" : [
          {
            "id" : -10,
            "value" : "_"
          },
          {
            "id" : -9,
            "value" : "_"
          },
          {
            "id" : -8,
            "value" : "_"
          },
          {
            "id" : -7,
            "value" : "_"
          },
          {
            "id" : -6,
            "value" : "_"
          },
          {
            "id" : -5,
            "value" : "_"
          },
          {
            "id" : -4,
            "value" : "_"
          },
          {
            "id" : -3,
            "value" : "_"
          },
          {
            "id" : -2,
            "value" : "_"
          },
          {
            "id" : -1,
            "value" : "_"
          },
          {
            "id" : 0,
            "value" : "_"
          },
          {
            "id" : 1,
            "value" : "_"
          },
          {
            "id" : 2,
            "value" : "_"
          },
          {
            "id" : 3,
            "value" : "_"
          },
          {
            "id" : 4,
            "value" : "_"
          },
          {
            "id" : 5,
            "value" : "_"
          },
          {
            "id" : 6,
            "value" : "_"
          },
          {
            "id" : 7,
            "value" : "_"
          },
          {
            "id" : 8,
            "value" : "_"
          },
          {
            "id" : 9,
            "value" : "_"
          },
          {
            "id" : 10,
            "value" : "_"
          }
        ]
      }
    ]
  }
]

*/
