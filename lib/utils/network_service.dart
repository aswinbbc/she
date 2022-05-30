import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import '/utils/constant.dart';

const Map<String, dynamic> temp = {};

Future getData(String url,
    {Map<String, dynamic> params = temp, post = true}) async {
  final http.Response result;
  if (post) {
    result = await http.post(Uri.parse("${Constants.BASE_URL}$url"),
        body: params); //https://hosted_url.com/login_api
  } else {
    result = await http.get(Uri.parse("${Constants.BASE_URL}$url"));
  }
  print(result.body);
  if (result.statusCode == 200) {
    final data = result.body;
    return jsonDecode(data);
  }
}

Future<http.StreamedResponse> Upload(
    File imageFile, String url, Map<String, String> params) async {
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse("${Constants.BASE_URL}$url");

  var request = http.MultipartRequest(
    "POST",
    uri,
  );
  var multipartFile = http.MultipartFile('fileToUpload', stream, length,
      filename: basename(imageFile.path));
  //contentType: new MediaType('image', 'png'));

  request.files.add(multipartFile);
  request.fields.addAll(params);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
  return response;
}
