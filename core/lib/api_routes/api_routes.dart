class ApiRoutes {
  //BASE URL
  static const String baseUrl = "https://api.sampleflutterproject.com/";
  static const String baseProfileUrl =
      "https://api.sampleflutterproject.com/uploads/profile_img/";
  static const String baseNationalIdUrl =
      "https://api.sampleflutterproject.com/uploads/national_id/";
  static const String baseGovLaterUrl =
      "https://api.sampleflutterproject.com/uploads/gov_later/";

  //AUTH
  static const String signIn = "api/auth/login";
  static const String signUp = "api/auth/signup";
  static const String emailIsExist = "api/auth/check-email";

  //Profile
  static const String userUpdate = "api/user/update";
  static const String userGetById = "api/user/get-by-id";
  static const String fcmUpdate = "/api/fcm/add";

  //home detail
  static const String homeDetails = "api/user/dashboard";

  //Get profile By Id
  static const String getProfileById = "/api/user/get-by-id";

  //User loan request
  static const String userLoanRequest = "/api/user/loan/request";

  //get all sponsor
  static const String getAllSponsor = "/api/sponser/list-get";

  //get all my loan
  static const String getAllMyLoan = "/api/user/loan/list-get";

  //get all sponsor loan
  static const String getAllSponserLoan = "/api/sponser/loan-get";

  //get my loan detail
  static const String getMyLoanDetail = "/api/user/loan/get-id";

  //get sponsor loan detail
  static const String getSponsorDetail = "/api/sponser/loan-get-id";

  //withDraw / Close loan from user Side
  static const String withDrawLoanFromUser = "api/user/loan/withdraw";

  //Give loan status from sponsor
  static const String giveLoanStatusFromSponsor = "/api/sponser/loan-approve";

  //create chat id
  static const String createChatId = "/api/user/chat/create";

  //Admin
  static const String getAdminDashboardDetail = "/api/admin/dashboard";
  static const String getAllUser = "api/user/get-all";
  static const String giveKycStatus = "/api/admin/verification";
  static const String statusUpdate = "/api/admin/status-update";
  static const String getUserStatementList = "/api/admin/loan/get";
  static const String getUserStatementDetails = "/api/admin/loan/get-details";
  static const String giveLoanStatusFromAdmin = "/api/admin/loan/status";
  static const String reOpenLoanFromAdmin = "/api/admin/loan/re_open";
  static const String newEditLoan = "/api/admin/loan/edit";
  static const String loanEditDetails = "/api/admin/loan/edit-details";


  static const String hideOrUnHideLoan = "/api/admin/loan/hide-unhide";



  static const String sendAllUserNotification = "/api/notification/send";
  static const String getUserAllNotification = "/api/notification/get";
  static const String getAllAdminNotification = "/api/notification/get-admin";


  static const String pendingLoanList = "/api/admin/loan/request-list";
  static const String getAllSponsorById = "/api/admin/loan/get-sponsers";
  static const String giveStatusOfLoanInstallment = "/api/admin/loan/pay";
  static const String getRecentUser = "/api/user/recent";
  static const String getTopBorrower = "/api/admin/top-borrower";

  //Reports
  static const String getNewUsers = "/api/data/new-user";
  static const String getNewLoan = "/api/data/new-loan";


}
