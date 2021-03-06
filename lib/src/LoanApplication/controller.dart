import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:don/src/LoanApplication/loaan_success.dart';
import 'package:don/src/helpers/toasts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class RequestLoan extends GetxController {
  TextEditingController amountCont = TextEditingController();
  var isLoading = false.obs;
  var isLoadingApp = false.obs;
  File? file;
  var box;
  var token;
  Future openFile({required String url, String? fileName}) async {
    isLoading(true);
    final file = await downLoadFile(url, fileName!);
    if (file == null) return;
    print(file.path);
    OpenFile.open(file.path);
    isLoading(false);
    update();
  }
  @override
  void onInit()async{
    readToken();
    box = await Hive.openBox('userInfo');
    super.onInit();
  }
readToken() async {
  box = await Hive.openBox('userInfo');
  printSuccess("read token from box");
 token = box.get('token')!;
 printSuccess(token);
 update();
 return token;
}
  Future<File?> downLoadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await dio.Dio().get(url,
          options: dio.Options(
            responseType: dio.ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

//upload file
  Future getFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    file = File(result.files.single.path!);
    update();
  }

  void uploadFile(filePath,String token) async {
    await getFile();
String fileName = basename(filePath.path);
    // string to uri
    var uri = Uri.parse("https://api.luchian.co.ke/customer/request-loan/");

    // create multipart request
    var request =  http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    var headers = {'Authorization': 'Token $token'};
     request.fields.addAll({'amount': amountCont.text}); 
request.headers.addAll(headers);
    // multipart that takes file.. here this "idDocumentOne_1" is a key of the API request
   var  multipartFile = (await http.MultipartFile.fromPath(
          "filled_form",
          filePath.path,
    ));

    // add file to multipart
    request.files.addAll({multipartFile});

    // send request to upload file
    await request.send().then((response) async {
   
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        showToastSuccess(value);
      });
     if (response.statusCode == 200) {
      printSuccess(await response.stream.bytesToString());
      return true;
    } else {
      printError(response.reasonPhrase);
      return false;
    }
    }).catchError((e) {
      printError(e);
    });
    update();
  }




  void applyLoan(filePath,String token) async {
    isLoadingApp.value=true;
String fileName = basename(filePath.path);
    // string to uri
    var uri = Uri.parse("https://api.luchian.co.ke/customer/request-loan/");

    // create multipart request
    var request =  http.MultipartRequest("POST", uri);
    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    var headers = {'Authorization': 'Token $token'};
     request.fields.addAll({'amount': amountCont.text}); 
request.headers.addAll(headers);
    // multipart that takes file.. here this "idDocumentOne_1" is a key of the API request
   var  multipartFile = (await http.MultipartFile.fromPath(
          "filled_form",
          filePath.path,
    ));

    // add file to multipart
    request.files.addAll({multipartFile});

    // send request to upload file
    await request.send().then((response) async {
   
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        final body = json.decode(value);
        isLoadingApp.value=false;
      Get.to(()=> const LoanSuccess());
        showToastSuccess(body['details']);
      });
     if (response.statusCode == 200) {
      printSuccess(await response.stream.bytesToString());
      return true;
    } else {
      printError(response.reasonPhrase);
      return false;
    }
    }).catchError((e) {
      printError(e);
    });
    update();
  }
  // void uploadFile(filePath,String token) async {
  //   await getFile();
  //   String fileName = basename(filePath.path);
  //   printSuccess(fileName);
  //   try {
  //     var requestBody = {
  //       'amount': 10000,
  //       'filled_form': await dio.MultipartFile.fromFile(filePath.path,
  //           filename: fileName),
  //     };
  //     dio.Response response = await dio.Dio().post(
  //         "https://api.luchian.co.ke/customer/request-loan/",
  //         data: requestBody,
  //         options: dio.Options(
  //           headers: {
  //             'Content-Type': 'multipart/form-data',
  //             'Accept': 'application/json',
  //             'Authorization': 'Token $token',
  //           }
  //         )
  //         );
  //         if(response.statusCode == 200){

  //     printSuccess("File upload response: $response");
  //     showToastSuccess("file uploaded");
  //         }
  //   } catch (e) {
  //     print("Exception occurered $e");
  //   }
  //   update();
  // }
}
