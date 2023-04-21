import 'package:get/get.dart';

import '../modules/branchData/bindings/branch_data_binding.dart';
import '../modules/branchData/views/branch_data_view.dart';
import '../modules/gas_manifold/bindings/gas_manifold_binding.dart';
import '../modules/gas_manifold/views/gas_manifold_view.dart';
import '../modules/gas_monitor/bindings/gas_monitor_binding.dart';
import '../modules/gas_monitor/views/gas_monitor_view.dart';
import '../modules/gas_vendor/bindings/gas_vendor_binding.dart';
import '../modules/gas_vendor/views/gas_vendor_view.dart';
import '../modules/gases/bindings/gases_binding.dart';
import '../modules/gases/views/gases_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/searchBySerialNo/bindings/search_by_serial_no_binding.dart';
import '../modules/searchBySerialNo/views/search_by_serial_no_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GAS_MANIFOLD,
      page: () => GasManifoldView(),
      binding: GasManifoldBinding(),
    ),
    GetPage(
      name: _Paths.GAS_MONITOR,
      page: () => GasMonitorView(),
      binding: GasMonitorBinding(),
    ),
    GetPage(
      name: _Paths.GAS_VENDOR,
      page: () => GasVendorView(),
      binding: GasVendorBinding(),
    ),
    GetPage(
      name: _Paths.GASES,
      page: () => GasesView(),
      binding: GasesBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BRANCH_DATA,
      page: () => BranchDataView(),
      binding: BranchDataBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_BY_SERIAL_NO,
      page: () =>  SearchBySerialNoView(),
      binding: SearchBySerialNoBinding(),
    ),
  ];
}
