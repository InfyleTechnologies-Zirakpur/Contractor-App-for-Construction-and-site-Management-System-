import 'package:equatable/equatable.dart';

/// Equatable lets Bloc/Cubit compare two states with `==` by their
/// properties, not their memory reference. Without this, emitting a "new"
/// AuthState with the same data would still trigger a rebuild every time.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.siteName,
  });

  final String id;
  final String name;
  final String phone;
  final String role; // e.g. Mason, Electrician, Site Supervisor
  final String siteName;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        role: json['role'] as String,
        siteName: json['siteName'] as String,
      );

  @override
  List<Object?> get props => [id, name, phone, role, siteName];
}
