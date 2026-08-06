# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  # Check Ruby source against the Rails Omakase RuboCop rules.
  step "Style: Ruby", "bin/rubocop"

  # Check embedded Ruby templates for invalid or inconsistent ERB/HTML.
  step "Style: ERB", "bundle exec erb_lint --lint-all"

  # Verify that frontend and HTML+ERB files are formatted, without rewriting them in CI.
  step "Style: Frontend formatting", "bun run format:check"

  # Run correctness and style checks for JavaScript and SCSS.
  step "Lint: JavaScript", "bun run lint:js"
  step "Lint: SCSS", "bun run lint:css"

  # Compile both asset pipelines so broken imports or build configuration fail early.
  # These commands also verify that JavaScript and CSS source maps can be generated.
  step "Assets: JavaScript", "bun run build"
  step "Assets: CSS", "bun run build:css"

  # Scan Ruby dependencies and application code for known security problems.
  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  # Run the Rails test suite and confirm the seed data can be loaded from scratch.
  step "Tests: Rails", "bin/rails test"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"

  # Optional: Run system tests
  # step "Tests: System", "bin/rails test:system"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
