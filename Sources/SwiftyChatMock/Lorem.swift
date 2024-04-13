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
        "alias", "consequatur", "aut", "perferendis", "sit", "voluptatem",
        "accusantium", "doloremque", "aperiam", "eaque", "ipsa", "quae", "ab",
        "illo", "inventore", "veritatis", "et", "quasi", "architecto",
        "beatae", "vitae", "dicta", "sunt", "explicabo", "aspernatur", "aut",
        "odit", "aut", "fugit", "sed", "quia", "consequuntur", "magni",
        "dolores", "eos", "qui", "ratione", "voluptatem", "sequi", "nesciunt",
        "neque", "dolorem", "ipsum", "quia", "dolor", "sit", "amet",
        "consectetur", "adipisci", "velit", "sed", "quia", "non", "numquam",
        "eius", "modi", "tempora", "incidunt", "ut", "labore", "et", "dolore",
        "magnam", "aliquam", "quaerat", "voluptatem", "ut", "enim", "ad",
        "minima", "veniam", "quis", "nostrum", "exercitationem", "ullam",
        "corporis", "nemo", "enim", "ipsam", "voluptatem", "quia", "voluptas",
        "sit", "suscipit", "laboriosam", "nisi", "ut", "aliquid", "ex", "ea",
        "commodi", "consequatur", "quis", "autem", "vel", "eum", "iure",
        "reprehenderit", "qui", "in", "ea", "voluptate", "velit", "esse",
        "quam", "nihil", "molestiae", "et", "iusto", "odio", "dignissimos",
        "ducimus", "qui", "blanditiis", "praesentium", "laudantium", "totam",
        "rem", "voluptatum", "deleniti", "atque", "corrupti", "quos",
        "dolores", "et", "quas", "molestias", "excepturi", "sint",
        "occaecati", "cupiditate", "non", "provident", "sed", "ut",
        "perspiciatis", "unde", "omnis", "iste", "natus", "error",
        "similique", "sunt", "in", "culpa", "qui", "officia", "deserunt",
        "mollitia", "animi", "id", "est", "laborum", "et", "dolorum", "fuga",
        "et", "harum", "quidem", "rerum", "facilis", "est", "et", "expedita",
        "distinctio", "nam", "libero", "tempore", "cum", "soluta", "nobis",
        "est", "eligendi", "optio", "cumque", "nihil", "impedit", "quo",
        "porro", "quisquam", "est", "qui", "minus", "id", "quod", "maxime",
        "placeat", "facere", "possimus", "omnis", "voluptas", "assumenda",
        "est", "omnis", "dolor", "repellendus", "temporibus", "autem",
        "quibusdam", "et", "aut", "consequatur", "vel", "illum", "qui",
        "dolorem", "eum", "fugiat", "quo", "voluptas", "nulla", "pariatur",
        "at", "vero", "eos", "et", "accusamus", "officiis", "debitis", "aut",
        "rerum", "necessitatibus", "saepe", "eveniet", "ut", "et",
        "voluptates", "repudiandae", "sint", "et", "molestiae", "non",
        "recusandae", "itaque", "earum", "rerum", "hic", "tenetur", "a",
        "sapiente", "delectus", "ut", "aut", "reiciendis", "voluptatibus",
        "maiores", "doloribus", "asperiores", "repellat"
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
