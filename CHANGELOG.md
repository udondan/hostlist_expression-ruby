# Changelog

## [1.0.0](https://github.com/udondan/hostlist_expression-ruby/compare/v0.2.1...v1.0.0) (2026-09-15)


### ⚠ BREAKING CHANGES

* hostlist_expression("host.com") now returns ["host.com"] instead of "host.com".

### Bug Fixes

* always return an Array ([#12](https://github.com/udondan/hostlist_expression-ruby/issues/12)) ([48aff2f](https://github.com/udondan/hostlist_expression-ruby/commit/48aff2f3695433352aa63aabdb6a5b2d2ce52cd9))
* compare numeric range bounds numerically ([322c9fd](https://github.com/udondan/hostlist_expression-ruby/commit/322c9fdea3845ee4f4ad2cfec05db301e45437aa))
* derive zero padding from leading zeros, not the first bound ([9d4eee5](https://github.com/udondan/hostlist_expression-ruby/commit/9d4eee50c9717aa38d7a875d01daf8703aea91c2))
* derive zero padding from leading zeros, not the first bound ([86148f6](https://github.com/udondan/hostlist_expression-ruby/commit/86148f69ed31d83a99072ddcf0057b19747cb947))
