class Constants {
  static String employeeId = '';
  static String companyCode = '';

  static String selectedLeadNo = '';
  static String selectedCustomerName = '';
  static String selectedPhoneNumber = '';
  static String selectedCompanyName = '';
  static String selectedDOB = '';
  static String selectedcoppiedFrom = '';
  static bool selectedSearhed = false;
  static bool isDataAvailable = true;

  static const version = '2.0.1';
  static const androidCode = '25';
  static String agentInitial = 'A202';

  static String employeeIDKey = 'EmployeeID';
  static String logInStatusKey = 'LogInStatus';
  static String employeeNameKey = 'EmployeeName';
  static String employeeContactKey = 'EmployeeContact';
  static String employeeEmailKey = 'EmployeeEmail';
  static String employeeSBUKey = 'employeeSBU';

  static String baseURL = 'http://fairbook.fairgroupbd.com';
  // static String baseURL = 'http://10.100.17.125:8090/rbd'; // sir lan
  // static String baseURL = 'http://10.100.18.167:8090/rbd'; // sir wifi

  static String globalURL = '$baseURL/leadInfoApi';
  static String dsiGlobalURL = '$baseURL/dsiFormApi';
}
