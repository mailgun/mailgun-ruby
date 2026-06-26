# Changelog

## [v1.4.4](https://github.com/mailgun/mailgun-ruby/tree/v1.4.4) (2026-05-26)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.4.3...v1.4.4)

**Merged pull requests:**

- DE-1784: Account Webhooks - Add docs [\#392](https://github.com/mailgun/mailgun-ruby/pull/392) ([alex-leb](https://github.com/alex-leb))
- DE-1783: Account Webhooks - Add specs [\#391](https://github.com/mailgun/mailgun-ruby/pull/391) ([alex-leb](https://github.com/alex-leb))
- DE-1782: Account Webhooks - Add 6 missing methods  [\#390](https://github.com/mailgun/mailgun-ruby/pull/390) ([alex-leb](https://github.com/alex-leb))
- DE-1776: Domains - Extract Domain Keys [\#389](https://github.com/mailgun/mailgun-ruby/pull/389) ([alex-leb](https://github.com/alex-leb))
- DE-1771: Domain Webhooks - Refactor and deprecate existing methods [\#388](https://github.com/mailgun/mailgun-ruby/pull/388) ([alex-leb](https://github.com/alex-leb))

## [v1.4.3](https://github.com/mailgun/mailgun-ruby/tree/v1.4.3) (2026-03-27)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.4.2...v1.4.3)

**Merged pull requests:**

- DE-1754: Add client\_spec.rb and response\_spec.rb [\#386](https://github.com/mailgun/mailgun-ruby/pull/386) ([alex-leb](https://github.com/alex-leb))
- DE-1753: add api\_version\_checker\_spec.rb  [\#385](https://github.com/mailgun/mailgun-ruby/pull/385) ([alex-leb](https://github.com/alex-leb))
- DE-1740: add suppressions specs  [\#384](https://github.com/mailgun/mailgun-ruby/pull/384) ([alex-leb](https://github.com/alex-leb))
- DE-1718: Add SimpleCov to CI [\#383](https://github.com/mailgun/mailgun-ruby/pull/383) ([alex-leb](https://github.com/alex-leb))
- DE-1731: Add rubocop rspec and rake [\#382](https://github.com/mailgun/mailgun-ruby/pull/382) ([alex-leb](https://github.com/alex-leb))
- DE-1717: Add rubocop to CI [\#380](https://github.com/mailgun/mailgun-ruby/pull/380) ([alex-leb](https://github.com/alex-leb))
- DE-1716: Fix rubocop errors [\#379](https://github.com/mailgun/mailgun-ruby/pull/379) ([alex-leb](https://github.com/alex-leb))

## [v1.4.2](https://github.com/mailgun/mailgun-ruby/tree/v1.4.2) (2026-01-29)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.4.1...v1.4.2)

**Closed issues:**

- Mailgun::Client custom logger [\#343](https://github.com/mailgun/mailgun-ruby/issues/343)

**Merged pull requests:**

- DE-1714: Add rubocop gem [\#378](https://github.com/mailgun/mailgun-ruby/pull/378) ([alex-leb](https://github.com/alex-leb))
- DE-1650: Tags New - Add missing documentation and specs [\#377](https://github.com/mailgun/mailgun-ruby/pull/377) ([alex-leb](https://github.com/alex-leb))

## [v1.4.1](https://github.com/mailgun/mailgun-ruby/tree/v1.4.1) (2025-12-28)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.4.0...v1.4.1)

**Merged pull requests:**

- DE-1678: Domains - Remove deprecated methods [\#376](https://github.com/mailgun/mailgun-ruby/pull/376) ([alex-leb](https://github.com/alex-leb))
- DE-1675: Add ruby versions '3.2', '3.3' to ci.yml [\#375](https://github.com/mailgun/mailgun-ruby/pull/375) ([alex-leb](https://github.com/alex-leb))
- DE-1674: Remove require calls from analytics\_tags.rb [\#374](https://github.com/mailgun/mailgun-ruby/pull/374) ([alex-leb](https://github.com/alex-leb))
- DE-1623: Domains - add missing specs [\#373](https://github.com/mailgun/mailgun-ruby/pull/373) ([alex-leb](https://github.com/alex-leb))
- Loosen requirement for faraday multipart - Support Ruby 4.0 [\#372](https://github.com/mailgun/mailgun-ruby/pull/372) ([frederikspang](https://github.com/frederikspang))
- Fix NoMethodError in get\_bounce and get\_complaint [\#371](https://github.com/mailgun/mailgun-ruby/pull/371) ([nehresma](https://github.com/nehresma))
- Use zeitwerk to load gem [\#370](https://github.com/mailgun/mailgun-ruby/pull/370) ([n-rodriguez](https://github.com/n-rodriguez))
- DE-1618: Tags - Add missing endpoints and refactor existing [\#369](https://github.com/mailgun/mailgun-ruby/pull/369) ([alex-leb](https://github.com/alex-leb))
- DE-1617: Domains - Update specs and documentation [\#368](https://github.com/mailgun/mailgun-ruby/pull/368) ([alex-leb](https://github.com/alex-leb))
- Honour globally configured `test_mode` as set in global config \(using `Mailgun.configure`\) [\#366](https://github.com/mailgun/mailgun-ruby/pull/366) ([eflukx](https://github.com/eflukx))

## [v1.4.0](https://github.com/mailgun/mailgun-ruby/tree/v1.4.0) (2025-09-29)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.10...v1.4.0)

**Merged pull requests:**

- DE-1611: Domains - Add missing endpoints and refactor existing ones [\#365](https://github.com/mailgun/mailgun-ruby/pull/365) ([alex-leb](https://github.com/alex-leb))

## [v1.3.10](https://github.com/mailgun/mailgun-ruby/tree/v1.3.10) (2025-08-28)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.9...v1.3.10)

**Closed issues:**

- Sending to /messages.mime broken with mailgun-ruby \>= 1.3.0 [\#353](https://github.com/mailgun/mailgun-ruby/issues/353)
- BatchMessage modifies stored test deliveries [\#344](https://github.com/mailgun/mailgun-ruby/issues/344)
- Switch to mini\_mime for memory savings [\#335](https://github.com/mailgun/mailgun-ruby/issues/335)

**Merged pull requests:**

- DE-1594: Add backwards compatibility for previous ruby versions [\#364](https://github.com/mailgun/mailgun-ruby/pull/364) ([alex-leb](https://github.com/alex-leb))
- DE-1593: Switch to mini\_mime for memory savings [\#363](https://github.com/mailgun/mailgun-ruby/pull/363) ([alex-leb](https://github.com/alex-leb))

## [v1.3.9](https://github.com/mailgun/mailgun-ruby/tree/v1.3.9) (2025-07-28)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.8...v1.3.9)

**Closed issues:**

- Fetching logs returns 400 error [\#358](https://github.com/mailgun/mailgun-ruby/issues/358)

**Merged pull requests:**

- DE-1575: fix BatchMessage modifies stored test deliveries [\#362](https://github.com/mailgun/mailgun-ruby/pull/362) ([alex-leb](https://github.com/alex-leb))
- DE-1545: fix messages.mime broken [\#361](https://github.com/mailgun/mailgun-ruby/pull/361) ([alex-leb](https://github.com/alex-leb))

## [v1.3.8](https://github.com/mailgun/mailgun-ruby/tree/v1.3.8) (2025-07-23)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.7...v1.3.8)

**Closed issues:**

- Attachments to emails not being sent \(again\) [\#359](https://github.com/mailgun/mailgun-ruby/issues/359)
- Ruby SDK for route creation not working as expected [\#357](https://github.com/mailgun/mailgun-ruby/issues/357)
- Support for the logs API [\#346](https://github.com/mailgun/mailgun-ruby/issues/346)

**Merged pull requests:**

- DE-1570: Respond with error message for 400 Bad Request [\#360](https://github.com/mailgun/mailgun-ruby/pull/360) ([alex-leb](https://github.com/alex-leb))

## [v1.3.7](https://github.com/mailgun/mailgun-ruby/tree/v1.3.7) (2025-06-25)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.6...v1.3.7)

**Closed issues:**

- Suppressions paging not working [\#352](https://github.com/mailgun/mailgun-ruby/issues/352)
- Inline image attachments broken with ActionMailer for Version 1.3.3 [\#348](https://github.com/mailgun/mailgun-ruby/issues/348)

**Merged pull requests:**

- DE-1547: Support for the logs API [\#356](https://github.com/mailgun/mailgun-ruby/pull/356) ([alex-leb](https://github.com/alex-leb))
- Use proxy\_url passed to constructor [\#342](https://github.com/mailgun/mailgun-ruby/pull/342) ([n-rodriguez](https://github.com/n-rodriguez))
- Add option to specify api key and host when initializing Address api [\#328](https://github.com/mailgun/mailgun-ruby/pull/328) ([phyllipy](https://github.com/phyllipy))
- Refactor to use UserNotifier instead of UserMailer for consistency [\#323](https://github.com/mailgun/mailgun-ruby/pull/323) ([leegeng](https://github.com/leegeng))
- Remove base64 dependency [\#313](https://github.com/mailgun/mailgun-ruby/pull/313) ([Earlopain](https://github.com/Earlopain))

## [v1.3.6](https://github.com/mailgun/mailgun-ruby/tree/v1.3.6) (2025-05-29)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.5...v1.3.6)

**Closed issues:**

- Switch from Travis to GithubActions [\#336](https://github.com/mailgun/mailgun-ruby/issues/336)

**Merged pull requests:**

- DE-1544: Fix Suppressions paging not working [\#355](https://github.com/mailgun/mailgun-ruby/pull/355) ([alex-leb](https://github.com/alex-leb))
- Limit ruby versions in ci.yml [\#354](https://github.com/mailgun/mailgun-ruby/pull/354) ([alex-leb](https://github.com/alex-leb))

## [v1.3.5](https://github.com/mailgun/mailgun-ruby/tree/v1.3.5) (2025-04-07)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.4...v1.3.5)

**Closed issues:**

- Filename for add\_attachment is not being set properly [\#349](https://github.com/mailgun/mailgun-ruby/issues/349)

**Merged pull requests:**

- Set attachment filename on upload IO [\#351](https://github.com/mailgun/mailgun-ruby/pull/351) ([tttffff](https://github.com/tttffff))

## [v1.3.4](https://github.com/mailgun/mailgun-ruby/tree/v1.3.4) (2025-03-28)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.3...v1.3.4)

**Closed issues:**

- Version 1.3.x breaks image mimepart values for images [\#341](https://github.com/mailgun/mailgun-ruby/issues/341)
- version 1.3.x breaks sending simple text/csv attachments [\#340](https://github.com/mailgun/mailgun-ruby/issues/340)

**Merged pull requests:**

- DE-1510: Increase max tag limit to 10 per message [\#350](https://github.com/mailgun/mailgun-ruby/pull/350) ([alex-leb](https://github.com/alex-leb))

## [v1.3.3](https://github.com/mailgun/mailgun-ruby/tree/v1.3.3) (2025-03-25)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.2...v1.3.3)

**Merged pull requests:**

- DE-1456: fix sending attachments via faraday [\#347](https://github.com/mailgun/mailgun-ruby/pull/347) ([alex-leb](https://github.com/alex-leb))
- DE-1420: fix specs [\#345](https://github.com/mailgun/mailgun-ruby/pull/345) ([alex-leb](https://github.com/alex-leb))

## [v1.3.2](https://github.com/mailgun/mailgun-ruby/tree/v1.3.2) (2025-01-30)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.1...v1.3.2)

**Closed issues:**

- Update Message Builder doc [\#327](https://github.com/mailgun/mailgun-ruby/issues/327)
- Abandoned dependency: rest-client abandoned in 2019 [\#287](https://github.com/mailgun/mailgun-ruby/issues/287)
- Actions are not being saved to the route [\#211](https://github.com/mailgun/mailgun-ruby/issues/211)

**Merged pull requests:**

- DE-1032: Add Domain api version warnings [\#339](https://github.com/mailgun/mailgun-ruby/pull/339) ([alex-leb](https://github.com/alex-leb))
- DE-1419: Update Message Builder doc [\#338](https://github.com/mailgun/mailgun-ruby/pull/338) ([alex-leb](https://github.com/alex-leb))
- DE-487: Use Faraday::FlatParamsEncoder [\#334](https://github.com/mailgun/mailgun-ruby/pull/334) ([alex-leb](https://github.com/alex-leb))

## [v1.3.1](https://github.com/mailgun/mailgun-ruby/tree/v1.3.1) (2025-01-26)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.3.0...v1.3.1)

**Closed issues:**

- Cannot load mime/types - Mime-types should be a runtime dependency [\#333](https://github.com/mailgun/mailgun-ruby/issues/333)

**Merged pull requests:**

- Fix: Change mime-types to runtime dependency [\#332](https://github.com/mailgun/mailgun-ruby/pull/332) ([jermaine](https://github.com/jermaine))
- fix mock mailgun responds [\#331](https://github.com/mailgun/mailgun-ruby/pull/331) ([mgrishko](https://github.com/mgrishko))

## [v1.3.0](https://github.com/mailgun/mailgun-ruby/tree/v1.3.0) (2025-01-24)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.16...v1.3.0)

**Closed issues:**

- Missing docs for Templates [\#320](https://github.com/mailgun/mailgun-ruby/issues/320)

**Merged pull requests:**

- Faraday as http client [\#330](https://github.com/mailgun/mailgun-ruby/pull/330) ([mgrishko](https://github.com/mgrishko))
- DE-1284: Update template and metrics docs [\#329](https://github.com/mailgun/mailgun-ruby/pull/329) ([alex-leb](https://github.com/alex-leb))
- Updated webhook documentation [\#325](https://github.com/mailgun/mailgun-ruby/pull/325) ([phiphphi](https://github.com/phiphphi))
- Remove duplicated entry from CHANGELOG [\#318](https://github.com/mailgun/mailgun-ruby/pull/318) ([y-yagi](https://github.com/y-yagi))

## [v1.2.16](https://github.com/mailgun/mailgun-ruby/tree/v1.2.16) (2024-11-29)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.15...v1.2.16)

**Merged pull requests:**

- DE-1313: Add support for Metrics endpoint [\#326](https://github.com/mailgun/mailgun-ruby/pull/326) ([alex-leb](https://github.com/alex-leb))

## [v1.2.15](https://github.com/mailgun/mailgun-ruby/tree/v1.2.15) (2024-10-07)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.14...v1.2.15)

**Closed issues:**

- Remove `OpenStruct` usage, will warn in Ruby 3.4, raise in Ruby 3.5 [\#321](https://github.com/mailgun/mailgun-ruby/issues/321)
- Follow up error while processing response of an unauthorized request [\#295](https://github.com/mailgun/mailgun-ruby/issues/295)

**Merged pull requests:**

- Work around error responses without `message` property [\#324](https://github.com/mailgun/mailgun-ruby/pull/324) ([ggalmazor](https://github.com/ggalmazor))
- Remove `ostruct` usage [\#322](https://github.com/mailgun/mailgun-ruby/pull/322) ([Earlopain](https://github.com/Earlopain))

## [v1.2.14](https://github.com/mailgun/mailgun-ruby/tree/v1.2.14) (2024-02-13)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.13...v1.2.14)

**Closed issues:**

- Headers are always downcased when using Railgun [\#315](https://github.com/mailgun/mailgun-ruby/issues/315)
- Getting error : NameError: uninitialized constant MailgunRetriesCron [\#293](https://github.com/mailgun/mailgun-ruby/issues/293)

**Merged pull requests:**

- change release version to 1.2.14, update changelog [\#317](https://github.com/mailgun/mailgun-ruby/pull/317) ([Retttro](https://github.com/Retttro))
- DE-1116: add tags CRUD [\#316](https://github.com/mailgun/mailgun-ruby/pull/316) ([Retttro](https://github.com/Retttro))
- DE-1114: add new endpoints to Domains [\#314](https://github.com/mailgun/mailgun-ruby/pull/314) ([Retttro](https://github.com/Retttro))
- restore changelog [\#311](https://github.com/mailgun/mailgun-ruby/pull/311) ([mgrishko](https://github.com/mgrishko))
- Updates to reflect changes in the API [\#306](https://github.com/mailgun/mailgun-ruby/pull/306) ([Retttro](https://github.com/Retttro))
- Add webhooks update method [\#305](https://github.com/mailgun/mailgun-ruby/pull/305) ([Retttro](https://github.com/Retttro))
- Add support for amp html [\#304](https://github.com/mailgun/mailgun-ruby/pull/304) ([Retttro](https://github.com/Retttro))

## [v1.2.13](https://github.com/mailgun/mailgun-ruby/tree/v1.2.13) (2023-12-04)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.12...v1.2.13)

**Closed issues:**

- Next page  [\#301](https://github.com/mailgun/mailgun-ruby/issues/301)
- single-verification [\#299](https://github.com/mailgun/mailgun-ruby/issues/299)

**Merged pull requests:**

- Add subaccounts [\#310](https://github.com/mailgun/mailgun-ruby/pull/310) ([mgrishko](https://github.com/mgrishko))
- DE-1208 [\#309](https://github.com/mailgun/mailgun-ruby/pull/309) ([Retttro](https://github.com/Retttro))
- DE-1208: add email validation docs [\#308](https://github.com/mailgun/mailgun-ruby/pull/308) ([Retttro](https://github.com/Retttro))
- DE-1207: add next, prev Suppressions documentation [\#307](https://github.com/mailgun/mailgun-ruby/pull/307) ([Retttro](https://github.com/Retttro))

## [v1.2.12](https://github.com/mailgun/mailgun-ruby/tree/v1.2.12) (2023-10-22)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.11...v1.2.12)

**Closed issues:**

- delete\_if returning true from function when encountering a nil value [\#294](https://github.com/mailgun/mailgun-ruby/issues/294)
- Changelog [\#250](https://github.com/mailgun/mailgun-ruby/issues/250)

**Merged pull requests:**

- Chnage release version, add changelog [\#302](https://github.com/mailgun/mailgun-ruby/pull/302) ([Retttro](https://github.com/Retttro))
- DE-1115: support templates CRUD [\#300](https://github.com/mailgun/mailgun-ruby/pull/300) ([Retttro](https://github.com/Retttro))
- DE-1163 fix block iteration issue [\#298](https://github.com/mailgun/mailgun-ruby/pull/298) ([mgrishko](https://github.com/mgrishko))
- Fix several typos [\#297](https://github.com/mailgun/mailgun-ruby/pull/297) ([Retttro](https://github.com/Retttro))
- Add & update URLs in gemspecs [\#257](https://github.com/mailgun/mailgun-ruby/pull/257) ([r7kamura](https://github.com/r7kamura))
- Updates the link for batch message anchor [\#251](https://github.com/mailgun/mailgun-ruby/pull/251) ([zainonrails](https://github.com/zainonrails))
- Add success method in Response.rb [\#220](https://github.com/mailgun/mailgun-ruby/pull/220) ([0xAdriaTorralba](https://github.com/0xAdriaTorralba))

## [v1.2.11](https://github.com/mailgun/mailgun-ruby/tree/v1.2.11) (2023-09-22)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.10...v1.2.11)

**Closed issues:**

- Response object can be nil [\#289](https://github.com/mailgun/mailgun-ruby/issues/289)

**Merged pull requests:**

- DE-1165 replace deprecated webhooks with new [\#296](https://github.com/mailgun/mailgun-ruby/pull/296) ([mgrishko](https://github.com/mgrishko))
- Fixes typo: "contain" was misspelled "containg" [\#281](https://github.com/mailgun/mailgun-ruby/pull/281) ([leonelgalan](https://github.com/leonelgalan))
- Document the timeout option [\#277](https://github.com/mailgun/mailgun-ruby/pull/277) ([jaredbeck](https://github.com/jaredbeck))
- Remove unnecessary executable bit from files [\#264](https://github.com/mailgun/mailgun-ruby/pull/264) ([jdufresne](https://github.com/jdufresne))

## [v1.2.10](https://github.com/mailgun/mailgun-ruby/tree/v1.2.10) (2023-06-25)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.9...v1.2.10)

**Closed issues:**

- mailgun-ruby 1.2.9 not on rubygems [\#288](https://github.com/mailgun/mailgun-ruby/issues/288)
- TypeError \(no implicit conversion of nil into String\) [\#278](https://github.com/mailgun/mailgun-ruby/issues/278)
- Distinguish between HTTP 400 and HTTP 401 with different exception types? [\#248](https://github.com/mailgun/mailgun-ruby/issues/248)
- Update Domain Endpoint [\#185](https://github.com/mailgun/mailgun-ruby/issues/185)

**Merged pull requests:**

- DE-1066: handle empty response case [\#291](https://github.com/mailgun/mailgun-ruby/pull/291) ([Retttro](https://github.com/Retttro))

## [v1.2.9](https://github.com/mailgun/mailgun-ruby/tree/v1.2.9) (2023-06-06)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.8...v1.2.9)

**Closed issues:**

- Primitive types are serialized twice to JSON [\#282](https://github.com/mailgun/mailgun-ruby/issues/282)
- Error api\_host after update to 1.2.7 [\#275](https://github.com/mailgun/mailgun-ruby/issues/275)
- Why can you only use the public api key for email validation [\#145](https://github.com/mailgun/mailgun-ruby/issues/145)

**Merged pull requests:**

- Release 1.2.9 [\#286](https://github.com/mailgun/mailgun-ruby/pull/286) ([Retttro](https://github.com/Retttro))

## [v1.2.8](https://github.com/mailgun/mailgun-ruby/tree/v1.2.8) (2023-02-17)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.7...v1.2.8)

**Closed issues:**

- NoMethodError \(undefined method 'proxy\_url' for Mailgun:Module\) [\#273](https://github.com/mailgun/mailgun-ruby/issues/273)
- The delete\_bounce method requires email addresses to be escaped. [\#268](https://github.com/mailgun/mailgun-ruby/issues/268)
- Is there a way to handle different recipient variables with same email [\#266](https://github.com/mailgun/mailgun-ruby/issues/266)
- Use multiple domains with different sending keys [\#258](https://github.com/mailgun/mailgun-ruby/issues/258)
- Use config block in Mailgun::Client [\#253](https://github.com/mailgun/mailgun-ruby/issues/253)
- Using mailgun templates and passing variables? [\#244](https://github.com/mailgun/mailgun-ruby/issues/244)

**Merged pull requests:**

- Add missing accessors [\#274](https://github.com/mailgun/mailgun-ruby/pull/274) ([Linuus](https://github.com/Linuus))

## [v1.2.7](https://github.com/mailgun/mailgun-ruby/tree/v1.2.7) (2023-02-13)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.6...v1.2.7)

**Closed issues:**

- TypeError: no implicit conversion of nil into String [\#256](https://github.com/mailgun/mailgun-ruby/issues/256)
- Check for ActionMailer instead of Rails [\#254](https://github.com/mailgun/mailgun-ruby/issues/254)

**Merged pull requests:**

- Release 1.2.7 [\#272](https://github.com/mailgun/mailgun-ruby/pull/272) ([Retttro](https://github.com/Retttro))

## [v1.2.6](https://github.com/mailgun/mailgun-ruby/tree/v1.2.6) (2022-11-10)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.5...v1.2.6)

**Implemented enhancements:**

- Railgun tests [\#74](https://github.com/mailgun/mailgun-ruby/issues/74)

**Closed issues:**

- MessageBuilder Variables encoding objects as strings [\#252](https://github.com/mailgun/mailgun-ruby/issues/252)
- Multipart messages through ActionView [\#249](https://github.com/mailgun/mailgun-ruby/issues/249)
- Using mailgun templates and passing variables? [\#243](https://github.com/mailgun/mailgun-ruby/issues/243)
- string user variables include escaped double quotes [\#234](https://github.com/mailgun/mailgun-ruby/issues/234)
- Not working with latest version of mailgun-ruby gem [\#182](https://github.com/mailgun/mailgun-ruby/issues/182)
- cannot use europe region  [\#179](https://github.com/mailgun/mailgun-ruby/issues/179)
- Allow Mailgun template feature [\#166](https://github.com/mailgun/mailgun-ruby/issues/166)
- how to send from different domains? [\#161](https://github.com/mailgun/mailgun-ruby/issues/161)
- Options to run mailgun via Proxy [\#152](https://github.com/mailgun/mailgun-ruby/issues/152)
- In test mode a static ID is returned [\#139](https://github.com/mailgun/mailgun-ruby/issues/139)
- Set o:tracking when track\_clicks/opens is called [\#129](https://github.com/mailgun/mailgun-ruby/issues/129)
- Mailgun does not accept From header with display name [\#126](https://github.com/mailgun/mailgun-ruby/issues/126)
- Better Exceptions [\#120](https://github.com/mailgun/mailgun-ruby/issues/120)
- \(slightly dumb question\) Why adapters? [\#95](https://github.com/mailgun/mailgun-ruby/issues/95)

**Merged pull requests:**

- release 1.2.6 [\#261](https://github.com/mailgun/mailgun-ruby/pull/261) ([Retttro](https://github.com/Retttro))
- fix link to documentation.mailgun.com [\#240](https://github.com/mailgun/mailgun-ruby/pull/240) ([nicolasmlv](https://github.com/nicolasmlv))

## [v1.2.5](https://github.com/mailgun/mailgun-ruby/tree/v1.2.5) (2021-06-10)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.4...v1.2.5)

**Closed issues:**

- Rails 6.1 deprecation warning [\#215](https://github.com/mailgun/mailgun-ruby/issues/215)
- Thread safety issue with rest-client possibly [\#208](https://github.com/mailgun/mailgun-ruby/issues/208)
- Mailgun is deleting calendar/ics mime [\#203](https://github.com/mailgun/mailgun-ruby/issues/203)
- Custom variables must be JSON object [\#200](https://github.com/mailgun/mailgun-ruby/issues/200)
- MIME-Version Header twice in email [\#194](https://github.com/mailgun/mailgun-ruby/issues/194)
- Headers being deleted when sent via Rails [\#180](https://github.com/mailgun/mailgun-ruby/issues/180)
- Mailer.mailgun\_client incorrect return value [\#125](https://github.com/mailgun/mailgun-ruby/issues/125)
- Problems with pagination in v1.1.8 [\#124](https://github.com/mailgun/mailgun-ruby/issues/124)
- Custom headers [\#117](https://github.com/mailgun/mailgun-ruby/issues/117)
- Incorrect message\_id after sending the message via rails mailer [\#116](https://github.com/mailgun/mailgun-ruby/issues/116)
- Unexpected token at 'Mailgun Magnificent API' [\#110](https://github.com/mailgun/mailgun-ruby/issues/110)
- prevent sending multi-part mail if only html or text part is provided [\#107](https://github.com/mailgun/mailgun-ruby/issues/107)
- Invalid delivery method [\#105](https://github.com/mailgun/mailgun-ruby/issues/105)
- undefined method 'mailgun\_settings=' for ActionMailer::Base:Class [\#104](https://github.com/mailgun/mailgun-ruby/issues/104)
- Including 'mailgun-ruby' causes action\_mailer configs in an initializer to not be used [\#86](https://github.com/mailgun/mailgun-ruby/issues/86)

**Merged pull requests:**

- mailgun 1.2.5 [\#242](https://github.com/mailgun/mailgun-ruby/pull/242) ([Retttro](https://github.com/Retttro))

## [v1.2.4](https://github.com/mailgun/mailgun-ruby/tree/v1.2.4) (2021-04-05)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.3...v1.2.4)

**Closed issues:**

- Salam [\#202](https://github.com/mailgun/mailgun-ruby/issues/202)
- Inline Attachment with Action Mailer [\#199](https://github.com/mailgun/mailgun-ruby/issues/199)
- Release version 1.2.2 to rubygems.org [\#198](https://github.com/mailgun/mailgun-ruby/issues/198)
- Bloating recipient\_variables in Mailgun::BatchMessage [\#167](https://github.com/mailgun/mailgun-ruby/issues/167)
- MessageBuilder\#track\_clicks usage is unclear [\#165](https://github.com/mailgun/mailgun-ruby/issues/165)
- Allow specifying of sender email [\#164](https://github.com/mailgun/mailgun-ruby/issues/164)
- Error performing ActionMailer::DeliveryJob FrozenError \(can't modify frozen Array\) [\#159](https://github.com/mailgun/mailgun-ruby/issues/159)
- Unsubscribe API returns Invalid JSON error [\#150](https://github.com/mailgun/mailgun-ruby/issues/150)
- parse\_address always formats it as '' \<user@host.domain\> even when neither full\_name, nor first, nor last variables are passed [\#141](https://github.com/mailgun/mailgun-ruby/issues/141)
- Mailgun issue with attachment with custom extensions [\#136](https://github.com/mailgun/mailgun-ruby/issues/136)

**Merged pull requests:**

- mailgun 1.2.4 [\#229](https://github.com/mailgun/mailgun-ruby/pull/229) ([Retttro](https://github.com/Retttro))
- update version to 1.2.3 [\#224](https://github.com/mailgun/mailgun-ruby/pull/224) ([Retttro](https://github.com/Retttro))
- mailgun 1.2.1 [\#223](https://github.com/mailgun/mailgun-ruby/pull/223) ([Retttro](https://github.com/Retttro))
- Allow timeout to be passed as a config option [\#210](https://github.com/mailgun/mailgun-ruby/pull/210) ([jmr0](https://github.com/jmr0))

## [v1.2.3](https://github.com/mailgun/mailgun-ruby/tree/v1.2.3) (2021-03-02)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.2...v1.2.3)

**Closed issues:**

- Mailgun::CommunicationError: key not found: :ciphers [\#213](https://github.com/mailgun/mailgun-ruby/issues/213)
- nil as bcc address raise Mailgun::CommunicationError [\#197](https://github.com/mailgun/mailgun-ruby/issues/197)
- Not working for Rails 5 [\#196](https://github.com/mailgun/mailgun-ruby/issues/196)
- Publish to Rubygems [\#193](https://github.com/mailgun/mailgun-ruby/issues/193)
- Mailgun could have thousands of new customers thanks to Tecnativa module to integrate Odoo with Mailgun [\#189](https://github.com/mailgun/mailgun-ruby/issues/189)
- Strict versioning for rest-client [\#176](https://github.com/mailgun/mailgun-ruby/issues/176)

## [v1.2.2](https://github.com/mailgun/mailgun-ruby/tree/v1.2.2) (2020-03-10)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.1...v1.2.2)

**Closed issues:**

- No timeout on network errors [\#183](https://github.com/mailgun/mailgun-ruby/issues/183)

**Merged pull requests:**

- Relax version constraint on rest-client [\#188](https://github.com/mailgun/mailgun-ruby/pull/188) ([n-rodriguez](https://github.com/n-rodriguez))

## [v1.2.1](https://github.com/mailgun/mailgun-ruby/tree/v1.2.1) (2020-03-10)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.2.0...v1.2.1)

**Closed issues:**

- using an erb template in the message\_params [\#178](https://github.com/mailgun/mailgun-ruby/issues/178)
- Does the timeout param to Client.new work? [\#177](https://github.com/mailgun/mailgun-ruby/issues/177)
- Reply-to header is being duplicated [\#157](https://github.com/mailgun/mailgun-ruby/issues/157)

**Merged pull requests:**

- Depend on the RestClient default timeout for network timeouts [\#184](https://github.com/mailgun/mailgun-ruby/pull/184) ([cluesque](https://github.com/cluesque))
- Document how to use EU domains [\#175](https://github.com/mailgun/mailgun-ruby/pull/175) ([dcabo](https://github.com/dcabo))
- Include config info in README for EU domains [\#174](https://github.com/mailgun/mailgun-ruby/pull/174) ([jaredlt](https://github.com/jaredlt))

## [v1.2.0](https://github.com/mailgun/mailgun-ruby/tree/v1.2.0) (2019-08-12)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.11...v1.2.0)

**Closed issues:**

- Domain not found [\#171](https://github.com/mailgun/mailgun-ruby/issues/171)
- Domains in EU Region not working [\#151](https://github.com/mailgun/mailgun-ruby/issues/151)

**Merged pull requests:**

- Treat headers as case-insensitive so duplicate headers are not a problem [\#158](https://github.com/mailgun/mailgun-ruby/pull/158) ([pirogoeth](https://github.com/pirogoeth))

## [v1.1.11](https://github.com/mailgun/mailgun-ruby/tree/v1.1.11) (2018-10-12)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.10...v1.1.11)

**Implemented enhancements:**

- Add Railgun docs, tests, and support ActionMailer headers call [\#133](https://github.com/mailgun/mailgun-ruby/pull/133) ([pirogoeth](https://github.com/pirogoeth))

**Closed issues:**

- Passing nil/empty bcc parameter is transformed to array with blank string [\#100](https://github.com/mailgun/mailgun-ruby/issues/100)

**Merged pull requests:**

- Fixed Mailer.mailgun\_client return value [\#153](https://github.com/mailgun/mailgun-ruby/pull/153) ([mccarths](https://github.com/mccarths))
- Document setting options in ActionMailer [\#149](https://github.com/mailgun/mailgun-ruby/pull/149) ([joho](https://github.com/joho))
- Timeout for Mailgun Client [\#144](https://github.com/mailgun/mailgun-ruby/pull/144) ([uri](https://github.com/uri))
- Fix invalid addresses when passing an empty array or string [\#140](https://github.com/mailgun/mailgun-ruby/pull/140) ([djohnson](https://github.com/djohnson))

## [v1.1.10](https://github.com/mailgun/mailgun-ruby/tree/v1.1.10) (2018-06-11)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.9...v1.1.10)

**Closed issues:**

- Update rubygems. [\#138](https://github.com/mailgun/mailgun-ruby/issues/138)
- Cannot send pure plain/text \(or plain/html\) mail [\#130](https://github.com/mailgun/mailgun-ruby/issues/130)
- Sending an email in html [\#128](https://github.com/mailgun/mailgun-ruby/issues/128)
- Ruby 2.0.0-0p end of life [\#113](https://github.com/mailgun/mailgun-ruby/issues/113)

**Merged pull requests:**

- Version bump to 1.1.10 [\#147](https://github.com/mailgun/mailgun-ruby/pull/147) ([pirogoeth](https://github.com/pirogoeth))
- Minor fix in name require [\#146](https://github.com/mailgun/mailgun-ruby/pull/146) ([fabdelgado](https://github.com/fabdelgado))
- Remove unintentional .ruby-version [\#143](https://github.com/mailgun/mailgun-ruby/pull/143) ([uri](https://github.com/uri))
- Fix pagination problem in Mailgun::Events-api introduced in v1.1.8 [\#142](https://github.com/mailgun/mailgun-ruby/pull/142) ([kaspergrubbe](https://github.com/kaspergrubbe))

## [v1.1.9](https://github.com/mailgun/mailgun-ruby/tree/v1.1.9) (2018-02-09)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.8...v1.1.9)

**Implemented enhancements:**

- Add Railgun docs, tests, and support ActionMailer headers call [\#133](https://github.com/mailgun/mailgun-ruby/pull/133) ([pirogoeth](https://github.com/pirogoeth))

**Closed issues:**

- Unexpected token at 'Mailgun Magnificent API' [\#135](https://github.com/mailgun/mailgun-ruby/issues/135)
- Tracking API [\#131](https://github.com/mailgun/mailgun-ruby/issues/131)
- Cannot send pure plain/text \(or plain/html\) mail [\#130](https://github.com/mailgun/mailgun-ruby/issues/130)
- Sending an email in html [\#128](https://github.com/mailgun/mailgun-ruby/issues/128)
- Custom headers [\#117](https://github.com/mailgun/mailgun-ruby/issues/117)

**Merged pull requests:**

- Bump version for \#134 [\#137](https://github.com/mailgun/mailgun-ruby/pull/137) ([pirogoeth](https://github.com/pirogoeth))
- Fix error in Webhooks create method [\#134](https://github.com/mailgun/mailgun-ruby/pull/134) ([velichkoStoev](https://github.com/velichkoStoev))
- Fix content type [\#132](https://github.com/mailgun/mailgun-ruby/pull/132) ([fursich](https://github.com/fursich))
- Small/easy to review PR: Allow caller to specify full\_name instead of first/last. [\#127](https://github.com/mailgun/mailgun-ruby/pull/127) ([maxshortzp](https://github.com/maxshortzp))
- add config of postbin [\#119](https://github.com/mailgun/mailgun-ruby/pull/119) ([dont-ol](https://github.com/dont-ol))
- \[Docs\] fixed Webhooks.md `remove_all` method in docs. [\#115](https://github.com/mailgun/mailgun-ruby/pull/115) ([shaunakpp](https://github.com/shaunakpp))

## [v1.1.8](https://github.com/mailgun/mailgun-ruby/tree/v1.1.8) (2017-09-27)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.6...v1.1.8)

**Closed issues:**

- Webhook create method returning false negative [\#111](https://github.com/mailgun/mailgun-ruby/issues/111)
- rest-client version conflicts [\#101](https://github.com/mailgun/mailgun-ruby/issues/101)
- options\[:reply\_to\] in Rails 5's Actionmailer::Base's message object doesn't get transformed [\#92](https://github.com/mailgun/mailgun-ruby/issues/92)
- Mailgun::BatchMessage doesnt replace the placeholders with recipient data. [\#90](https://github.com/mailgun/mailgun-ruby/issues/90)
- Mailgun::Suppressions [\#85](https://github.com/mailgun/mailgun-ruby/issues/85)

**Merged pull requests:**

- Bump version [\#123](https://github.com/mailgun/mailgun-ruby/pull/123) ([stevenwilkin](https://github.com/stevenwilkin))
- Perform mailbox validation [\#122](https://github.com/mailgun/mailgun-ruby/pull/122) ([stevenwilkin](https://github.com/stevenwilkin))
- Fix typo in README [\#121](https://github.com/mailgun/mailgun-ruby/pull/121) ([stevenwilkin](https://github.com/stevenwilkin))
- Fix message-id in Railgun [\#118](https://github.com/mailgun/mailgun-ruby/pull/118) ([mosinski](https://github.com/mosinski))
- update message docs [\#114](https://github.com/mailgun/mailgun-ruby/pull/114) ([YusukeHidaka](https://github.com/YusukeHidaka))
- Fixed success check for webhook create method [\#112](https://github.com/mailgun/mailgun-ruby/pull/112) ([abury](https://github.com/abury))
- Update event url parsers [\#108](https://github.com/mailgun/mailgun-ruby/pull/108) ([fursich](https://github.com/fursich))
- Additional README Rails/ActionMailer example [\#103](https://github.com/mailgun/mailgun-ruby/pull/103) ([cathal](https://github.com/cathal))
- mail 2.6 fix & new version [\#102](https://github.com/mailgun/mailgun-ruby/pull/102) ([scr1pt](https://github.com/scr1pt))
- Fix file extension in README [\#99](https://github.com/mailgun/mailgun-ruby/pull/99) ([alex-tan](https://github.com/alex-tan))

## [v1.1.6](https://github.com/mailgun/mailgun-ruby/tree/v1.1.6) (2017-05-11)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.5...v1.1.6)

**Closed issues:**

- Consider storing deliveries in test mode [\#93](https://github.com/mailgun/mailgun-ruby/issues/93)
- Better documentation wanted [\#89](https://github.com/mailgun/mailgun-ruby/issues/89)
- Mailgun::Error \(Too many recipients, max is 1000\): [\#87](https://github.com/mailgun/mailgun-ruby/issues/87)
- Attachments are ignoring filename when sent using ActionMailer [\#82](https://github.com/mailgun/mailgun-ruby/issues/82)

**Merged pull requests:**

- Suppressions, Events, bugfixes omnibus [\#98](https://github.com/mailgun/mailgun-ruby/pull/98) ([pirogoeth](https://github.com/pirogoeth))
- add list\_unsubcribe method [\#97](https://github.com/mailgun/mailgun-ruby/pull/97) ([Sami-B](https://github.com/Sami-B))
- Events\#previous and Events\#next should accept params [\#96](https://github.com/mailgun/mailgun-ruby/pull/96) ([rzane](https://github.com/rzane))
- Store mail deliveries in test mode [\#94](https://github.com/mailgun/mailgun-ruby/pull/94) ([mkaito](https://github.com/mkaito))
- Update README.md [\#91](https://github.com/mailgun/mailgun-ruby/pull/91) ([pirogoeth](https://github.com/pirogoeth))
- Fix raise syntax for custom exceptions. [\#88](https://github.com/mailgun/mailgun-ruby/pull/88) ([subdigital](https://github.com/subdigital))
- Fix typo [\#84](https://github.com/mailgun/mailgun-ruby/pull/84) ([mechanicles](https://github.com/mechanicles))

## [v1.1.5](https://github.com/mailgun/mailgun-ruby/tree/v1.1.5) (2017-02-27)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.4...v1.1.5)

**Fixed bugs:**

- Fix attachments in Railgun \(\#82\) [\#83](https://github.com/mailgun/mailgun-ruby/pull/83) ([pirogoeth](https://github.com/pirogoeth))

## [v1.1.4](https://github.com/mailgun/mailgun-ruby/tree/v1.1.4) (2017-02-17)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.3...v1.1.4)

**Implemented enhancements:**

- Easy rails integration [\#14](https://github.com/mailgun/mailgun-ruby/issues/14)
- Do not allow send\_message to be passed nils in data hash \(\#32\) [\#70](https://github.com/mailgun/mailgun-ruby/pull/70) ([pirogoeth](https://github.com/pirogoeth))

**Fixed bugs:**

- MessageBuilder custom parameter adds spurious \[ \] [\#77](https://github.com/mailgun/mailgun-ruby/issues/77)
- mailgun-ruby-1.1.3.gem does not match published SHA [\#76](https://github.com/mailgun/mailgun-ruby/issues/76)
- Batch sending adds everyone to the To field [\#12](https://github.com/mailgun/mailgun-ruby/issues/12)
- Odd bugfixes.. \(1.1.4\) [\#78](https://github.com/mailgun/mailgun-ruby/pull/78) ([pirogoeth](https://github.com/pirogoeth))

**Closed issues:**

- Implement Railgun as a Railtie [\#80](https://github.com/mailgun/mailgun-ruby/issues/80)
- Include example snippet for attachments [\#79](https://github.com/mailgun/mailgun-ruby/issues/79)

**Merged pull requests:**

- Autoload Railgun in Rails [\#81](https://github.com/mailgun/mailgun-ruby/pull/81) ([timdorr](https://github.com/timdorr))

## [v1.1.3](https://github.com/mailgun/mailgun-ruby/tree/v1.1.3) (2017-01-30)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.2...v1.1.3)

**Implemented enhancements:**

- Rails / ActionMailer Support [\#72](https://github.com/mailgun/mailgun-ruby/pull/72) ([pirogoeth](https://github.com/pirogoeth))
- Initial addition of suppressions management \(\#55\) [\#71](https://github.com/mailgun/mailgun-ruby/pull/71) ([pirogoeth](https://github.com/pirogoeth))
- Update incorrect links in README [\#67](https://github.com/mailgun/mailgun-ruby/pull/67) ([pirogoeth](https://github.com/pirogoeth))

**Fixed bugs:**

- Reply to does not work using message builder [\#45](https://github.com/mailgun/mailgun-ruby/issues/45)
- Sending raw MIME does not work [\#42](https://github.com/mailgun/mailgun-ruby/issues/42)
- Reply-To contains extra characters [\#40](https://github.com/mailgun/mailgun-ruby/issues/40)
- Trouble with "count" parameter [\#17](https://github.com/mailgun/mailgun-ruby/issues/17)
- Remove dependency on Faker from suppressions integration spec [\#75](https://github.com/mailgun/mailgun-ruby/pull/75) ([pirogoeth](https://github.com/pirogoeth))
- Remove leading newline from MIME string. [\#69](https://github.com/mailgun/mailgun-ruby/pull/69) ([pirogoeth](https://github.com/pirogoeth))
- Fix Reply-To having extra characters added \(\#40\) [\#68](https://github.com/mailgun/mailgun-ruby/pull/68) ([pirogoeth](https://github.com/pirogoeth))

**Closed issues:**

- Manage bounces [\#55](https://github.com/mailgun/mailgun-ruby/issues/55)
- Getting started with rails isn't easy [\#52](https://github.com/mailgun/mailgun-ruby/issues/52)
- `set\_delivery\_time': wrong number of arguments \(2 for 1\) [\#31](https://github.com/mailgun/mailgun-ruby/issues/31)

**Merged pull requests:**

- Document what to require [\#73](https://github.com/mailgun/mailgun-ruby/pull/73) ([ardeearam](https://github.com/ardeearam))

## [v1.1.2](https://github.com/mailgun/mailgun-ruby/tree/v1.1.2) (2016-11-11)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.1.1...v1.1.2)

**Implemented enhancements:**

- Error informativeness is abysmal [\#61](https://github.com/mailgun/mailgun-ruby/issues/61)
- POST to "lists" returns 400 Bad Request [\#44](https://github.com/mailgun/mailgun-ruby/issues/44)
- Test mode? [\#24](https://github.com/mailgun/mailgun-ruby/issues/24)
- Test mode implementation, \#24 [\#66](https://github.com/mailgun/mailgun-ruby/pull/66) ([pirogoeth](https://github.com/pirogoeth))
- Provide more informative error messages \(\#61, \#44\) [\#65](https://github.com/mailgun/mailgun-ruby/pull/65) ([pirogoeth](https://github.com/pirogoeth))
- Drop JSON dependency, add Ruby 2.3.1 to Travis conf [\#62](https://github.com/mailgun/mailgun-ruby/pull/62) ([pirogoeth](https://github.com/pirogoeth))

**Fixed bugs:**

- Problem with generate\_hash Method in OptInHandler [\#47](https://github.com/mailgun/mailgun-ruby/issues/47)

**Closed issues:**

- Can't install mailgun gem [\#60](https://github.com/mailgun/mailgun-ruby/issues/60)
- Update rest-client dependency [\#56](https://github.com/mailgun/mailgun-ruby/issues/56)
- Might be wise to mark this as abandoned [\#46](https://github.com/mailgun/mailgun-ruby/issues/46)
- Snippets.md contains incorrect syntax for MessageBuilder [\#37](https://github.com/mailgun/mailgun-ruby/issues/37)
- Error installing gem [\#30](https://github.com/mailgun/mailgun-ruby/issues/30)

**Merged pull requests:**

- Fix deprecated methods [\#64](https://github.com/mailgun/mailgun-ruby/pull/64) ([cycorld](https://github.com/cycorld))
- Merge some older PRs and improve testing in Travis [\#63](https://github.com/mailgun/mailgun-ruby/pull/63) ([pirogoeth](https://github.com/pirogoeth))
- Updated to Mailgun API v3; [\#49](https://github.com/mailgun/mailgun-ruby/pull/49) ([dan-ding](https://github.com/dan-ding))
- change "from" to :from to respect batch\_message.rb:52 [\#27](https://github.com/mailgun/mailgun-ruby/pull/27) ([amrnt](https://github.com/amrnt))
- Fixes Mail Merge issues [\#23](https://github.com/mailgun/mailgun-ruby/pull/23) ([mide](https://github.com/mide))
- Fixes typos in documentation [\#21](https://github.com/mailgun/mailgun-ruby/pull/21) ([mide](https://github.com/mide))
- Fixes typo in Messages.md documentation [\#20](https://github.com/mailgun/mailgun-ruby/pull/20) ([mide](https://github.com/mide))
- Added set\_message\_id method, tests and documentation [\#19](https://github.com/mailgun/mailgun-ruby/pull/19) ([brightcommerce](https://github.com/brightcommerce))
- Remove duplicate methods from test\_client [\#18](https://github.com/mailgun/mailgun-ruby/pull/18) ([nneal](https://github.com/nneal))
- Issue 15 digest hmac deprecated [\#16](https://github.com/mailgun/mailgun-ruby/pull/16) ([iffyuva](https://github.com/iffyuva))
- Correcting usage of finalize [\#13](https://github.com/mailgun/mailgun-ruby/pull/13) ([brandonweiss](https://github.com/brandonweiss))
- Add require option to Gemfile [\#11](https://github.com/mailgun/mailgun-ruby/pull/11) ([davidbalbert](https://github.com/davidbalbert))
- better connection error handling [\#9](https://github.com/mailgun/mailgun-ruby/pull/9) ([porbas](https://github.com/porbas))
- Fix typo [\#7](https://github.com/mailgun/mailgun-ruby/pull/7) ([jurikern](https://github.com/jurikern))

## [v1.1.1](https://github.com/mailgun/mailgun-ruby/tree/v1.1.1) (2016-10-31)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/v1.0.2...v1.1.1)

**Closed issues:**

- Merge Fields not Working [\#22](https://github.com/mailgun/mailgun-ruby/issues/22)
- digest/hmac removed in ruby 2.2.0-preview1 [\#15](https://github.com/mailgun/mailgun-ruby/issues/15)
- Wrong communication error handling [\#8](https://github.com/mailgun/mailgun-ruby/issues/8)
- Possible error in code [\#5](https://github.com/mailgun/mailgun-ruby/issues/5)

## [v1.0.2](https://github.com/mailgun/mailgun-ruby/tree/v1.0.2) (2014-05-09)

[Full Changelog](https://github.com/mailgun/mailgun-ruby/compare/30d11045df77ec36b34624d3429f25a00fd757ce...v1.0.2)

**Closed issues:**

- Impossible to install gem because of missing dependency 'multimap' [\#3](https://github.com/mailgun/mailgun-ruby/issues/3)

**Merged pull requests:**

- Events API [\#6](https://github.com/mailgun/mailgun-ruby/pull/6) ([travelton](https://github.com/travelton))
- Remove multimap and fix MIME download [\#4](https://github.com/mailgun/mailgun-ruby/pull/4) ([travelton](https://github.com/travelton))
- Improve security of OptInHandler. [\#2](https://github.com/mailgun/mailgun-ruby/pull/2) ([travelton](https://github.com/travelton))
- Initial Commit [\#1](https://github.com/mailgun/mailgun-ruby/pull/1) ([travelton](https://github.com/travelton))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
