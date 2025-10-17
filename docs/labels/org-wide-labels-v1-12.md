# **GitHub Labels Guide**

## *Organisation wide defaults*

***Version:*** 1.12 • ***Last updated:*** 17 Oct 2025
***Scope:*** Global labels for the **lightspeedwp** organisation.***Objective:*** Incorporate **BugHerd tag families** as first-class GitHub labels across repos to unify intake/triage and delivery.
---

# **Label catalogue (org‑wide defaults)**

| Label | Description | Family | Colour |
| :---- | :---- | :---- | :---- |
| `priority:critical` | Production/launch-blocking | priority | `#B60205` |
| `priority:important` | Must-do in current/next iteration | priority | `#D93F0B` |
| `priority:minor` | Nice-to-have / low urgency | priority | `#C2E0C6` |
| `priority:normal` | Default priority | priority | `#0052CC` |
| `status:blocked` | Blocked; see Blocked reason | status | `#E99695` |
| `status:duplicate` | Duplicate of another issue | status | `#E99695` |
| `status:in-discussion` | Needs alignment/decision | status | `#BFD4F2` |
| `status:in-progress` | Work actively underway | status | `#1D76DB` |
| `status:needs-client-discussion` | Paused pending a client decision or clarification (scope, acceptance criteria, priority, content/legal approval). Assign a PM, schedule the touch-point, and capture the outcome in the task before resuming normal flow. Leverage BugHerd’s sharing/client-permission features to make the review efficient and visible. | status | `#C5DEF5` |
| `status:needs-design` | Early execution signal (triage queue for design) | status | `#C5DEF5` |
| `status:needs-design-review` | Awaiting design review | status | `#D4C5F9` |
| `status:needs-dev` | Early execution signal (triage queue for engineering) | status | `#C5DEF5` |
| `status:needs-discussion` | Requires a decision or alignment. | status | `#C5DEF5` |
| `status:needs-documentation` | Deliverable is blocked pending docs: release notes, change log, admin/how-to steps, or onboarding content. Add links or attachments (screenshots/GIFs), then move to review/QA once documentation is complete. | status | `#C5DEF5` |
| `status:needs-figma-update` | Existing Figma design needs updating | status | `#C5DEF5` |
| `status:needs-loom-video` | Request a short screen recording to demonstrate the issue or desired behaviour (voiceover recommended). Acceptable evidence includes a Loom link or BugHerd’s built-in video feedback capture added directly to the task. This reduces back-and-forth and speeds reproduction. | status | `#C5DEF5` |
| `status:needs-more-info` | Missing details to proceed | status | `#BFD4F2` |
| `status:needs-qa` | QA pass required | status | `#FBCA04` |
| `status:needs-review` | Awaiting code review | status | `#BFD4F2` |
| `status:needs-technical-feedback` | Awaiting technical review/feedback | status | `#C5DEF5` |
| `status:needs-testing` | Testing needed (manual/auto) | status | `#FEF2C0` |
| `status:needs-triage` | New/ungroomed; needs review by PM/lead | status | `#BFD4F2` |
| `status:on-hold` | Paused, awaiting external input | status | `#F9D0C4` |
| `status:ready` | Groomed and ready to start | status | `#0E8A16` |
| `status:ready-for-deployment` | Approved and queued for release. | status | `#0E8A16` |
| `status:scope-creep` | Exceeds agreed scope; needs re‑scoping. | status | `#BFD4F2` |
| `status:wontfix` | Not planned to address | status | `#E1E4E8` |
| `type:a11y` | Accessibility compliance/experience. | type | `#D4C5F9` |
| `type:bug` | Defect causing incorrect behaviour. | type | `#D4C5F9` |
| `type:chore` | Housekeeping tasks (dependencies, configs). | type | `#D4C5F9` |
| `type:compat` | Browser/device/plugin compatibility issue. | type | `#D4C5F9` |
| `type:content-import` | Content to be imported/migrated. | type | `#D4C5F9` |
| `type:content-management` | Client owns creation/updates. | type | `#D4C5F9` |
| `type:design` | Visual/interaction design work. | type | `#D4C5F9` |
| `type:dev` | Engineering task not covered elsewhere. | type | `#D4C5F9` |
| `type:feature` | New capability to be delivered. | type | `#D4C5F9` |
| `type:fix` | Small, targeted correction. | type | `#D4C5F9` |
| `type:improve` | Enhancement to existing behaviour. | type | `#D4C5F9` |
| `type:missing-content` | Content not yet provided. | type | `#D4C5F9` |
| `type:performance` | Performance work (speed, memory, Core Web Vitals). | type | `#D4C5F9` |
| `type:refactor` | Internal code restructure without changing behaviour. | type | `#D4C5F9` |
| `type:task` | Generic to‑do when none of the above apply. | type | `#D4C5F9` |
| `type:ui` | Interface-level adjustments. | type | `#D4C5F9` |
| `type:usability` | Ease‑of‑use improvements. | type | `#D4C5F9` |
| `type:ux` | User experience flows/journeys. | type | `#D4C5F9` |
| `area:analytics` | Analytics & tracking | area | `#C2E0C6` |
| `area:block-visibility` | Conditional display of blocks. | area | `#C5DEF5` |
| `area:cards` | Card lists and grids. | area | `#C5DEF5` |
| `area:ci` | Build and CI pipelines | area | `#BFD4F2` |
| `area:content` | Anything that needs copy-editing assistance | area | `#C5DEF5` |
| `area:cookie-policies` | Consent and cookie banners. | area | `#C5DEF5` |
| `area:cta` | Primary/secondary CTAs. | area | `#C5DEF5` |
| `area:dependencies` | Composer/npm dependency work | area | `#F9D0C4` |
| `area:deployment` | Deploy/release operations | area | `#006B75` |
| `area:design-system` | Tokens/components guidelines | area | `#C5DEF5` |
| `area:emails` | Transactional/marketing emails. | area | `#C5DEF5` |
| `area:forms` | Forms (Gravity Forms etc.) | area | `#C5DEF5` |
| `area:gallery` | Media galleries. | area | `#C5DEF5` |
| `area:hero` | Above‑the‑fold hero section. | area | `#C5DEF5` |
| `area:i18n` | Internationalisation | area | `#C5DEF5` |
| `area:infrastructure` | Infrastructure | area | `#006B75` |
| `area:integration` | External integrations | area | `#D93F0B` |
| `area:mega-menu` | Large structured menus. | area | `#C5DEF5` |
| `area:mobile-menu` | Mobile menus. | area | `#C5DEF5` |
| `area:modal` | Dialogs and overlays. | area | `#C5DEF5` |
| `area:navigation` | Menus & nav UX | area | `#C5DEF5` |
| `area:plugins` | Plugin configuration/internals | area | `#C5DEF5` |
| `area:post-format` | Presentation of posts by format. | area | `#C5DEF5` |
| `area:search` | Search/filters (incl. FacetWP) | area | `#C5DEF5` |
| `area:seo` | Technical SEO (meta/schema/sitemaps) | area | `#C2E0C6` |
| `area:slider` | Carousels/sliders. | area | `#C5DEF5` |
| `area:testimonials` | Social proof components. | area | `#C5DEF5` |
| `area:theme` | Theme & styles (templates, template parts, FSE) | area | `#C5DEF5` |
| `area:woocommerce` | WooCommerce templates, blocks, hooks | area | `#D4C5F9` |
| `comp:block-bindings` | Block bindings | comp | `#C5DEF5` |
| `comp:block-editor` | Block/site editor work | comp | `#C5DEF5` |
| `comp:block-inserter` | Inserter UI/behaviour | comp | `#C5DEF5` |
| `comp:block-json` | Block metadata (block.json) | comp | `#C5DEF5` |
| `comp:block-locking` | Block locking | comp | `#C5DEF5` |
| `comp:block-patterns` | Patterns library/registration | comp | `#C5DEF5` |
| `comp:block-styles` | Styles registered via JSON | comp | `#C5DEF5` |
| `comp:block-supports` | Block supports | comp | `#C5DEF5` |
| `comp:block-templates` | Template files/editor | comp | `#C5DEF5` |
| `comp:block-variations` | Block variations | comp | `#C5DEF5` |
| `comp:color-palette` | Palette tokens/usage | comp | `#C5DEF5` |
| `comp:help-tabs` | WP help tabs | comp | `#C5DEF5` |
| `comp:post-settings` | Post editor settings panel | comp | `#C5DEF5` |
| `comp:section-styles` | Section/background styles | comp | `#C5DEF5` |
| `comp:settings` | Global/settings UX | comp | `#C5DEF5` |
| `comp:site-editor` | Site Editor (Appearance → Editor). | comp | `#C5DEF5` |
| `comp:spacing` | Spacing tokens/layout gaps | comp | `#C5DEF5` |
| `comp:style-variations` | JSON style variations | comp | `#C5DEF5` |
| `comp:template-parts` | Header/footer/loop/nav parts | comp | `#C5DEF5` |
| `comp:theme-json` | Tokens, presets, settings | comp | `#C5DEF5` |
| `comp:typography` | Type scale/fluids | comp | `#C5DEF5` |
| `comp:wp-admin` | WP Admin screens | comp | `#C5DEF5` |
| `env:live` | Live/production | env | `#0E8A16` |
| `env:local` | Developer’s machine/environment for building, debugging and experiments; isolated and not client-visible. | env | `#E1E4E8` |
| `env:prototype` | Prototype/sandbox | env | `#E1E4E8` |
| `env:staging` | Staging/UAT | env | `#BFD4F2` |
| `phase:post-launch` | Live operations after release: hotfixes, regression control and incremental improvements. Emphasis on stability, monitoring and user impact. | phase | `#E1E4E8` |
| `phase:pre-launch` | Build, design and internal QA ahead of UAT; changes are frequent. Work may run on prototype or staging. Objective: reach production-like readiness for acceptance. | phase | `#E1E4E8` |
| `phase:staging-uat` | Pre-production validation on staging; stakeholders run UAT to confirm requirements, performance and tracking before release. No new scope unless agreed. | phase | `#E1E4E8` |
| `page:about` | Company/about page. | page | `#C5DEF5` |
| `page:blog` | Blog index/landing. | page | `#C5DEF5` |
| `page:contact` | Contact page. | page | `#C5DEF5` |
| `page:events` | Events listing. | page | `#C5DEF5` |
| `page:faq` | Frequently asked questions. | page | `#C5DEF5` |
| `page:gallery` | Media gallery page. | page | `#C5DEF5` |
| `page:home` | Homepage. | page | `#C5DEF5` |
| `page:legal` | Legal/terms/privacy. | page | `#C5DEF5` |
| `page:newsletter-subscribe` | Subscribe/lead capture. | page | `#C5DEF5` |
| `page:portfolio` | Case studies/portfolio. | page | `#C5DEF5` |
| `page:products` | Product overview page. | page | `#C5DEF5` |
| `page:services` | Services/offerings. | page | `#C5DEF5` |
| `page:solutions` | Solution landing page(s). | page | `#C5DEF5` |
| `page:team` | Team/people listing. | page | `#C5DEF5` |
| `page:testimonials` | Testimonials/reviews page. | page | `#C5DEF5` |
| `page:thank-you` | Post‑form thank‑you page. | page | `#C5DEF5` |
| `issue:404-error` | Not found resource. | issue | `#D93F0B` |
| `issue:broken-link` | Link target is missing or wrong. | issue | `#D93F0B` |
| `issue:js-error` | JavaScript error in console/runtime. | issue | `#D93F0B` |
| `issue:open-link_blank` | Link target opens incorrectly (e.g., new tab handling). | issue | `#D93F0B` |
| `issue:redirect` | Incorrect/missing/looping redirects. | issue | `#D93F0B` |
| `device:desktop` | Large desktop widths. | device | `#E1E4E8` |
| `device:laptop` | Typical laptop widths. | device | `#E1E4E8` |
| `device:mobile` | Phone viewport. | device | `#E1E4E8` |
| `device:tablet-landscape` | Tablet landscape orientation. | device | `#E1E4E8` |
| `device:tablet-portrait` | Tablet portrait orientation. | device | `#E1E4E8` |
| `layout:content-width` | Constrained to content width. | layout | `#C5DEF5` |
| `layout:full-width` | Edge‑to‑edge layout. | layout | `#C5DEF5` |
| `layout:grid` | Grid layout (cards/tiles). | layout | `#C5DEF5` |
| `layout:list` | Vertical list layout. | layout | `#C5DEF5` |
| `layout:wide-width` | Wide content span. | layout | `#C5DEF5` |
| `theme:block-theme` | Block theme scaffolding. | theme | `#C5DEF5` |
| `theme:configuration` | Config, settings, env wiring. | theme | `#C5DEF5` |
| `theme:content-model` | CPTs, taxonomies, relationships. | theme | `#C5DEF5` |
| `theme:design-system` | DS tokens, components, patterns. | theme | `#C5DEF5` |
| `theme:plugin` | Plugin theme scaffolding. | theme | `#C5DEF5` |
| `theme:tour-operator` | Tour Operator plugin integration. | theme | `#C5DEF5` |
| `theme:woocommerce` | WooCommerce plugin integration. | theme | `#C5DEF5` |
| `size:L` | Significant scope; cross‑component impacts; higher QA breadth; coordination likely. | size | `#C2E0C6` |
| `size:M` | Moderate effort; multiple components or small template; some logic/data; modest QA. | size | `#C2E0C6` |
| `size:S` | Small change; one component/file; isolated tests; likely \< a day of flow (not time‑boxed). | size | `#C2E0C6` |
| `size:XL` | Large/epic‑level scope; multiple slices/releases; high uncertainty; needs discovery. | size | `#C2E0C6` |
| `size:XS` | Minimal effort; trivial copy/CSS token tweak; low risk. | size | `#C2E0C6` |
| `size:XS|S|M|L|XL|unknown` |  | size | `#C2E0C6` |
| `size:unknown` | Unscoped; insufficient info. Add a time‑boxed research, then re‑size. | size | `#C2E0C6` |
| `block:audio` | Audio block. | block | `#C5DEF5` |
| `block:button` | Button block. | block | `#C5DEF5` |
| `block:columns` | Columns layout. | block | `#C5DEF5` |
| `block:comments` | Comments block. | block | `#C5DEF5` |
| `block:cover` | Cover hero/media overlay. | block | `#C5DEF5` |
| `block:excerpt` | Post excerpt. | block | `#C5DEF5` |
| `block:featured-image` | Post/page featured image. | block | `#C5DEF5` |
| `block:gallery` | Media gallery block. | block | `#C5DEF5` |
| `block:group` | Group wrapper block. | block | `#C5DEF5` |
| `block:image` | Image block. | block | `#C5DEF5` |
| `block:list` | Ordered/unordered lists. | block | `#C5DEF5` |
| `block:pagination` | List pagination. | block | `#C5DEF5` |
| `block:post-navigation` | Previous/next post links. | block | `#C5DEF5` |
| `block:query-loop` | Post query loop. | block | `#C5DEF5` |
| `block:quote` | Quote/pullquote. | block | `#C5DEF5` |
| `block:read-more` | Read more link. | block | `#C5DEF5` |
| `block:site-logo` | Site logo block. | block | `#C5DEF5` |
| `block:social` | Social links block. | block | `#C5DEF5` |
| `block:video` | Video block. | block | `#C5DEF5` |
| `block:yoast-faq` | Yoast FAQ block. | block | `#C5DEF5` |
| `template:404` | Not found page. | template | `#C5DEF5` |
| `template:all-archives` | All archives base. | template | `#C5DEF5` |
| `template:category-archives` | Category archive. | template | `#C5DEF5` |
| `template:front-page` | Static front page. | template | `#C5DEF5` |
| `template:index` | Blog index fallback. | template | `#C5DEF5` |
| `template:page` | Generic page template. | template | `#C5DEF5` |
| `template:page-blank` | Minimal/blank canvas. | template | `#C5DEF5` |
| `template:page-default` | Theme default page. | template | `#C5DEF5` |
| `template:page-no-title` | Page without title. | template | `#C5DEF5` |
| `template:search-results` | Search results page. | template | `#C5DEF5` |
| `template:single` | Single post/page fallback. | template | `#C5DEF5` |
| `template:tag-archives` | Tag archive. | template | `#C5DEF5` |
| `template-part:breadcrumbs` | A template part that renders a breadcrumb trail (home → section → page) to show page hierarchy and aid wayfinding/SEO. Often added via a breadcrumbs block from an SEO plugin or theme pattern and placed near the header or page title. | template-part | `#C5DEF5` |
| `template-part:comments` | The comments area for single templates, powered by the Comments block, which bundles the title, comment list/template, pagination and the Post Comments Form. Typically sits after the main content. | template-part | `#C5DEF5` |
| `template-part:footer` | Reusable site footer region shared across templates; commonly includes copyright, menus, and contact/social links. Changes to the footer template part propagate to all templates that use it. | template-part | `#C5DEF5` |
| `template-part:header` | Reusable site header region shared across templates; typically contains Site Title/Logo, primary Navigation and utility elements. Editing the header template part updates every template that includes it. | template-part | `#C5DEF5` |
| `template-part:post-meta` | The strip that displays post metadata (e.g., author, date, categories, tags). Built with core blocks such as Post Author, Post Date, and Post Tags/Post Terms, and usually placed near the title or footer of single and archive templates. | template-part | `#C5DEF5` |
| `template-part:sidebar` | A secondary content area used for widgets/blocks such as navigation, recent posts, promos or CTAs. In classic themes it’s a registered widget area; in block themes it’s commonly implemented as a reusable template part included across relevant templates. | template-part | `#C5DEF5` |
| `woo:block-cart` | Cart block with inner blocks. | woo | `#D4C5F9` |
| `woo:block-checkout` | Checkout block with inner blocks. | woo | `#D4C5F9` |
| `woo:block-product-collection` |  | woo | `#D4C5F9` |
| `woo:block-product-collections` | Curated collections. | woo | `#D4C5F9` |
| `woo:block-product-search` | Search form/logic. | woo | `#D4C5F9` |
| `woo:coupons` | Coupons/discounts. | woo | `#D4C5F9` |
| `woo:emails` | Transactional emails. | woo | `#D4C5F9` |
| `woo:extension-subscriptions` | Subscriptions extension. | woo | `#D4C5F9` |
| `woo:page-cart` | Cart page. | woo | `#D4C5F9` |
| `woo:page-checkout` | Checkout page. | woo | `#D4C5F9` |
| `woo:page-coming-soon` | Temporary storefront state. | woo | `#D4C5F9` |
| `woo:page-my-account` | Account dashboard/areas. | woo | `#D4C5F9` |
| `woo:page-order-confirmation` | Order received/thank‑you. | woo | `#D4C5F9` |
| `woo:part-checkout-header` | Checkout header/steps. | woo | `#D4C5F9` |
| `woo:part-mini-cart` | Off‑canvas/mini cart. | woo | `#D4C5F9` |
| `woo:part-single-product-info` | Buy box/details area. | woo | `#D4C5F9` |
| `woo:patterns` | Woo patterns used. | woo | `#D4C5F9` |
| `woo:product-gallery` | Product gallery UI. | woo | `#D4C5F9` |
| `woo:product-image` | Main/alt images handling. | woo | `#D4C5F9` |
| `woo:product-reviews` | Reviews UI/logic. | woo | `#D4C5F9` |
| `woo:related-products` | Related/recommended modules. | woo | `#D4C5F9` |
| `woo:shipping` | Shipping rules/UI/integration. | woo | `#D4C5F9` |
| `woo:single-product` | Single product template. | woo | `#D4C5F9` |
| `woo:tax` | Taxes/config. | woo | `#D4C5F9` |
| `woo:template-product-archives` | All product archives. | woo | `#D4C5F9` |
| `woo:template-product-attribute-archives` | Attribute archives. | woo | `#D4C5F9` |
| `woo:template-product-brand-archives` | Brand archives. | woo | `#D4C5F9` |
| `woo:template-product-category-archives` | Category archives. | woo | `#D4C5F9` |
| `woo:template-product-search-results` | Results listing. | woo | `#D4C5F9` |
| `woo:template-product-tag-archives` | Tag archives. | woo | `#D4C5F9` |
| `woo:template-shop` | Shop index page. | woo | `#D4C5F9` |
| `to:accommodation-archive` | Accommodation post type archive. | to | `#C5DEF5` |
| `to:accommodation-facilities` |  | to | `#C5DEF5` |
| `to:accommodation-rooms` | - `to:accommodation-facilities` — | to | `#C5DEF5` |
| `to:accommodation-type-archive` | Accommodation Type taxonomy archive. | to | `#C5DEF5` |
| `to:brand-archive` | Accommodation Brands taxonomy archive. | to | `#C5DEF5` |
| `to:continent-archive` | Geographic continents taxonomy archive. | to | `#C5DEF5` |
| `to:core` | Core plugin functions. | to | `#C5DEF5` |
| `to:destinations-archive` | Destination post type archive. | to | `#C5DEF5` |
| `to:fast-facts` | Fast facts module. | to | `#C5DEF5` |
| `to:maps` | Mapping/locations. | to | `#C5DEF5` |
| `to:post-relationships` | Post relationships model. | to | `#C5DEF5` |
| `to:prices` | Pricing/rates logic. | to | `#C5DEF5` |
| `to:read-more` | Read‑more panels/links. | to | `#C5DEF5` |
| `to:related-accommodation` | Related accommodation. | to | `#C5DEF5` |
| `to:related-destinations` | Related destinations. | to | `#C5DEF5` |
| `to:related-tours` | Related tours component. | to | `#C5DEF5` |
| `to:reviews` | Reviews module. | to | `#C5DEF5` |
| `to:search-results` | TO search results. | to | `#C5DEF5` |
| `to:single-accommodation` | Accommodation detail. | to | `#C5DEF5` |
| `to:single-country` | Country detail. | to | `#C5DEF5` |
| `to:single-destination` | Destination detail. | to | `#C5DEF5` |
| `to:single-region` | Region detail. | to | `#C5DEF5` |
| `to:single-review` | Review detail. | to | `#C5DEF5` |
| `to:single-special` | Special offer detail. | to | `#C5DEF5` |
| `to:single-team` | Team member detail. | to | `#C5DEF5` |
| `to:single-tour` | Tour detail. | to | `#C5DEF5` |
| `to:specials` | Specials/promotions. | to | `#C5DEF5` |
| `to:team` | Team module. | to | `#C5DEF5` |
| `to:team-archive` | Team post type archive. | to | `#C5DEF5` |
| `to:tour-archive` | Tour post type archive. | to | `#C5DEF5` |
| `to:tour-itinerary` | Itinerary presentation. | to | `#C5DEF5` |
| `to:travel-style-archive` | Travel style taxonomy archive. | to | `#C5DEF5` |
| `to:wetu-importer` | Wetu import flows. | to | `#C5DEF5` |
| `compat:gutenberg` | Package compatibility | compat | `#D93F0B` |
| `compat:multisite` | Multisite/network considerations. | compat | `#F9D0C4` |
| `compat:php` | Min/tested-up-to PHP | compat | `#D93F0B` |
| `compat:rtl` | Right-to-left layout support | compat | `#D93F0B` |
| `compat:woocommerce` | WooCommerce versions | compat | `#D93F0B` |
| `compat:wordpress` | Core/Gutenberg versions | compat | `#D93F0B` |
| `lang:css` | Stylesheets | lang | `#C5DEF5` |
| `lang:html` | Markup | lang | `#C5DEF5` |
| `lang:js` | JavaScript/TypeScript | lang | `#C5DEF5` |
| `lang:json` | JSON config/content | lang | `#C5DEF5` |
| `lang:md` | Markdown content/docs | lang | `#C5DEF5` |
| `lang:php` | PHP code | lang | `#C5DEF5` |
| `lang:yaml` | YAML config | lang | `#C5DEF5` |
| `cpt:pages` | WordPress Pages | cpt | `#C5DEF5` |
| `cpt:posts` | WordPress Posts | cpt | `#C5DEF5` |
| `meta:has-pr` | Issue has a linked PR | meta | `#E1E4E8` |
| `meta:needs-changelog` | Requires a changelog entry before merge | meta | `#E1E4E8` |
| `meta:no-issue-activity` | No recent issue activity | meta | `#E1E4E8` |
| `meta:no-pr-activity` | No recent PR activity | meta | `#E1E4E8` |
| `meta:stale` | Marked as stale | meta | `#9198A1` |
| `ai-ops:agents` | Agent definitions | ai-ops | `#0052CC` |
| `ai-ops:chat-modes` | Prompt sets / modes | ai-ops | `#0052CC` |
| `ai-ops:datasets` | Training/eval datasets | ai-ops | `#BFD4F2` |
| `ai-ops:evaluations` | Evaluation results | ai-ops | `#BFD4F2` |
| `ai-ops:instructions` | AI instruction docs | ai-ops | `#0052CC` |
| `ai-ops:prompts` | Reusable prompts | ai-ops | `#0052CC` |
| `ai-ops:tools` | Tool/plugin manifests | ai-ops | `#BFD4F2` |
| `contrib:good-first-issue` | Good for first-time contributors. | contrib | `#D4C5F9` |
| `contrib:help-wanted` | Maintainer requests help. | contrib | `#C2E0C6` |
| `release:hotfix` | Urgent correction to a released version outside the normal cadence | release | `#D29922` |
| `release:major` | Breaking changes requiring a MAJOR version bump | release | `#F85149` |
| `release:minor` | Backwards‑compatible enhancements requiring a MINOR version bump | release | `#58A6FF` |
| `release:patch` | Backwards‑compatible bug fixes requiring a PATCH version bump | release | `#3FB950` |
