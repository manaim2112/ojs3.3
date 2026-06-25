# Security Fixes — OJS 3.3.0

## CVE-2025-13469 — XSS in Manual Payment Instructions
- **Status**: ✅ Fixed by PKP (commit `4d622797cc`)
- **Severity**: 2.4 Low
- **File**: `plugins/paymethod/manual/templates/paymentForm.tpl`
- **Fix**: Escape `manualInstructions` parameter

## CVE-2024-25438 — XSS in Discussion Subject Field
- **Status**: ✅ Fixed
- **Severity**: 6.1 Medium
- **File**: `lib/pkp/controllers/grid/queries/form/QueryForm.inc.php`
- **Fix**: Added `strip_tags()` on subject input before storing

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
- **Status**: ✅ Fixed
- **Severity**: 4.3 Medium
- **File**: `lib/pkp/pages/login/LoginHandler.inc.php`
- **Fix**: Validate `source` parameter with regex to only allow safe relative paths

## CVE-2011-5196 — CSRF File Upload
- **Status**: ✅ Not applicable (OJS 2.x only)
- **Severity**: N/A
