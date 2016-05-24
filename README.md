## What is this?

This project shows how you could use [webpack's css-modules](https://github.com/webpack/css-loader) in Elm's development. This is an alternative approach as compared to [elm-css](https://github.com/rtfeldman/elm-css), which is a more functional and pure approach towards declaring component styles.

CSS modules allow us to continue writing styles in familiar ways (CSS / SASS / LESS / Stylus, etc), yet gain the benefits of [local scoping](/src/Login.css) for classes. There is also 100% compatibility with doing animations, pseudo selectors, and media queries. You can also use also continue to use your favorite tooling around CSS like [autoprefixer](https://github.com/postcss/autoprefixer).

There are also escape hatches in case want to have a [global class selector](/src/Main.css). More information about the CSS Module specification [here](https://github.com/css-modules/css-modules).

## Requirements

- Node 6.x.x

- Elm 0.17.0


## Installation

1. `elm package install`

2. `npm install`


## Development

- `npm start`
