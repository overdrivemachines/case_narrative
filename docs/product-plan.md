# Case Narrative product plan

## Purpose and delivery order

Case Narrative helps people document events, organize evidence, build chronological timelines, and create clear, verifiable accounts of their cases. The primary audience is individuals representing themselves or preparing information for attorneys. Attorneys and law firms come after the individual experience is complete.

Build four milestones, with the first two focused on launching a usable application quickly:

**Milestone 1 → Milestone 2 → usable beta → Milestones 3 and 4 based on feedback.**

Keep evidence traceability, factual accuracy, and simplicity for non-lawyers central throughout. Preserve original material, identify uncertainty, and distinguish allegations, source-supported statements, disputes, and missing information. Supporting evidence does not automatically establish a statement as true.

Authentication and the Rails stack already exist, but the checked-in schema currently contains only users. Private case records and ownership are therefore part of milestone 1. Reconcile older models as these features are implemented.

## Milestone 1 — Narrative Editor & Media Uploads (MVP)

**Highest priority:** let an individual write an account, attach supporting material, and reliably return to their work.

- Create private cases and connect the dashboard to real case data.
- Create, edit, save, and delete narratives; support multiple narratives per case.
- Provide a simple rich text toolbar for bold, italic, underline, and selected text at 1.3× the normal font size.
- Insert images directly into narratives.
- Attach video and audio files with inline playback for supported browser formats; show clear feedback for unsupported formats.
- Autosave drafts with visible saving, saved, and failure states. Prevent stale saves from overwriting newer edits and preserve unsaved input after recoverable failures.
- Use Active Storage for all media, preferably backed by private S3-compatible object storage in production. Preserve originals and store metadata and attachment associations in PostgreSQL.
- Validate upload types and sizes, show upload failures, and define what happens to attachments when a narrative is deleted.
- Enforce case ownership for narratives, uploads, downloads, previews, and media playback from the beginning.
- Make editing and reading work on desktop and mobile, following Orisa styling with readable controls and no horizontal scrolling.

**Done when:** an individual can create a private case, write and reopen multiple formatted narratives, and view or play attached media without exposing it to another account.

