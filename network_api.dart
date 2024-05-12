import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zamzambazar/helper/sharedPreference_helper.dart';
import 'package:zamzambazar/model/category_model.dart';
import 'package:zamzambazar/model/customer_model.dart';
import 'package:zamzambazar/model/emailAccount_model.dart';
import 'package:zamzambazar/model/login_response_model.dart';
import 'package:zamzambazar/model/manualOrderInfo_model.dart';
import 'package:zamzambazar/model/oder_submit_response_model.dart';
import 'package:zamzambazar/model/orderInfo_model.dart';
import 'package:zamzambazar/model/order_info_details_model.dart';
import 'package:zamzambazar/model/order_submit_model.dart';
import 'package:zamzambazar/model/product_model_db.dart';
import 'package:zamzambazar/model/save_user_model_response.dart';
import 'package:zamzambazar/model/subCategory_model.dart';
import 'package:zamzambazar/model/unit_model.dart';
import 'package:zamzambazar/model/upazila_model.dart';
import 'package:zamzambazar/model/update_order_status_by_admin_model.dart';

class NetWorkApiProvider {
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
  //var baseurl = 'http://medp.zamzambazar.com/api/';
  var baseurl = 'https://zamzambazar.a2zmanager.com/api/';
  static const getAllCategory = 'OrderDB/GetAllCategory';
  static const getAllProductByCategoryId =
      '/OrderDB/GetProductByCategoryId?categoryId=2';

  Future<LoginResponseModel> userLoginPost({body}) async {
    var response = await http.post(Uri.parse(baseurl + 'Login/Login'),
        body: jsonEncode(body.toJson()), headers: headers);
    final reponse = json.decode(response.body);

    return LoginResponseModel.fromJson(reponse);
  }

  Future<CategoryModel> getcategoryList() async {
    var response = await http.get(Uri.parse(baseurl + getAllCategory), headers: headers);
    final reponse = json.decode(response.body);
    return CategoryModel.fromJson(reponse);
  }

