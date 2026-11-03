# AGENTS.md

## Project Basics

Case Narrative is a Rails app. It uses PostgreSQL, Devise, Hotwire/Turbo, Stimulus, Bootstrap, SCSS, Bun, Active Storage, Solid Queue, and OpenAI-backed document analyzer.

Runtime versions are in `mise.toml`

Useful commands:

- Dev server: `bin/dev`

## Production Deployment

- Production runs on a Ubuntu 26.04.1 LTS VPS (Passenger, nginx). Deploy via the VPS workflow and `update.sh`; Docker and Kamal are not used.

## Testing Scope

- Do not create/edit/run tests/fixtures unless the user explicitly requests.

## Plan

## Rails Conventions

- Keep controllers thin. Move business rules, query shaping, parsing, and workflow logic into other files or POROs as appropriate. Create new files if useful.
- Keep business logic out of views. Views should render state, not decide workflows.
- Prefer Turbo Streams and server-rendered HTML over custom JavaScript.
- Mark Turbo broadcast targets with descriptive `data-broadcast-*` attributes and match them with a `targets:` selector. Include enough identifiers to select only the intended elements, such as a record ID and content version.
- Keep broadcast target markup in the component partial; use Turbo `replace` when that partial renders the target element to avoid wrapper-only partials and nested targets.
- When creating new files such as controllers, migrations, models, jobs, and mailers, prefer Rails CLI generators and other project CLI commands first, then modify the generated files.
- Avoid one-line methods unless they improve readability, support Rails callbacks or DSLs, or define a useful public API.
- Preserve project scoping and authorization patterns, especially nested project resources and admin-only areas.
- Avoid N+1 queries.
- Ruby boolean variables: use prefixes such as `is_`, `has_`, `can_`, or `should_`; Ruby boolean methods: end the method name with `?` (for example, `empty?`, `admin?`, or `ready?`).
- JavaScript boolean variables and functions: use camelCase with clear prefixes such as `is`, `has`, `can`, or `should` (for example, `isReady`, `hasPermission`, or `canSubmit`)
- Encourage using well-maintained third-party libraries when they materially improve functionality, accessibility, interaction quality, or delivery speed. Prefer compatible, focused dependencies over reimplementing substantial capabilities; evaluate maintenance, security, licensing, bundle size, performance, and mobile/offline behavior before adding one.

## Comments And Organization

- Before every ruby method and javascript function, add 2 or 3 useful comment lines:
  - Line 1: what the method does.
  - Line 2: who calls it.
  - Line 3 optional: example return value, when helpful.