**Frameworks and existing gems:** Action Text and Active Storage ship with Rails but still require installation/configuration. `image_processing` and `ruby-vips` are already in the Gemfile. Trix is a frontend dependency introduced with Action Text, not an additional standalone Ruby gem. See the [Action Text guide](https://guides.rubyonrails.org/action_text_overview.html).

**New gem only if needed:** `aws-sdk-s3` when configuring S3-compatible storage, as described in the [Active Storage guide](https://guides.rubyonrails.org/active_storage_overview.html). Local disk is sufficient for development. Start with owner-scoped authorization; add an authorization gem only if policies become complex enough to justify it.

## Milestone 2 — Vertical Timeline & Narrative Integration

- Create a vertical, chronological timeline for each case.
- Give each event a title, description, and date/time when known.
- Link an event to a narrative in the same case; allow multiple events to reference the same narrative.
- Open the linked narrative when the user selects an event.
- Add, edit, delete, and reorder events using accessible controls.
- Support approximate dates, date ranges, optional times/time zones, and unknown dates without inventing precision.
- Sort dated events chronologically. Use manual ordering for ties and uncertain or undated events; do not silently change a known date to satisfy a reorder operation.
- Keep undated events clearly identified and handle deleted narrative links explicitly.
- Build the layout with server-rendered Rails views, Turbo, Stimulus, and SCSS; keep it responsive without a JavaScript timeline library.

**Done when:** a user can reconstruct a case chronology, open the relevant accounts, and distinguish known dates from uncertain ordering.

**New gems:** none needed. Rails date/time handling, database ordering, and a position field are sufficient initially. Reconsider an ordering library only if actual reordering behavior becomes difficult to maintain; date grouping does not require a gem for this scope.

**Launch a usable beta after milestone 2.** Confirm that users can write, save, attach media, and reconstruct events before expanding the feature set.

## Milestone 3 — Narrative & Timeline Enhancements

- Link events to specific sections within a narrative using stable anchors that survive ordinary edits.
- Associate images, video, and audio with individual events, reusing existing attachments instead of duplicating original files.
- Add source labels and references so readers can trace important statements and events to supporting material; preserve visible disputes and uncertainty.
- Add case-scoped narrative search, including rich text content, and simple tags or categories.
- Generate printable narratives and timelines, including media captions and source references. Start with print styles and browser save-to-PDF for attorney preparation.
- Introduce basic version history with change attribution and restoration. Snapshot Action Text content and attachment references explicitly; versioning the parent narrative alone is insufficient.
- Keep original uploads available to referenced revisions and make deletion/retention behavior explicit.

**Done when:** a user can find relevant accounts, follow event and source links, review previous versions, and produce a readable handoff for an attorney.

**New gems when implementing these features:**

- [pg_search](https://github.com/Casecommons/pg_search) for PostgreSQL-backed narrative search.
- [paper_trail](https://github.com/paper-trail-gem/paper_trail) for revision tracking, with explicit handling of rich text and attachment relationships.

No PDF gem is needed for the initial printable workflow. Evaluate a maintained PDF renderer only if feedback establishes a need for automatic downloadable PDFs.

## Milestone 4 — AI Narrative Assistance

- Improve grammar, readability, and organization while preserving the user's intended meaning.
- Generate summaries of long narratives.
- Suggest timeline events based on narrative content, with references to the passages used.
- Identify potentially conflicting dates or statements and missing information as questions for review, rather than declaring which account is true.
- Let users choose what material is sent for analysis and clearly show processing and failure states.
- Show suggestions separately from saved content. Require the user to accept, edit, or reject changes before saving them; apply the same approval requirement to suggested events.
- Preserve original statements and revision history. Distinguish allegations, source-supported facts, disputed accounts, and unsupported suggestions; AI must not certify facts or invent missing details.
- Reject stale suggestions when the source narrative has changed.
- Process requests through existing background jobs with usage limits and retry handling; keep manual editing usable when AI is unavailable.

**Done when:** users can review useful suggestions, check their sources, and approve changes without losing their original account or introducing unsupported facts.

**Conditional new gem:** [ruby_llm](https://github.com/crmne/ruby_llm) if an AI client is needed. Inspect and reuse any existing document-analyzer integration before adding a second client. `solid_queue` is already in the Gemfile and should be reused. Semantic search and vector dependencies are outside this milestone unless user feedback identifies a concrete need.

## Important architectural decisions

1. **Use Action Text/Trix initially.** Before building the full editor, verify a small working slice covering the restricted toolbar, underline, selected text at 1.3× size, inline audio/video, save/reload, sanitization, and mobile behavior. Trix does not supply all these controls by default; confirm formatting survives the full round trip. Use focused configuration and attachment partials where practical. If the required behavior needs excessive customization, evaluate a maintained editor before building a custom one. Consult the [Trix documentation](https://github.com/basecamp/trix).
2. **Use Active Storage for media.** Keep file bytes in disk/object storage and metadata in PostgreSQL. Private buckets alone do not secure Rails attachment routes: authorize media access and issue short-lived storage URLs after checking case ownership. Account for playback, previews, and direct uploads. See [authenticated controllers in Active Storage](https://guides.rubyonrails.org/active_storage_overview.html#authenticated-controllers).
3. **Keep narratives and events separate.** A case has many narratives and events; each linked event references a narrative from that case. Several events can reference the same narrative. Keep timeline data out of rich text and introduce section references in milestone 3.
4. **Build secure access into the MVP.** Scope every resource to the current owner and prevent cross-case links or attachment reuse. Expand to collaboration permissions only when that workflow is scheduled.
5. **Keep dependencies focused.** Install only what the current milestone needs. Check Ruby/Rails compatibility, maintenance, security, licensing, operational requirements, and frontend accessibility/mobile behavior before adoption. No dependency changes are made by this plan.

## After the individual experience

After the individual workflow is complete and validated, plan attorney and law-firm support from observed needs: controlled client sharing, firm memberships, assigned cases, and professional review workflows. These are later work and do not block the beta or add requirements to the four milestones above.
