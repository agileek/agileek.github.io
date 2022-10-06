---
layout: post
title: 'The "perfect" SVG Turtle shell'
categories: [software]
date: 2022-09-26
tags: [software, rust, svg, hexagon]
---

## Context

![2D_football][2D_football]{: .float_image}

My wife is an artisan seamstress and uses the industry's fabric scraps (Something called UpCycling), so she ends up with a lot of small pieces of fabric and search new smart ways to use them.

One of her (many) ideas was to create a small turtle, where its shell would be a patchwork (So she can reuse really small parts).
With that in mind, she started playing with hexagons, circles and stuff.

The main issue, once she found a model she was happy with (a sort of 2D football ball), was to be able to easily play with the drawing parameters.

That's where I can help! (And have an excuse for geeking a little)


## It's all about geometry[^1]

What we want is two hexagons, one inside the other, and the biggest hexagon should have a rounded outer line (so, that's not an hexagon right?)

Let's start with two circles ![two_circles][two_circles]{: .small_image}

Then, draw an hexagon in each ![circles_and_hexagons][circles_and_hexagons]{: .small_image}

Now, we can just remove the small circle, link each hexagon's vertex with each other, and remove the big hexagon and voilà! ![turtle_shell][turtle_shell]{: .small_image}


#### Some code

Of course we can do that [with a compass][with_a_compass], but were is the fun in that (plus, we did not have one big enough for what we wanted to do).

We wanted to be able to tweak the parameters of the turtle shell.

So I used a little bit of rust to draw an SVG. I used a crate called, well, `svg` and I hoped I would have some strong typings in the circles and lines parameters. But I did not, so I ended up setting some string parameters, and I don't think rust type system is really helpful here :(

Anyway, here is the code I used:

```rust
use std::ops::{Div, Mul};

use svg::node::element::{Circle, Line, Polygon};
use svg::Document;

struct HexagonCoordinate {
    x: f32,
    y: f32,
}

fn hexagon(radius: i32) -> [HexagonCoordinate; 6] {
    // hexagon formula: https://www.quora.com/How-can-you-find-the-coordinates-in-a-hexagon
    let vertex_b_x: f32 = radius as f32 / 2.0;
    let vertex_b_y = f32::sqrt(3.0).mul(radius as f32).div(2.0);
    [
        // A
        HexagonCoordinate {
            x: radius as f32,
            y: 0.0,
        },
        // B
        HexagonCoordinate {
            x: vertex_b_x,
            y: vertex_b_y,
        },
        // C
        HexagonCoordinate {
            x: -vertex_b_x,
            y: vertex_b_y,
        },
        // D
        HexagonCoordinate {
            x: -radius as f32,
            y: 0.0,
        },
        // E
        HexagonCoordinate {
            x: -vertex_b_x,
            y: -vertex_b_y,
        },
        // F
        HexagonCoordinate {
            x: vertex_b_x,
            y: -vertex_b_y,
        },
    ]
}

fn to_points(coords: &[HexagonCoordinate; 6]) -> String {
    coords
        .iter()
        .map(|coord| format!("{},{}", coord.x, coord.y))
        .collect::<Vec<String>>()
        .join(" ")
}

fn main() {
    let width = 500;
    let height = 500;
    let circle_radius = 250;
    let small_hexagon_radius = 100;
    let big_hexagon_radius = circle_radius;

    let center_x = width / 2;
    let center_y = height / 2;

    let shp = hexagon(small_hexagon_radius);
    let bhp = hexagon(big_hexagon_radius);

    let small_hexagon = Polygon::new()
        .set("points", to_points(&shp))
        .set("transform", format!("translate({center_x},{center_y})"))
        .set("stroke-width", 3)
        .set("stroke", "black")
        .set("fill", "none");

    let circle = Circle::new()
        .set("cx", center_x)
        .set("cy", center_y)
        .set("r", circle_radius)
        .set("stroke-width", 3)
        .set("stroke", "black")
        .set("fill", "none");

    let mut document = Document::new()
        .set("height", height)
        .set("width", width)
        .add(small_hexagon)
        .add(circle);

    for coord in 0..6 {
        let line = Line::new()
            .set("x1", shp[coord].x)
            .set("y1", shp[coord].y)
            .set("x2", bhp[coord].x)
            .set("y2", bhp[coord].y)
            .set("transform", format!("translate({center_x},{center_y})"))
            .set("stroke-width", 3)
            .set("stroke", "black");
        document = document.add(line);
    }

    svg::save("image.svg", &document).unwrap();
}


#[cfg(test)]
mod tests {
    use crate::{hexagon, to_points};

    #[test]
    fn translate_to_points() {
        let tested = hexagon(100);
        assert_eq!(to_points(&tested), "100,0 50,86.60254 -50,86.60254 -100,0 -50,-86.60254 50,-86.60254");
    }
}
```



[2D_football]: /images/posts/turtle/2d_football.jpg
[two_circles]: /images/posts/turtle/two_circles.png
[circles_and_hexagons]: /images/posts/turtle/circles_and_hexagons.png
[turtle_shell]: /images/posts/turtle/turtle_shell.png
[^1]: [How to Draw a Hexagon][draw_hexagon]

[draw_hexagon]: https://www.quora.com/How-can-you-find-the-coordinates-in-a-hexagon
[with_a_compass]: https://www.wikihow.com/Draw-a-Hexagon