- If existing comments above a function or method contain examples, preserve and update those examples when behavior changes; do not remove them when revising the comments.
- For Stimulus `connect()` methods, make the caller comment list the view or partial paths that attach the controller; avoid generic comments such as "Called by Stimulus."
- For Stimulus action methods, make the caller comment specific: name the triggering element or controller target, the DOM event, and the relevant `data-action` mapping when known (for example, `a.chat-history-item` on `click->ai-chat#selectChat`).
- For Stimulus action methods with non-obvious state changes, add concise inline comments before the important statements explaining the DOM state being read or changed; do not comment every self-explanatory statement.
- Comment non-obvious statements, tradeoffs, and fragile behavior. Do not comment code that is already self-explanatory.
- For functions with important multi-step behavior, add inline comments inside the function before the key statements so a future reader can follow the sequence and reason for each state change.
- Keep inline comments focused on the purpose or dependency of the next statement. Prefer short, direct phrases such as `Ignore Turbo submissions from any other form.` or `Apply the pending state so user cannot submit the same message twice.`
- Preserve the method's caller comment above the function while using inline comments for implementation details; do not repeat the caller information inside the function.
- Keep comments concise and place them immediately above the element or block they describe; use short labels such as `Search filter.` or `Collapse button for sidebar.` for straightforward UI.
- For data actions, briefly state the action's purpose. For rendered partials, briefly state what the partial shows, including its key actions when useful. Explain complex logic in more detail only when a short label would not make it clear.
- When an element has multiple data actions, add a separate comment for each action immediately above the element using the format `functionName - purpose`, with the action function name listed explicitly.
- For important non-obvious behavior, comments may briefly explain why the code exists or what later code depends on, such as preserving submitted input so an error handler can restore it.
- When generated values or grouped states are difficult to decipher, add a brief inline comment at the relevant line explaining the possible values or purpose.
- Use blank lines often to separate major structural sections and improve scanability. Do not add blank lines between every element or separate a comment from the code it describes.
- Use banner comments for major sections in SCSS files and large Ruby or JavaScript files.
- Single-line banner comments must be exactly 1 line.
- Multi-line banner comments must be exactly 3 lines.
- Do not use serial numbers in banner comments.
- Organize models with banner sections when the file is large enough.
- In Stimulus controllers, group action methods separately from helper methods.
- In Gemfile, add the gem followed by a comment in the same line about what the gem does.
- In rails partials, begin with strict-locals magic comment. On the next line, add a very brief description of what the partial renders. On the following line, state briefly by whom it is called, including whether it is rendered in a loop or has other important context. Prefer precise caller paths relative to `app/views`, such as `messages/_user.html.erb`, over generic descriptions such as "message partials" when the caller is known.
- In rails views, place two comments immediately above the form: the first should describe the route helper or submission target, and the second should state the resulting HTTP method and endpoint. Keep these comments accurate for each conditional or distinct form.

## Frontend Conventions

- Use SCSS, nest related CSS classes where possible, while keeping nesting shallow enough to avoid specificity problems. Maximum nesting depth is 5 levels. Split large SCSS files into focused token, Bootstrap override, base, component, layout, and page files as appropriate.
- In SCSS files, add a brief comment above each top-level class or ID selector listing every view or partial that uses it. Use paths relative to `app/views` without the `app/views/` prefix, and keep them current when usage changes. Do not add these comments to `_buttons.scss` or to other broadly reusable generic classes where the usage list would become long; nested selectors do not need these comments.
- Put reusable button structure, typography, and interaction states in `_buttons.scss` under generic component classes, even when a button currently appears on only one page. Keep page SCSS to layout placement, page-specific color tokens, and small overrides so the button can be reused elsewhere.
- Consolidate all declarations for the same component selector into one SCSS block; do not repeat a selector such as `aside.ai-chat-sidebar` in separate blocks.
- Keep a concise, descriptive class on a component's root element, then use a concise acronym prefix formed from its contextual parent and component names for component-specific descendant classes and internal IDs (for example, `cds-summary` inside `company-document-source` with `cdss-heading`, `cdss-title`, and `cdss-full`). This avoids repeating a long component name on every child while keeping its hooks recognizable. Keep IDs unique in the rendered document and update all references such as ARIA attributes, JavaScript, and Turbo targets when an ID changes; preserve external broadcast/frame target IDs unless they are intentionally being renamed too.
- Use Bootstrap where appropriate, but do not overuse utility classes or make markup resemble Tailwind.
- Bootstrap dark mode is enabled. Override Bootstrap variables and theme tokens for primary colors, surfaces, typography, borders, focus states, buttons, alerts, links, and form controls so semantic classes such as `.btn-primary` remain on-brand.
- Define shared color custom properties in the `:root` block of `_base.scss`; do not create Sass variables for colors. Use simple names following `<color>-<variant>-<purpose>`, such as `--red-dark-background`, `--gray-input-background`, and `--gray-muted-text`. If the same color and variant are used for multiple purposes, use the shorter `<color>-<variant>` name and omit the purpose. Omit `theme` and `color` from the variable name.
- Prefer modern CSS and HTML features available in 2026 when they improve clarity, responsiveness, accessibility, or performance. Use features such as cascade layers, custom properties, container queries, modern color functions, native nesting, `:has()`, `color-scheme`, `accent-color`, view transitions, semantic elements, native dialogs, and responsive form capabilities when browser and build compatibility are suitable.
- `position: relative`: Avoid when possible; prefer other layout and positioning techniques. Use it only when there is no practical alternative. When changing code that touches elements already using it, consider replacing it with another technique when the change is straightforward and low effort.
- Keep `<span>` elements limited to phrasing/text content; do not place other elements inside a `<span>`. Use an appropriate semantic container such as `<div>`, `<p>`, `<section>`, or `<strong>` when nested content is required.
- When writing SCSS for a non-`div` element, include the element tag with its class selector. For example, use `article.ai-chat-message-user` instead of `.ai-chat-message-user`
- App-owned CSS class names must use hyphens only. Do not use underscores or double dashes.
- Avoid ERB interpolation inside HTML `class` attributes. Use tag helper class options to build conditional classes.
- In Stimulus controllers use descriptive camelCase target names with semantic type suffixes: `Btn` for buttons, `Txt` for text inputs or textareas, and `El` only for generic elements. Add similarly descriptive suffixes for other specialized controls when useful, and keep each suffix consistent in `static targets`, `data-*-target`, and generated accessors.
- Mobile camera, location, and viewport-lock behavior are intentional; preserve them and verify relevant changes in a browser when feasible.

