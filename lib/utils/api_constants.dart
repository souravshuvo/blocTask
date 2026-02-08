class ApiConstants {
  // Base URLs
  static const String peanutBaseUrl = 'https://peanut.ifxdb.com';
  static const String promoServiceUrl = 
      'https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc';
  
  // Endpoints - Corrected based on Swagger docs
  static const String authEndpoint = '/api/ClientCabinetBasic/IsAccountCredentialsCorrect';
  static const String accountInfoEndpoint = '/api/ClientCabinetBasic/GetAccountInformation';
  static const String phoneEndpoint = '/api/ClientCabinetBasic/GetLastFourNumbersPhone';
  static const String tradesEndpoint = '/api/ClientCabinetBasic/GetOpenTrades';
  
  // Image domain replacement
  static const String oldImageDomain = 'forex-images.instaforex.com';
  static const String newImageDomain = 'forex-images.ifxdb.com';
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
