//
//
// import 'package:dio/dio.dart';
// enum DioErrorType { CANCEL, CONNECT_TIMEOUT, DEFAULT,RECEIVE_TIMEOUT,RESPONSE,SEND_TIMEOUT; }
//
// class DioExceptions implements Exception {
//
//
//
//   DioExceptions.fromDioError(DioError dioError) {
//     switch (dioError.type) {
//       case DioErrorType.CANCEL:
//         message = "Request to API server was cancelled";
//         break;
//       case DioErrorType.CONNECT_TIMEOUT:
//         message = "Connection timeout with API server";
//         break;
//       case DioErrorType.DEFAULT:
//         message = "Connection to API server failed due to internet connection";
//         break;
//       case DioErrorType.RECEIVE_TIMEOUT:
//         message = "Receive timeout in connection with API server";
//         break;
//       case DioErrorType.RESPONSE:
//         message =
//             _handleError(dioError.response.statusCode, dioError.response.data);
//         break;
//       case DioErrorType.SEND_TIMEOUT:
//         message = "Send timeout in connection with API server";
//         break;
//       default:
//         message = "Something went wrong";
//         break;
//     }
//   }
//
//   String message;
//
//   String _handleError(int statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return 'Bad request';
//       case 404:
//         return error["message"];
//       case 500:
//         return 'Internal server error';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message;
// }