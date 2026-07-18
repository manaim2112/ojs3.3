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
