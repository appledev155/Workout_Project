part of 'add_form_bloc.dart';

enum Status { initial, success, failure }

class AddFormState extends Equatable {
  final Status? status;
  final String? phoneNumber;
  final String? message;
  const AddFormState(
      {this.status = Status.initial, this.phoneNumber = '', this.message = ''});

  @override
  List<Object> get props => [status!, phoneNumber!, message!];

  AddFormState copyWith(
      {Status? status, String? phoneNumber, String? message}) {
    return AddFormState(
        status: status ?? this.status,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        message: message ?? this.message);
  }
}
