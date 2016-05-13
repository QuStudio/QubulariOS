//
//  SerializingParsing.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

typealias Structure = [String: AnyObject]

protocol Parsable {
    init(from source: [String: AnyObject]) throws
}

enum ParseError: ErrorType {
    case parseFailed
    case morpheme
    case foreignLexeme
    case nativeLexeme
    case user
    case entry
    case version
}

protocol Serializable {
    var representation: [String: AnyObject] { get }
}

protocol Convertible: Parsable, Serializable { }

extension Morpheme: Convertible {
    var representation: [String : AnyObject] {
        let typestr: String
        switch type {
        case .CaseSensitive:
            typestr = "case-sensitive"
        case .General:
            typestr = "general"
        }
        let dict: [String: AnyObject] = [
            "string": view,
            "type": typestr
        ]
        return dict
    }
    init(from source: [String: AnyObject]) throws {
        guard let string = source["string"] as? String,
            typestr = source["type"] as? String else { throw ParseError.morpheme }
        let kind: Kind
        switch typestr {
        case "general":
            kind = .General
        case "case-sensitive":
            kind = .CaseSensitive
        default:
            throw ParseError.parseFailed
        }
        self.init(string, type: kind)
    }
}

extension NativeLexeme: Convertible {
    var representation: [String : AnyObject] {
        let dict: [String: AnyObject] = [
            "lemma": lemma.representation,
            "meaning": meaning,
            "usage": usage.rawValue
        ]
        return dict
    }
    init(from source: [String : AnyObject]) throws {
        guard let lemma = (source["lemma"] as? Structure).flatMap({ try? Morpheme(from: $0) }),
            meaning = source["meaning"] as? String,
            usage = (source["usage"] as? String).flatMap({ Usage(rawValue: $0) }) else { throw ParseError.nativeLexeme }
        self.lemma = lemma
        self.meaning = meaning
        self.usage = usage
    }
}

extension ForeignLexeme: Convertible {
    var representation: [String : AnyObject] {
        let dict: Structure = [
            "lemma": lemma.representation,
            "forms": forms.map({ $0.representation }),
            "origin": origin.representation,
            "meaning": meaning,
            "permissibility": permissibility.rawValue
        ]
        return dict
    }
    init(from source: [String : AnyObject]) throws {
        guard let lemma = (source["lemma"] as? Structure).flatMap({ try? Morpheme(from: $0) }),
            forms = (source["forms"] as? [Structure]).flatMap({ $0.flatMap({ try? Morpheme(from: $0) }) }),
            origin = (source["origin"] as? Structure).flatMap({ try? Morpheme(from: $0) }),
            meaning = source["meaning"] as? String,
            permissibility = (source["permissibility"] as? String).flatMap({ Permissibility(rawValue: $0) }) else { throw ParseError.foreignLexeme }
        self.lemma = lemma
        self.forms = forms
        self.origin = origin
        self.meaning = meaning
        self.permissibility = permissibility
    }
}

extension User: Convertible {
    var representation: [String : AnyObject] {
        let statusstr: String
        switch status {
        case .BoardMember:
            statusstr = "board-member"
        case .Regular:
            statusstr = "regular"
        }
        let dict: Structure = [
            "id": id,
            "username": username,
            "status": statusstr
        ]
        return dict
    }
    init(from source: [String : AnyObject]) throws {
        guard let id = source["id"] as? Int,
            username = source["username"] as? String,
            statusstr = source["status"] as? String else { throw ParseError.user }
        let status: Status
        switch statusstr {
        case "board-member":
            status = .BoardMember
        case "regular":
            status = .BoardMember
        default:
            throw ParseError.parseFailed
        }
        self.id = id
        self.username = username
        self.status = status
    }
}

extension Entry: Convertible {
    var representation: [String : AnyObject] {
        var dict: Structure = [
            "id": id,
            "foreign": foreign.representation,
            "natives": natives.map({ $0.representation }),
        ]
        if let author = author { dict["author"] = author.representation }
        return dict
    }
    init(from source: [String : AnyObject]) throws {
        guard let id = source["id"] as? Int,
            foreign = try (source["foreign"] as? Structure).flatMap({ try ForeignLexeme(from: $0) }),
            natives = try (source["natives"] as? [Structure]).flatMap({ try $0.flatMap({ try NativeLexeme(from: $0) }) }) else { throw ParseError.entry }
        self.id = id
        self.foreign = foreign
        self.natives = Set(natives)
        self.author = (source["author"] as? Structure).flatMap({ try? User(from: $0) })
    }
}

extension VocabularyVersion: Convertible {
    var representation: [String : AnyObject] {
        let dict: Structure = [
            "major": major,
            "minor": minor,
            "patch": patch
        ]
        return dict
    }
    init(from source: [String : AnyObject]) throws {
        guard let major = source["major"] as? Int,
            minor = source["minor"] as? Int,
            patch = source["patch"] as? Int else { throw ParseError.version }
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}
