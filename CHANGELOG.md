# Changelog

All notable changes to this project will be documented in this file.

## [1.3.8] - 2025-07-23

- Respond with error message for 400 Bad Request

## [1.3.7] - 2025-06-29

- Use proxy_url passed to constructor (https://github.com/mailgun/mailgun-ruby/pull/342)
- Refactor to use UserNotifier instead of UserMailer for consistency (https://github.com/mailgun/mailgun-ruby/pull/323)
- Add option to specify api key and host when initializing Address api (https://github.com/mailgun/mailgun-ruby/pull/328)
- Remove base64 dependency (https://github.com/mailgun/mailgun-ruby/pull/313)
- DE-1547: Support for the logs API (https://github.com/mailgun/mailgun-ruby/pull/356)

## [1.3.6] - 2025-05-30

### Fixed

- Fix Suppressions paging not working (https://github.com/mailgun/mailgun-ruby/pull/355)
- CI improvements

## [1.3.5] - 2025-04-07

### Fixed

- Set attachment filename on upload IO (https://github.com/mailgun/mailgun-ruby/pull/351)

## [1.3.4] - 2025-03-28

### Added

- Increase max tag limit to 10 per message (https://github.com/mailgun/mailgun-ruby/pull/350)

## [1.3.3] - 2025-03-25

### Fixed

- Fix specs (https://github.com/mailgun/mailgun-ruby/pull/345)
- Fix sending attachments via faraday (https://github.com/mailgun/mailgun-ruby/pull/347)

## [1.3.2] - 2025-01-30

### Fixed

- Use Faraday::FlatParamsEncoder (https://github.com/mailgun/mailgun-ruby/pull/334)
- Update Message Builder doc (https://github.com/mailgun/mailgun-ruby/pull/338)
- Add Domain api version warnings (https://github.com/mailgun/mailgun-ruby/pull/339)

## [1.3.1] - 2025-01-26

### Fixed

- Fix mock mailgun responds (https://github.com/mailgun/mailgun-ruby/pull/331)
- Change mime-types to runtime dependency (https://github.com/mailgun/mailgun-ruby/pull/332)

## [1.3.0] - 2025-01-26

### Added

- Faraday as http client (https://github.com/mailgun/mailgun-ruby/pull/330)

### Fixed

- Added documentation for updating webhook (https://github.com/mailgun/mailgun-ruby/pull/325)
- Remove duplicated entry from CHANGELOG (https://github.com/mailgun/mailgun-ruby/pull/318)
- Update template and metrics docs (https://github.com/mailgun/mailgun-ruby/pull/329)

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
