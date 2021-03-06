import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tape/api/request/ResultData.dart';
import 'package:tape/utils/storage.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    var res = response.data;
    if (res["code"] != 1) {
      Fluttertoast.showToast(msg: res["message"]);
      return ResultData(res["data"], false, res["code"], res["message"]);
    } else {
      return ResultData(res["data"], true, res["code"], res["message"]);
    }
  }

  @override
  Future onError(DioError err) {
    Fluttertoast.showToast(msg: err.message);
  }
}

class RequestInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    var token = await Storage.getString("token");
    var header = {"Authorization": token};
    options.headers.addAll(header);
    return super.onRequest(options);
  }
}
