class User {
  final int? id;
  final String name;
  final int age;
  final String role;

  User({
    this.id,
    required this.name,
    required this.age,
    this.role = 'Viewer',
  });

  User copyWith({int? id, String? name, int? age, String? role}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        role: role ?? this.role,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'role': role,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        name: map['name'],
        age: map['age'],
        role: map['role'] ?? 'Viewer',
      );
}