### Scroll And Observer Efficiency

- Prefer sentinel-based `IntersectionObserver` over continuous scroll calculations; handle responsive scroll roots and Turbo/Stimulus cleanup.
- During streaming, follow only readers near the bottom; never pull them away from history.
- Minimize layout reads, throttle necessary handlers, and preserve mobile viewport behavior.

## Product Experience And Visual Design

- Before designing or modifying a page, inspect relevant examples, styles, and assets in `vendor/themes/orisa`, especially its dark pages (such as `index-dark.html`), `assets/css/main.css`, and `assets/imgs`. Orisa is the visual reference for the site's look and feel. Use its fonts, styles, colors, surfaces, and interaction patterns; these may be copied directly and adapted to the app.
- Match Orisa's visual language, including its dark surfaces, color palette, typography, spacing, borders, and interaction details. Use the same colors and font families defined by the theme (including DM Sans and its dark-mode tokens); do not substitute a generic red accent or invent a competing palette. Keep Bootstrap's dark theme and semantic components, and adapt Bootstrap variables/tokens to Orisa so components feel consistent with the reference.
- Reuse suitable existing imagery, logos, icons, textures, backgrounds, and other visual assets from `vendor/themes/orisa` when they fit the page. These assets may be copied or referenced directly. Do not create near-duplicates or use unrelated stock assets when a suitable Orisa asset exists. Preserve the theme's intended dark/light asset variants and contrast.
- Make the interface bold, polished, and visually legible, with clear hierarchy and balanced spacing. Design mobile-first for outdoor use: use comfortably large body text, headings, form labels, controls, and action targets, with strong contrast that remains easy to read in bright daylight. Avoid tiny or low-contrast text, especially for navigation, secondary information, and field-critical feedback.
- Increase font sizes and tune typography to make pages, labels, controls, and supporting text clearly legible and easy to read. Preserve responsive layout and the original task's intent.
- At mobile widths, never render horizontal scrollbars or allow horizontal scrolling on the page or inside nested components. Wrap, stack, constrain, or clip content instead; no carousel, table, menu, or other component gets a mobile horizontal-scroll exception. Keep layouts fully responsive. Use smooth purposeful transitions, magnetic-feeling buttons, and clear touch, focus, pressed, disabled, and loading states.
- Keep motion performant and never obscure field-critical feedback. Preserve accessibility, semantic structure, keyboard focus, sufficient contrast, readable errors, and appropriately sized touch targets.
- When using CSS Grid, add a very brief nearby comment describing the grid's layout purpose.
