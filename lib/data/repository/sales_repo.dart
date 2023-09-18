import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class SalesRepo {
  final ApiClient apiClient;
  SalesRepo({required this.apiClient});

  Future<Response> getSales(
      {required int branch_id,
      required String from,
      required String to}) async {
    return await apiClient.getData(
        '${AppConstants.salesUri}?branch_id=$branch_id&from=$from&to=$to');
    //'${AppConstants.salesUri}?branch_id=1&from=04-07-2023&to=04-07-2023');
  }

  Future<Response> sendSales(
      {required int branch_id, required String year, String? quarter}) async {
    return await apiClient.postData(AppConstants.sendSalesUri, {
      "branch_id": branch_id,
      "year": year,
      if (quarter != null) "quarter": quarter
    });
    //'${AppConstants.salesUri}?branch_id=1&from=04-07-2023&to=04-07-2023');
  }
}
