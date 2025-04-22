import 'package:equatable/equatable.dart';

enum SoapResponseType {
  success,
  error,
}

class SoapResponseModel extends Equatable {
  final SoapResponseType responseType;
  final dynamic response;

  const SoapResponseModel({
    required this.response,
    required this.responseType,
  });

  @override
  List<Object?> get props => [response, responseType];
}
