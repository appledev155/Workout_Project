class AppConfig {
  final String apiUrl = 'https://beta-front.uae.estate/api/';
  final String host = 'beta-front.uae.estate';
  final String contextRoot = 'api/';
  final double designWidth = 404;
  final double designHeight = 750;
  int maxMediaUpload = 1;
  String appReleaseHash = "";
  bool allowMultipleMedia = false;
  String staticUserImage = "https://i.uaeaqar.com/assets/images/user.png";
  int numberOfRecords = 500;
  int algoliaTimeOut = 30;
  int numberOfRecordsOnLowNetwork = 100;
  int algoliaTimeOutOnLowNetwork = 40;
  bool displayToastMessage = true;
  bool firstBoot = false;
  bool sendLoginTokenActivity = false;
  bool detachedEventCalled = false;
  bool resetBatchCountCalled = false;
  bool setHomeScreenRoute = false;
}
