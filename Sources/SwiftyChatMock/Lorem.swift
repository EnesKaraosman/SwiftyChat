// MIT License
//
// Copyright (c) 2017-2019 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// swiftlint:disable identifier_name

import Foundation

// MARK: - Lorem

class Lorem {
    // MARK: Public

    /// Return a random word.
    ///
    /// - returns: Returns a random word.
    class func word() -> String {
        wordList.randomElement()!
    }

    /// Return an array of `count` words.
    ///
    /// - parameter count: The number of words to return.
    ///
    /// - returns: Returns an array of `count` words.
    class func words(nbWords: Int = 3) -> [String] {
        (1...nbWords).map { _ in
            word()
        }
    }

    /// Return a string of `count` words.
    ///
    /// - parameter count: The number of words the string should contain.
    ///
    /// - returns: Returns a string of `count` words.
    class func words(nbWords: Int = 3) -> String {
        words(nbWords: nbWords).joined(separator: " ")
    }

    /// Generate a sentence of `nbWords` words.
    /// - parameter nbWords:  The number of words the sentence should contain.
    /// - parameter variable: If `true`, the number of words will vary between
    /// +/- 40% of `nbWords`.
    /// - returns:
    class func sentence(nbWords: Int = 6, variable: Bool = true) -> String {
        if nbWords <= 0 {
            return ""
        }

        let result: String = words(nbWords: variable ? nbWords.randomize(variation: 40) : nbWords)

        return result.firstCapitalized + "."
    }

    /// Generate an array of sentences.
    /// - parameter nbSentences: The number of sentences to generate.
    ///
    /// - returns: Returns an array of random sentences.
    class func sentences(nbSentences: Int = 3) -> [String] {
        (0 ..< nbSentences).map { _ in sentence() }
    }

    /// Generate a paragraph with `nbSentences` random sentences.
    /// - parameter nbSentences: The number of sentences the paragraph should
    /// contain.
    /// - parameter variable:    If `true`, the number of sentences will vary
    /// between +/- 40% of `nbSentences`.
    /// - returns: Returns a paragraph with `nbSentences` random sentences.
    class func paragraph(nbSentences: Int = 3, variable: Bool = true) -> String {
        if nbSentences <= 0 {
            return ""
        }

        return sentences(nbSentences: variable ? nbSentences.randomize(variation: 40) : nbSentences)
            .joined(separator: " ")
    }

    /// Generate an array of random paragraphs.
    /// - parameter nbParagraphs: The number of paragraphs to generate.
    /// - returns: Returns an array of `nbParagraphs` paragraphs.
    class func paragraphs(nbParagraphs: Int = 3) -> [String] {
        (0 ..< nbParagraphs).map { _ in paragraph() }
    }

    /// Generate a string of random paragraphs.
    /// - parameter nbParagraphs: The number of paragraphs to generate.
    /// - returns: Returns a string of random paragraphs.
    class func paragraphs(nbParagraphs: Int = 3) -> String {
        paragraphs(nbParagraphs: nbParagraphs).joined(separator: "\n\n")
    }

    /// Generate a string of at most `maxNbChars` characters.
    /// - parameter maxNbChars: The maximum number of characters the string
    /// should contain.
    /// - returns: Returns a string of at most `maxNbChars` characters.
    class func text(maxNbChars: Int = 200) -> String {
        var result: [String] = []

        if maxNbChars < 5 {
            return ""
        } else if maxNbChars < 25 {
            while result.count == 0 {
                var size = 0

                while size < maxNbChars {
                    let w = (size != 0 ? " " : "") + word()
                    result.append(w)
                    size += w.count
                }

                _ = result.popLast()
            }
        } else if maxNbChars < 100 {
            while result.count == 0 {
                var size = 0

                while size < maxNbChars {
                    let s = (size != 0 ? " " : "") + sentence()
                    result.append(s)
                    size += s.count
                }

                _ = result.popLast()
            }
        } else {
            while result.count == 0 {
                var size = 0

                while size < maxNbChars {
                    let p = (size != 0 ? "\n" : "") + paragraph()
                    result.append(p)
                    size += p.count
                }

                _ = result.popLast()
            }
        }

        return result.joined(separator: "")
    }

    // MARK: Private

    private static let wordList = [
        "hey", "hello", "sure", "thanks", "awesome", "great", "sounds",
        "good", "perfect", "nice", "cool", "yeah", "okay", "got", "it",
        "that", "looks", "amazing", "love", "the", "new", "update",
        "have", "you", "tried", "this", "one", "yet", "just", "saw",
        "your", "message", "what", "do", "think", "about", "it",
        "really", "like", "how", "works", "can", "we", "meet",
        "tomorrow", "at", "the", "office", "let", "me", "know",
        "when", "free", "I", "was", "thinking", "maybe", "could",
        "check", "out", "that", "place", "near", "the", "park",
        "did", "see", "the", "latest", "version", "much", "better",
        "now", "with", "dark", "mode", "and", "everything",
        "sending", "you", "the", "file", "right", "now", "should",
        "be", "in", "your", "inbox", "already", "no", "worries",
        "take", "your", "time", "not", "a", "rush", "happy",
        "to", "help", "anytime", "of", "course", "absolutely",
        "for", "sure", "definitely", "on", "my", "way", "there",
        "running", "a", "bit", "late", "sorry", "about", "that",
        "all", "set", "ready", "to", "go", "looking", "forward",
        "to", "catching", "up", "soon", "miss", "those", "days",
        "remember", "last", "summer", "so", "much", "fun",
        "by", "the", "way", "here", "is", "something", "interesting",
        "wait", "until", "you", "hear", "this", "pretty", "exciting",
        "stuff", "going", "on", "lately", "been", "working", "hard",
        "finally", "finished", "the", "project", "feels", "so", "good",
        "congratulations", "well", "done", "proud", "of", "you",
        "thank", "you", "so", "much", "means", "a", "lot",
        "hope", "you", "are", "doing", "well", "today", "fine",
        "just", "wanted", "to", "say", "hi", "and", "see",
        "how", "things", "are", "going", "everything", "is", "great"
    ]
}

private extension String {
    var firstCapitalized: String {
        var string = self
        string.replaceSubrange(
            string.startIndex ... string.startIndex,
            with: String(string[string.startIndex]).capitalized
        )

        return string
    }
}

private extension Int {
    func randomize(variation: Int) -> Int {
        let randomInt = Int.random(in: (100 - variation)..<(100+variation))
        let multiplier = Double(randomInt) / 100
        let randomized = Double(self) * multiplier

        return Int(randomized) + 1
    }
}
