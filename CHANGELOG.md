# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.2.16] - 2024-11-29

### Added

- Metrics API support (https://github.com/mailgun/mailgun-ruby/pull/326)

## [1.2.15] - 2024-02-13

### Fixed

- Remove Openstruct usage (- Remove OpenStruct usage, will warn in Ruby 3.4, raise in Ruby 3.5 (https://github.com/mailgun/mailgun-ruby/issues/321)).
- Error handling (- Work around error responses without message property (https://github.com/mailgun/mailgun-ruby/pull/324)).

## [1.2.14] - 2024-02-13

### Added

- Tags CRUD support (https://github.com/mailgun/mailgun-ruby/pull/316)
- Additional Domain Endpoints (https://github.com/mailgun/mailgun-ruby/pull/314)
- Webhooks Update Method (https://github.com/mailgun/mailgun-ruby/pull/305)
- Add support for AMP HTML (https://github.com/mailgun/mailgun-ruby/pull/304)
- Add support for AMP HTML (https://github.com/mailgun/mailgun-ruby/pull/304)

### Fixed

- Typos in docs, specs (- Add support for AMP HTML (https://github.com/mailgun/mailgun-ruby/pull/304)).

## [1.2.13] - 2023-11-25

### Added

- Subaccounts API support (https://github.com/mailgun/mailgun-ruby/pull/310).

## [1.2.12] - 2023-10-22

### Added

- Templates CRUD support (https://github.com/mailgun/mailgun-ruby/pull/300).

### Fixed

- transform_for_mailgun block iteration issue (https://github.com/mailgun/mailgun-ruby/pull/298).
- Typos in several files (https://github.com/mailgun/mailgun-ruby/pull/297).