---
categories:
- software
date: "2024-12-20T00:00:00Z"
draft: true
tags:
- software
title: AI is killing the web
---

Yeah, I know the are a lot of articles with titles like this.\
I just want to share my latest experience with AI that left me just shocked.

A couple of weeks ago I was geeking around, learning [Dioxus][dioxus] framework.[^1]

After playing with it for a while, I started to look at what could be missing in Dioxus for it to be really better.\
One obvious thing (in my opinion) would be to have type-safe CSS.\
I really like the [styled-components][styled-components] approach in the typescript ecosystem, and I wanted something like that.\
After some digging, I could not find anything[^2] useful.

Then I found something called dioxus-odin on a github.io page of some guy named ryanparsley that seemed to be exactly what I wanted.
And it was really well ranked in duckduckgo!

First result when searching for `dioxus styledcomponent`

[expand]

![duckduckgosearch][duckduckgosearch]

[/expand]

Hooray! It was exactly what I was looking for!
Even when looking at the code examples we can see it's a good fit for what I want to do!

```rust
use dioxus::prelude::*;
use dioxus_free_css::{css, Style};

fn StyledComponent(cx: Scope) -> Element {
    let style = css!(
        "
        .container {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 5px;
        }
        .title {
            color: #333;
            font-size: 24px;
        }
        "
    );

    cx.render(rsx! {
        Style { css: style }
        div { class: "container",
            h1 { class: "title", "Styled Component" }
            p { "This component is styled using CSS-in-Rust." }
        }
    })
}
```

Ok great, now I just have to look into the dioxus_free_css crate !

Wait a minute, I cannot find anything about this crate, how strange.\
After searching into the archives, replacing `_` with `-`, and other shenanigans we do everyday, I had to face the evidence: This crate does **not** exist!\
How is this possible?\
What is this site talking about?

Wait, dioxus odin does not exists outside this website either?



[dioxus]: https://dioxuslabs.com/
[styled-components]: https://styled-components.com/
[^1]: I really enjoyed dioxus and I think this could be a really good alternative to the typescript ecosystem I'm using in my professional job, when I work on websites.
[^2]: If you do know/use something like that in rust, please tell me!

[duckduckgosearch]: /images/posts/ai_killing_web/duckduckgo_search.png
