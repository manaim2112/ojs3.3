# Security Fixes — OJS 3.3.0

## CVE-2025-13469 — XSS in Manual Payment Instructions
- **Status**: ✅ Fixed by PKP (commit `4d622797cc`)
- **Severity**: 2.4 Low
- **File**: `plugins/paymethod/manual/templates/paymentForm.tpl`
- **Fix**: Escape `manualInstructions` parameter

## CVE-2024-25438 — XSS in Discussion Subject Field
- **Status**: ✅ Fixed (adopted PKP approach: output escaping)
- **Severity**: 6.1 Medium
- **File**: `lib/pkp/controllers/grid/queries/form/QueryForm.inc.php`
- **Fix**: PKP removed input-side `strip_tags()` and relies on Smarty output
  escaping (`|escape`) when rendering the subject/note title. This prevents
  stored XSS without stripping legitimate formatting. Input-side `strip_tags()`
  was dropped because it corrupted user formatting.
- **Note**: Ensure templates render `$subject` / note title with `|escape`.

## CVE-2022-26616 — Reflected XSS via HTTP Headers
- **Status**: ✅ Fixed by PKP (commit `0f01001d5b`, `2507604c68`)
- **Severity**: 6.1 Medium
- **File**: Core PKP handler

## CVE-2022-24181 — XSS via Host Header Injection
- **Status**: ✅ Code fix in place (`AllowedHostsPolicy`)
- **Severity**: 6.1 Medium
- **File**: `lib/pkp/classes/security/authorization/AllowedHostsPolicy.inc.php`
- **Config**: Set `allowed_hosts` in `config.inc.php` for production:
  ```
  allowed_hosts = '["yourdomain.com"]'
  ```

## CVE-2024-7902 — Open Redirect via signOut
- **Status**: ✅ Fixed (custom hardening — stricter than PKP upstream)
- **Severity**: 4.3 Medium
- **File**: `lib/pkp/pages/login/LoginHandler.inc.php`
- **Fix**: Validate `source` parameter with regex `^[a-zA-Z0-9_./-]+$` to only
  allow safe relative paths. PKP upstream only strips `@` (weaker; still allows
  `javascript:` URLs / path traversal). **Our regex fix is kept on top of the
  PKP submodule update and must be re-applied after any `lib/pkp` update.**

## CVE-2011-5196 — CSRF File Upload
- **Status**: ✅ Not applicable (OJS 2.x only)
- **Severity**: N/A

---

## PKP Submodule Hardening (synced `lib/pkp` → `4a8df42558`, 2026-07-10)

The `lib/pkp` submodule was updated to the latest official PKP
`stable-3_3_0` tip to absorb the following security hardening. These are
PKP-maintained fixes; our local fork (`manaim2112/pkp-lib`) did not have them.

### pkp/pkp-lib#13024 — Validate plugin category
- **Severity**: Medium (plugin loading hardening)
- **File**: `lib/pkp/classes/plugins/PluginRegistry.inc.php`
- **Fix**: Validates the plugin category before loading.

### pkp/pkp-lib#13030 — Constrain file extension in native XML import
- **Severity**: Medium (arbitrary file upload via XML import)
- **File**: `lib/pkp/classes/filter/NativeXmlSubmissionFileFilter.inc.php`
- **Fix**: Restricts allowed file extensions when importing submission files
  via native XML import.

### Dependency updates
- **Commit**: `159111ee59` (2026-07-10)
- **File**: `lib/pkp/composer.lock`
- **Fix**: Selected dependency updates (supply-chain hardening).

> **Action required after every `lib/pkp` update**: re-apply the stricter
> `LoginHandler.inc.php` regex fix for CVE-2024-7902, since PKP upstream uses
> the weaker `str_replace('@', ...)` approach.

---

## Performance Hardening (availability / DoS resistance)

### Search result caching
- **File**: `classes/search/ArticleSearch.inc.php`, `config.inc.php`
- **Fix**: Overrides `_getMergedArray()` to cache the expensive keyword/phrase
  search merge (the `submission_search` JOINs) in a `FileCache` for anonymous
  visitors. Repeated identical searches skip the DB-heavy phrase merge.
- **Config**: `[search] search_cache_hours = 6` (set `0` to disable).
- **Bypass**: Logged-in users and personalised (`$exclude`) searches always
  bypass the cache, because article/issue availability can vary per user.
- **Note**: Caching only stores the lightweight `submission_id => count` map,
  never hydrated objects, so invalidation is safe (cache auto-expires by TTL
  and is cleared by the standard OJS cache-clear tooling).

### Search N+1 query reduction
- **File**: `classes/search/ArticleSearch.inc.php`
- **Fix**: `getSparseArray()` now batch-loads all submissions for `authors`/
  `title` sorting in a single `IN()` query instead of one `getById()` per
  result. `formatResults()` batch-loads the current page's submissions in one
  query instead of `Services::get('submission')->get()` per result.
- **Impact**: Turns O(N) submission queries per search into O(1) for both the
  merge/sort step (all results) and the formatting step (current page).

### Journal landing page (`index.php/<journal>`) caching
- **Symptom**: Journal home pages (e.g. `index.php/alj`) were intermittently
  slow because every anonymous request re-rendered the full current-issue TOC
  and announcements from scratch.
- **Fix (TTL file cache, no cron)**: `pages/index/IndexHandler.inc.php` now
  caches the fully-rendered HTML of the journal landing page in a `FileCache`
  for anonymous, non-restricted visitors. Served until the TTL expires.
  Auto-cleared when OJS cache is cleared (no cron required). A `X-OJS-Cache: HIT`
  header is sent on cache hits for debugging.
- **Config** (`config.inc.php`, NOT tracked by git):
  ```ini
  [cache]
  journal_page_cache_hours = 1   ; 0 disables
  ```
- **Alternative**: `web_cache = On` also works but requires a cron job to
  clear stale `wc-*.html` files. The FileCache approach above is preferred
  because it is TTL-based and self-expiring.
