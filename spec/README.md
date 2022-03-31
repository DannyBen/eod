# Testing Notes

## Basics

1. We are using RSpec, [Runfile][1] and [RSpec Approvals][2].
2. Run tests with `run spec`.

## Philosophy

1. The tests are designed to work without an API token.
2. To achieve this, we simply test that all commands generate the correct URL 
   to call the API.
3. To assist in testing with this approach, we use a minimal API mock server 
   that needs to run before testing (`run mockserver`).
4. The integration tests are designed to run if an API token is defined in the
   `EOD_TEST_API_TOKEN` environment variable. These tests go end to end with
   the real API. The public API key as mentioned in the API documentation should
   normally suffice for such tests.
5. Full test coverage is still achieved even without the integration tests.

[1]: https://github.com/DannyBen/runfile
[2]: https://github.com/DannyBen/rspec_approvals/