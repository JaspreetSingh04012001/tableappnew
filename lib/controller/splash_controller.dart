import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/data/api/api_checker.dart';
import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:efood_table_booking/data/repository/splash_repo.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  final ApiClient apiClient;
  SplashController({required this.splashRepo, required this.apiClient});

  final DateTime _currentTime = DateTime.now();
  int? _selectedBranchId;
  int? _selectedTableId;
  bool _isFixTable = false;

  int? get selectedBranchId => _selectedBranchId;
  int? get selectedTableId => _selectedTableId;
  bool get isFixTable => _isFixTable;

  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    if (isUpdate) {
      update();
    }
  }

  TableModel? getTable(tableId, {int? branchId}) {
    TableModel? tableModel;
    try {
      tableModel = _configModel?.branch
          ?.firstWhere((branch) => branch.id == (branchId ?? getBranchId()))
          .table
          ?.firstWhere((table) => table.id == tableId);
    } catch (e) {
    //  debugprint('table error : $e');
    }
    return tableModel;
  }

  void updateTableId(int? number, {bool isUpdate = true}) {
    _selectedTableId = number;
    if (isUpdate) {
      update();
    }
  }

  void updateFixTable(bool value, bool isUpdate) {
    _isFixTable = value;
    if (isUpdate) {
      update();
    }
  }

  DateTime get currentTime => _currentTime;
  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  Future<bool> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      if (response.statusText == ApiClient.noInternetMessage) {}
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  int getTableId() => splashRepo.getTable();

  int getBranchId() => splashRepo.getBranchId();
  bool getIsFixTable() => splashRepo.getFixTable();

  void setBranch(int id) async {
    splashRepo.setBranchId(id);
    apiClient.updateHeader();
    update();
  }

  void setTableId(int id) {
    splashRepo.satTable(id);
    Get.find<OrderController>().getOrderList();
    update();
  }

  void setFixTable(bool value) {
    splashRepo.setFixTable(value);
  }
}
