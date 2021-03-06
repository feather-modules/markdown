//
//  MarkdownFilter.swift
//  MarkdownModule
//
//  Created by Tibor Bodecs on 2020. 07. 18..
//

import FeatherCore
import Ink

/// markdown filter
struct MarkdownFilter: ContentFilter {

    /// unique key for the filter
    var key: String { "markdown-ink" }
    /// label for the filter
    var label: String { "Markdown (Ink)" }

    /// render markdown content using the MarkdownParser method, then place the result into a center aligned div  
    func filter(_ input: String, _ req: Request) -> EventLoopFuture<String> {
        var parser = MarkdownParser()
        let modifier = Modifier(target: .images) { html, markdown in
            return html.replacingOccurrences(of: "<img src", with: "<img class=\"\" src")
        }
        parser.addModifier(modifier)

        let html = parser.html(from: input.replacingOccurrences(of: "\r", with: "\n"))
        let result = """
        <div class="container">
            <section>
                \(html)
            </section>
        </div>
        """
        return req.eventLoop.future(result)
    }
}
