//
//  VideoPlayer.swift
//  VideoPlayer
//
//  Created by Andre Grillo on 28/09/2021.
//

import Foundation

@objc(VideoPlayer) class VideoPlayer: CDVPlugin {
    
    @objc(loadMindfullness:)
    func loadMindfullness(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        
        if let base64Images = command.arguments [0] as? [String], let videoArray = command.arguments[1] as? [String], let audioArray = command.arguments[2] as? [String], let audioVoiceURL = command.arguments[3] as? String, let subtitleBase64String = command.arguments[4] as? String, let secondsToSkip = command.arguments[5] as? Int, let isLiked = command.arguments[6] as? Bool, let isMuted = command.arguments[7] as? Bool {
            
            var splashImageDataArray: [Data?] = []
            if !base64Images.isEmpty {
                for base64Image in base64Images {
                    if base64Image != "NoPoster" {
                        guard let imageData = convertBase64ToData(base64String: base64Image) else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            return
                        }
                        splashImageDataArray.append(imageData)
                    } else {
                        splashImageDataArray.append(nil)
                    }
                }
            }
            
            guard let subtitleData: Data = Data(base64Encoded: subtitleBase64String) else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Subtitle to Data. Invalid base 64 string.")
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                return
            }
            
            DispatchQueue.main.async {
                let playerViewController = MindfulnessViewController()
                playerViewController.loadMindfullnessVideosFromURL(videoArray:  videoArray,
                                                                   audioArray: audioArray,
                                                                   audioVoiceURL: audioVoiceURL,
                                                                   subtitleData: subtitleData,
                                                                   splashImageArr: splashImageDataArray,
                                                                   secondsToSkip: secondsToSkip,
                                                                   isLiked: isLiked)
                { watchedTime, isLiked in
                    playerViewController.pause()
                    playerViewController.dismiss(animated: false, completion: nil)
                    let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                    if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                       let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
                
                playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.viewController.present(playerViewController, animated: false, completion: nil)
                
                pluginResult!.setKeepCallbackAs(true)
            }
            //            }
            //            task.resume()
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(loadBreathwork:)
    func loadBreathwork(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        
        //remover o audioVoiceURL do JS
        if let base64Image = command.arguments [0] as? String, let backgroundVideoURL = command.arguments[1] as? String, let audioArray = command.arguments[2] as? [String], let subtitleBase64String = command.arguments[3] as? String, let secondsToSkip = command.arguments[4] as? Int, let isLiked = command.arguments[5] as? Bool, let isMuted = command.arguments[6] as? Bool {
            
            var splashImageData: Data!
            if base64Image != "NoPoster" {
                splashImageData = convertBase64ToData(base64String: base64Image)
                if splashImageData == nil {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
//            guard let splashImageData = convertBase64ToData(base64String: base64Image) else {
//                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
//                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
//                return
//            }
            
            guard let subtitleData: Data = Data(base64Encoded: subtitleBase64String) else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Subtitle to Data. Invalid base 64 string.")
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                return
            }
            
            DispatchQueue.main.async {
                let playerViewController = BreathworkViewController()
                playerViewController.loadBreathworkVideosFromURL(
                                                                 backgroundVideoWithVoiceURL:  backgroundVideoURL,
                                                                 audioArray: audioArray,
                                                                 subtitleData: subtitleData,
                                                                 splashImage: splashImageData,
                                                                 secondsToSkip: secondsToSkip,
                                                                 isLiked: isLiked,      isMuted: isMuted)
                { watchedTime, isLiked in
                    playerViewController.pause()
                    playerViewController.dismiss(animated: false, completion: nil)
                    let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                    if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                       let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
                
                playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.viewController.present(playerViewController, animated: false, completion: nil)
                
                pluginResult!.setKeepCallbackAs(true)
            }
            //            }
            //            task.resume()
            
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(loadDeskercises:)
    func loadDeskercises(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        
        if let base64Images = command.arguments [0] as? [String], let videoArrayURL = command.arguments[1] as? [String], let videoArrayTitle = command.arguments[2] as? [String], let liked = command.arguments[3] as? Bool {
            
            var splashImageDataArray: [Data?] = []
            if !base64Images.isEmpty {
                for base64Image in base64Images {
                    if base64Image != "NoPoster" {
                        guard let imageData = convertBase64ToData(base64String: base64Image) else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            return
                        }
                        splashImageDataArray.append(imageData)
                    } else {
                        splashImageDataArray.append(nil)
                    }
                }
            }
            
//            var splashImageDataArray: [Data] = []
//            for base64Image in base64Images {
//                guard let imageData = convertBase64ToData(base64String: base64Image) else {
//                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string to Data. Invalid base 64 string.")
//                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
//                    return
//                }
//                splashImageDataArray.append(imageData)
//            }
            
            let playerViewController = DeskercisesViewController()
            playerViewController.loadDeskercisesVideosFromURL(videoArray: videoArrayURL,
                                                              videoTitleArray: videoArrayTitle,
                                                              splashImageArr: splashImageDataArray,
                                                              isLiked: liked,
                                                              callback: { (isLiked) in
                playerViewController.pause()
                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            })
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
            
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(loadMindfullnessVideosFromData:)
    func loadMindfullnessVideosFromData(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        let libraryDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if let base64Images = command.arguments [0] as? [String], let videoArray = command.arguments[1] as? [String], let audioArray = command.arguments[2] as? [String], let voice = command.arguments[3] as? String, let subtitle = command.arguments[4] as? String, let secondsToSkip = command.arguments[5] as? Int, let isLiked = command.arguments[6] as? Bool, let isMuted = command.arguments[7] as? Bool {
            
            var splashImageDataArray: [Data?] = []
            if !base64Images.isEmpty {
                for base64Image in base64Images {
                    if base64Image != "NoPoster" {
                        guard let imageData = convertBase64ToData(base64String: base64Image) else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            return
                        }
                        splashImageDataArray.append(imageData)
                    } else {
                        splashImageDataArray.append(nil)
                    }
                }
            }
        
//            var splashImageDataArray: [Data] = []
//            for base64Image in base64Images {
//                guard let imageData = convertBase64ToData(base64String: base64Image) else {
//                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string to Data. Invalid base 64 string.")
//                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
//                    return
//                }
//                splashImageDataArray.append(imageData)
//            }
            
            var videoDataArray = [Data]()
            //Loads local Video files into array as Data Objects
            for video in videoArray {
                let videoURL: URL = {
                    var url: URL!
                    let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(video)"
                    if let urlPath = URL(string: path) {
                        url = urlPath
                    } else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(video) as input")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    return url
                }()
                if FileManager.default.fileExists(atPath: videoURL.path){
                    do {
                        let videoData = try Data.init(contentsOf: videoURL)
                        videoDataArray.append(videoData)
                    } catch {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local video file \(video) not found")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            var audioDataArray = [Data]()
            //Loads local audio files into array as Data Objects
            for audio in audioArray {
                let audioURL: URL = {
                    var url: URL!
                    let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(audio)"
                    if let urlPath = URL(string: path) {
                        url = urlPath
                    } else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(audio) as input")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    return url
                }()
                if FileManager.default.fileExists(atPath: audioURL.path){
                    do {
                        let audioData = try Data.init(contentsOf: audioURL)
                        audioDataArray.append(audioData)
                    } catch {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local audio file \(audio) not found")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            var voiceData = Data()
            let audioVoiceURL: URL = {
                var url: URL!
                let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(voice)"
                if let urlPath = URL(string: path) {
                    url = urlPath
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(voice) as input")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                return url
            }()
            if FileManager.default.fileExists(atPath: audioVoiceURL.path){
                do {
                    voiceData = try Data.init(contentsOf: audioVoiceURL)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local voice audio file \(voice) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            var subtitleData = Data()
            let subtitleURL: URL = {
                var url: URL!
                let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(subtitle)"
                if let urlPath = URL(string: path) {
                    url = urlPath
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(subtitle) as input")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                return url
            }()
            if FileManager.default.fileExists(atPath: subtitleURL.path){
                do {
                    subtitleData = try Data.init(contentsOf: subtitleURL)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local subtitle file \(subtitle) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            let playerViewController = MindfulnessViewController()
            playerViewController.loadMindfullnessVideosFromData(videoArray:  videoDataArray,
                                                                audioArray: audioDataArray,
                                                                audioVoiceData: voiceData,
                                                                subtitleData: subtitleData,
                                                                splashImageArr: splashImageDataArray,
                                                                secondsToSkip: secondsToSkip,
                                                                isLiked: isLiked)
            { watchedTime, isLiked in
                playerViewController.pause()
                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(loadBreathworkFromData:)
    func loadBreathworkFromData(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        let libraryDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if let base64Image = command.arguments [0] as? String, let backgroundVideoFile = command.arguments[1] as? String, let audioArray = command.arguments[2] as? [String], let subtitleFile = command.arguments[3] as? String, let secondsToSkip = command.arguments[4] as? Int, let isLiked = command.arguments[5] as? Bool, let isMuted = command.arguments[6] as? Bool {
            
            var splashImageData: Data!
            if base64Image != "NoPoster" {
                splashImageData = convertBase64ToData(base64String: base64Image)
                if splashImageData == nil {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
//            guard let splashImageData = convertBase64ToData(base64String: base64Image) else {
//                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid Splash image")
//                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
//                return
//            }
            
            var backgroundVideoData = Data()
            let backgroundVideoURL: URL = {
                var url: URL!
                let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(backgroundVideoFile)"
                if let urlPath = URL(string: path) {
                    url = urlPath
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(backgroundVideoFile) as input")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                return url
            }()
            if FileManager.default.fileExists(atPath: backgroundVideoURL.path){
                do {
                    backgroundVideoData = try Data.init(contentsOf: backgroundVideoURL)
                    
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local video file \(backgroundVideoFile) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            //            }
            
            var audioDataArray = [Data]()
            //Loads local audio files into array as Data Objects
            for audio in audioArray {
                let audioURL: URL = {
                    var url: URL!
                    let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(audio)"
                    if let urlPath = URL(string: path) {
                        url = urlPath
                    } else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(audio) as input")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    return url
                }()
                if FileManager.default.fileExists(atPath: audioURL.path){
                    do {
                        let audioData = try Data.init(contentsOf: audioURL)
                        audioDataArray.append(audioData)
                    } catch {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local audio file \(audio) not found")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            var subtitleData = Data()
            let subtitleURL: URL = {
                var url: URL!
                let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(subtitleFile)"
                if let urlPath = URL(string: path) {
                    url = urlPath
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(subtitleFile) as input")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                return url
            }()
            if FileManager.default.fileExists(atPath: subtitleURL.path){
                do {
                    subtitleData = try Data.init(contentsOf: subtitleURL)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local subtitle file \(subtitleFile) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            let playerViewController = BreathworkViewController()
            playerViewController.loadBreathworkVideosFromData(backgroundVideoWithVoiceData: backgroundVideoData,
                                                              audioArray: audioDataArray,
                                                              subtitleData: subtitleData,
                                                              splashImage: splashImageData,
                                                              secondsToSkip: secondsToSkip,
                                                              isLiked: isLiked,
                                                              isMuted: isMuted)
            { watchedTime, isLiked in
                playerViewController.pause()
                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
        
    }
    
    @objc(loadDeskercisesFromData:)
    func loadDeskercisesFromData(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        let libraryDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if let base64Images = command.arguments [0] as? [String], let videoFilesArray = command.arguments[1] as? [String], let videoArrayTitle = command.arguments[2] as? [String], let liked = command.arguments[3] as? Bool {
            
            var splashImageDataArray: [Data?] = []
            if !base64Images.isEmpty {
                for base64Image in base64Images {
                    if base64Image != "NoPoster" {
                        guard let imageData = convertBase64ToData(base64String: base64Image) else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string Image to Data. Invalid base 64 string.")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            return
                        }
                        splashImageDataArray.append(imageData)
                    } else {
                        splashImageDataArray.append(nil)
                    }
                }
            }
            
//            var splashImageDataArray: [Data] = []
//            for base64Image in base64Images {
//                guard let imageData = convertBase64ToData(base64String: base64Image) else {
//                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to convert base 64 string to Data. Invalid base 64 string.")
//                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
//                    return
//                }
//                splashImageDataArray.append(imageData)
//            }
            
            var videoDataArray = [Data]()
            //Loads local Video files into array as Data Objects
            for video in videoFilesArray {
                let videoURL: URL = {
                    var url: URL!
                    let path = "file://\(libraryDirectory.path)/NoCloud/Files/\(video)"
                    if let urlPath = URL(string: path) {
                        url = urlPath
                    } else {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating local directory using \(video) as input")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                    return url
                }()
                if FileManager.default.fileExists(atPath: videoURL.path){
                    do {
                        let videoData = try Data.init(contentsOf: videoURL)
                        videoDataArray.append(videoData)
                    } catch {
                        print(">>> Error: \(error.localizedDescription)")
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local video file \(video) not found")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            let playerViewController = DeskercisesViewController()
            playerViewController.loadDeskercisesVideosFromData(videoArray: videoDataArray,
                                                               videoTitleArray: videoArrayTitle,
                                                               splashImageArr: splashImageDataArray,
                                                               isLiked: liked)
            { isLiked in
                playerViewController.pause()
                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func convertBase64ToData(base64String: String) -> Data? {
        if let data = Data(base64Encoded: base64String) {
            return data
        }
        else {
            //empty Data to be tested in the caller side
            return nil
        }
    }
}

