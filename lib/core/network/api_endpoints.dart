class ApiEndpoints {
  ApiEndpoints._();

  // ---- Auth ----
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  // ---- Home ----
  static const String homeProfile = '/home/profile';
  static String toggleActionVisibility(String actionId) =>
      '/home/actions/$actionId/visibility';



// ---- Home ----
  static const String attendanceToday = '/attendance/today';
  static const String checkIn = '/attendance/check-in';
  static const String checkOut = '/attendance/check-out';
  static String attendanceMonth(int year, int month) => '/attendance/month/$year/$month';
  static String attendanceSummary(int year, int month) => '/attendance/summary/$year/$month';


  static String attendanceRange(String fromIso, String toIso) =>
    '/attendance/range?from=$fromIso&to=$toIso';

static const String myLeaves = '/leave/mine';
static const String raiseLeave = '/leave/raise';
}