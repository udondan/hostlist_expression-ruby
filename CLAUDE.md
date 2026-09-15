# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
bundle install
bundle exec rake                                        # default task: RuboCop, then RSpec
bundle exec rubocop                                     # lint only (CI runs this on Ruby 4.0)
bundle exec rspec                                       # tests only (CI matrix: Ruby 3.3, 3.4, 4.0)
bundle exec rspec spec/hostlist_expression_spec.rb:42   # single example by line
bundle exec rspec -e "numeric from 1 to 99"             # single example by name
```

Specs run in random order with warnings enabled (`spec/spec_helper.rb`). Minimum Ruby is 3.3 (gemspec and `.rubocop.yml` TargetRubyVersion).

## Architecture

The whole gem is one top-level method, `hostlist_expression(expression, separator = [":", "-"])`, in `lib/hostlist_expression.rb`. There is no module or class, which is why `RSpec/DescribeClass` is disabled. The gemspec's `s.files` lists only that file, so any new lib file must be added there too.

How expansion works:

- Always returns an Array. Input that doesn't look like a hostlist expression comes back as a single-element Array.
- Each `[...]` bracket group is processed in order. Its content is split on `,` into sequence items, and each item is split on the separator characters into a range.
- A range must be all numeric, all single uppercase letters, or all single lowercase letters. Anything else raises a plain `RuntimeError`. Bounds are sorted, so `[9-1]` equals `[1-9]`.
- Zero padding applies only when a bound has a leading zero (`[01-99]`, `[1-010]`). The width is the longest bound.
- The cartesian product is built by replacing each bracket group in every partial host. The result is de-duplicated with `uniq`, which also hides duplicate replacements that the inner `hosts.each` loop creates.

RuboCop's metrics cops are excluded for `lib/hostlist_expression.rb` on purpose. Don't split the method just to satisfy them.

## Releases & dependencies

- Versioning is automated by release-please (`release-type: ruby`). It bumps `s.version` in `hostlist_expression.gemspec` and writes `CHANGELOG.md`. Tags are `v`-prefixed. Don't bump the version by hand.
- PR titles must be conventional commits (enforced by `mr-title.yml`), because release-please derives versions from them.
- release-please updates the gem version in the `PATH` section of `Gemfile.lock` but not in `CHECKSUMS`. Frozen-mode `bundle install` rejects that, so `release-please.yml` runs `bundle lock` on the release branch. If you change the gemspec version or dependencies locally, run `bundle lock` as well.
- `release-automerge-weekly.yml` squash-merges the open release PR every Sunday. Publishing a GitHub release triggers `publish.yml`, which pushes to RubyGems via trusted publishing (OIDC, `rubygems` environment, no API key).
- Development gems in `Gemfile` are pinned to exact versions. Renovate keeps them updated with `chore:` commits and automerges them.
