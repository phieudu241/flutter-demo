class User {
  String bitmarkAccountNumber;

  User({this.bitmarkAccountNumber});

  factory User.fromBitmarkAccountNumber(String bitmarkAccountNumber) => new User(bitmarkAccountNumber: bitmarkAccountNumber);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(bitmarkAccountNumber: json['bitmarkAccountNumber'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
    'bitmarkAccountNumber': instance.bitmarkAccountNumber
};