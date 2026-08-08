# Contractor App — Architecture

Same core layer as your attendance app, reused as-is. Every feature module
follows the identical 3-step recipe below — nothing new to learn per module.

## Core (don't touch per-feature)
```
core/api/api_client.dart          -> baseUrl.get / .post / .put / .patch / .delete
core/api/api_request_builder.dart -> generic builder, .execute() calls ApiService
core/api/api_service.dart         -> single Dio instance + caching
core/api/api_cache_store.dart     -> in-memory cache (swap for hive/shared_prefs later)
core/api/header_interceptor.dart  -> auth token + content-type headers
core/api/api_endpoints.dart       -> ALL route strings, grouped by feature
core/constants/app_colors.dart
core/theme/app_theme.dart
core/utils/responsive.dart
```

## Per-feature recipe (already done for `company` and `projects`)
1. **Model** — `features/<name>/data/models/<name>_model.dart`
   Plain class + `fromJson` (+ `toJson` if it's ever sent as a request body).
2. **Service** — `features/<name>/data/services/<name>_service.dart`
   One singleton class. Every method builds an `ApiRequestBuilder<T>` pointing
   at an `ApiEndpoints.xxx` constant, and returns `.execute()`.
3. **Screens/widgets** — `features/<name>/presentation/...`
   Call the service, not Dio directly, ever.

## Remaining modules to fill in with the same recipe
- `recruitment` — search workers, worker profile, applications, hire
  (endpoints already added: `searchWorkers`, `workerProfile`, `projectApplications`,
  `reviewApplication`, `hireWorker`)
- `workforce` — team management, attendance approval, daily progress
  (endpoints: `projectTeam`, `assignWorker`, `pendingAttendanceApprovals`,
  `approveAttendance`, `rejectAttendance`, `dailyProgressUpdates`, `postDailyProgress`)
- `materials` — raise requests, track usage
  (endpoints: `raiseMaterialRequest`, `projectMaterialRequests`, `materialUsage`,
  `logMaterialUsage`)
- `financial` — labour expense tracking, reports
  (endpoints: `labourExpenses`, `logLabourExpense`, `projectFinancialReport`,
  `companyFinancialReport`)
- `notifications` — list, mark read, device token registration
  (endpoints: `notifications`, `markNotificationRead`, `markAllNotificationsRead`,
  `registerDeviceToken`)
- `auth` — login/logout/refresh token, wiring into `AuthTokenStore`

All the route strings for these already exist in `api_endpoints.dart` — the
remaining work per module is just writing the model + service files, same
shape as `company_service.dart` / `project_service.dart`.

## Note on the "construction seeker" side
Since this contractor app is the side that approves/reviews things (hiring,
attendance, material requests) that originate from workers on the seeker app,
most of those modules will have a `pending` list + an `approve`/`reject`
action — that pattern is already set up in `workforce` (`pendingAttendanceApprovals`
→ `approveAttendance`/`rejectAttendance`) and can be copied for material
requests and applications too.
