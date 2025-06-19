class User {
  final int? id;
  final String name;
  final int age;
  final int? roleId;

  User({this.id, required this.name, required this.age, this.roleId});

  User copyWith({int? id, String? name, int? age, int? roleId}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      roleId: roleId ?? this.roleId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'role_id': roleId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      roleId: map['role_id'],
    );
  }
}