  Future<UnitModel> getUnitList() async {
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'Unit/GetAllUnit'), headers: headers);
    //print( baseurl +  response.body.toString());
    final reponse = json.decode(response.body);
    return UnitModel.fromJson(reponse);
  }

  Future<ProductModel> getAllProductListByCategoryId({categoryId}) async {
    //print(categoryId);
    var response = await http.get(Uri.parse(baseurl + 'OrderDB/GetProductByCategoryId?categoryId=$categoryId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return ProductModel.fromJson(reponse);
  }

  Future<ProductModel> getAllProductList() async {
    var response = await http.get(Uri.parse(baseurl + 'OrderDB/GetAllProduct'),
        headers: headers);
    final reponse = json.decode(response.body);
    return ProductModel.fromJson(reponse);
  }

  Future<OrderSubmitResponseModel> saveOrderInfo(
      OrderSubmitModel object) async {
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'OrderInfo/SaveOrderInfo'),
        body: jsonEncode(object.toJson()),
        headers: headers);
    final reponse = json.decode(response.body);
    return OrderSubmitResponseModel.fromJson(reponse);
  }

  Future<SubCategoryModel> getAllSubCategoryListByCategoryId({categoryId}) async {
    //print(categoryId);
    var response = await http.get(Uri.parse(baseurl + 'OrderDB/GetAllSubCategoryByCategoryId?id=$categoryId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return SubCategoryModel.fromJson(reponse);
  }

  Future<OrderSubmitResponseModel> saveManualOrderInfo(
      ManualOrderInfoItem object) async {
    //print(object.toJson());
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'ManualOrderInfo/SaveManualOrderInfo'),
        body: jsonEncode(object.toJson()),
        headers: headers);
    //print(response.toString());
    final reponse = json.decode(response.body);
    return OrderSubmitResponseModel.fromJson(reponse);
  }

  Future<OrderInfoModel> getAllOrderListUser() async {
    var loginUserId = await SharedPreferencesHelper.getLoginUserId();
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'OrderInfo/GetOrderInfoByCustomerId?customerId=$loginUserId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return OrderInfoModel.fromJson(reponse);
  }

  Future<ManualOrderInfoModel> getAllManualOrderListUser() async {
    var loginUserId = await SharedPreferencesHelper.getLoginUserId();
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'ManualOrderInfo/GetManualOrderInfoByCustomerId?customerId=$loginUserId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return ManualOrderInfoModel.fromJson(reponse);
  }

  Future<CustomerModel> getAllVoluteers() async {
    var userId = await SharedPreferencesHelper.getLoginUserId();
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'Customer/GetCustomerByTypeAndUser?id=$userId&type=Volunteer'),
        headers: headers);
    final reponse = json.decode(response.body);
    return CustomerModel.fromJson(reponse);
  }

  Future<OrderInfoModel> getAllOrderListAdmin({int typeToShowOrder = 1}) async {
    var userId = await SharedPreferencesHelper.getLoginUserId();
    var accountsType = await SharedPreferencesHelper.getAccountsType();

    String url = 'OrderInfo/GetAllOrderInfo?id=$userId&userType=$accountsType';
    if(typeToShowOrder == 1){
      url = 'OrderInfo/GetAllOrderInfoForAduit?id=$userId&userType=$accountsType';
    }
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + url),
        headers: headers);
    final reponse = json.decode(response.body);
    return OrderInfoModel.fromJson(reponse);
  }

  Future<ManualOrderInfoModel> getAllManualOrderListAdmin({int typeToShowOrder = 1}) async {
    var userId = await SharedPreferencesHelper.getLoginUserId();
    var accountsType = await SharedPreferencesHelper.getAccountsType();

    String url = 'ManualOrderInfo/GetAllManualOrderInfo?id=$userId&userType=$accountsType';
    if(typeToShowOrder == 1){
      url = 'ManualOrderInfo/GetAllManualOrderInfoForAduit?id=$userId&userType=$accountsType';
    }
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + url),
        headers: headers);
    final reponse = json.decode(response.body);
    return ManualOrderInfoModel.fromJson(reponse);
  }

  Future<UpdateOrderStatusByAdminModel> updateOrderStatusByAdmin(
      {orderID, status}) async {
    var loginUserId = await SharedPreferencesHelper.getLoginUserId();

    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'OrderInfo/UpdateOrderStatus?orderId=$orderID&userId=$loginUserId&status=$status'),
        headers: headers);
    final reponse = json.decode(response.body);
    return UpdateOrderStatusByAdminModel.fromJson(reponse);
  }

  Future<UpdateOrderStatusByAdminModel> updateDeliveryPerson(
      {orderID, status, deliveryPersonId}) async {
    var loginUserId = await SharedPreferencesHelper.getLoginUserId();

    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'OrderInfo/UpdateOrderStatus?orderId=$orderID&userId=$loginUserId&status=$status&deliveryPersonId=$deliveryPersonId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return UpdateOrderStatusByAdminModel.fromJson(reponse);
  }

  Future<OrderInfoDetailsModel> getOrderInfoDetails({orderId}) async {
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'OrderInfo/GetOrderInfoById?id=$orderId'),
        headers: headers);
    final reponse = json.decode(response.body);
    return OrderInfoDetailsModel.fromJson(reponse);
  }

  Future<SaveUserModelResponse> saveCustomer(
      {CustomerItem saveCustomer}) async {
    //print(saveCustomer.toJson());
    var response = await http.post(Uri.parse(baseurl + 'Customer/SaveCustomer'),
        body: jsonEncode(saveCustomer.toJson()), headers: headers);
    //print("Status Code ${response.statusCode}");

    final reponse = json.decode(response.body);
    return SaveUserModelResponse.fromJson(reponse);
  }

  Future<OrderSubmitResponseModel> updateProductInfo(
      {ProductItem product}) async {
    //print(product.toupdateJsonFile());
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'Product/UpdateProductInformation'),
        body: jsonEncode(product.toupdateJsonFile()), headers: headers);

    final reponse = json.decode(response.body);
    return OrderSubmitResponseModel.fromJson(reponse);
  }

  Future<OrderSubmitResponseModel> saveProductInfo(
      {ProductItem product}) async {
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.post(Uri.parse(baseurl + 'Product/SaveProduct'),
        body: jsonEncode(product.toJsonWithoutId()), headers: headers);

    final reponse = json.decode(response.body);
    return OrderSubmitResponseModel.fromJson(reponse);
  }

  Future<EmailAccountModel> getAllEmailAccountModel() async {
    var token = await SharedPreferencesHelper.getToken();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'EmailAccount/GetAllEmailAccount'),
        headers: headers);
    final reponse = json.decode(response.body);
    return EmailAccountModel.fromJson(reponse);
  }

  Future<UpazilaModel> getAllUpazila() async {
    var token = await SharedPreferencesHelper.getToken();
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'Upazila/GetAllUpazila'), headers: header);
    final allListItem = UpazilaModel.fromJson(jsonDecode(response.body));

    return allListItem;
  }

  Future<UpazilaModel> getAllUpazilaByUser({userId, userType}) async {
    var token = await SharedPreferencesHelper.getToken();
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer $token"
    };
    var response = await http.get(Uri.parse(baseurl + 'Upazila/GetAllUpazilaByUser?id=$userId&userType=$userType'), headers: header);
    final allListItem = UpazilaModel.fromJson(jsonDecode(response.body));
    return allListItem;
  }
}
