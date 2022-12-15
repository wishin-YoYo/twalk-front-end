import 'package:twalk_app/logics/rest_api_caller.dart';

class WishinApiCaller {
  static getMemberAroundMe(int id) {
    return RestApiCaller.getMethod(["member-around", id.toString()]);
  }

  static getJakingRequestOfMe(int id) {
    return RestApiCaller.getMethod(["jalking-rec", id.toString()]);
  }

  static getPvpRequestOfMe(int id) {
    return RestApiCaller.getMethod(["pvp-rec", id.toString()]);
  }

  static postJalkingRequest(Map<String, String> parameters) {
    return RestApiCaller.postMethod(["jalking"], parameters);
  }

  static postPvpRequest(Map<String, String> parameters) {
    return RestApiCaller.postMethod(["pvp"], parameters);
  }

  static getJalking(int id) {
    return RestApiCaller.getMethod(["jalking", id.toString()]);
  }

  static getPvp(int id) {
    return RestApiCaller.getMethod(["pvp", id.toString()]);
  }

  static getMemberById(int id) {
    return RestApiCaller.getMethod(["member", id.toString()]);
  }

  static getJalkingHistory(int id) {
    return RestApiCaller.getMethod(["jalking", "user", id.toString()]);
  }

  static getPvpHistory(int id) {
    return RestApiCaller.getMethod(["pvp", "user", id.toString()]);
  }

  static putMemberLocation(Map<String, String> parameters) {
    return RestApiCaller.putMethod(["member-location"], parameters);
  }
}
