import 'package:equatable/equatable.dart';

/// Public config entity containing base URL and decoded password.
class PublicConfig extends Equatable {
  const PublicConfig({required this.baseUri, required this.password});

  final String baseUri;
  final String password;

  @override
  List<Object?> get props => [baseUri];
}
