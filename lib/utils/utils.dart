import 'package:background_sms/background_sms.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as p;

Stream<LocationData> getMyLocation() async* {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  location.enableBackgroundMode(enable: true);
  _locationData = await location.getLocation();
  location.onLocationChanged.listen((LocationData currentLocation) sync* {
    yield currentLocation;
  });
  print('${_locationData.latitude},${_locationData.longitude}');
  yield _locationData;
}

sendSms(String locationData) async {
  if (await p.Permission.sms.status.isDenied) {
    print("premission denied");
    if (await p.Permission.sms.request().isDenied) {
      print("denied0");
      return;
    }
  }

  SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: "9995395865", message: "Message " + locationData);
  if (result == SmsStatus.sent) {
    print("Sent");
  } else {
    print("Failed");
  }
}
