import 'dart:convert';

Users userFromJson(String str) {
  final jsonData = jsonDecode(str);
  return Users.fromMap(jsonData);
}

String userToJson(Users data) {
  final dyn = data.toMap();
  return jsonEncode(dyn);
}

class Users {
  int id;
  String full_name;
  String profile_pic;

  Users({this.id, this.full_name, this.profile_pic});
  factory Users.fromMap(Map<String, dynamic> data) => Users(
      id: data['id'],
      full_name: data['full_name'],
      profile_pic: data['profile_pic']);
  Map<String, dynamic> toMap() =>
      {'id': id, 'full_name': full_name, 'profile_pic': profile_pic};
}
