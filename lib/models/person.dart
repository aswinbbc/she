class Person {
  String? name;
  String? mobile;
  Person({this.name, this.mobile});

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['name'] = name!;
    data['mobile'] = mobile!;
    return data;
  }
}
