class FirestorePath {
  static String usersPath() => 'users/';
  static String userPath(String uid) => 'users/$uid';

  static String wheelchairsPath() => 'wheelchairs/';
  static String wheelchairPath(String uid) => 'wheelchairs/$uid';
  static String navigationPath(String uid) => 'navigations/$uid';

  static String msgLogsPath() => 'msgLogs/';
}
