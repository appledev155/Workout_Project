part of 'add_form_bloc.dart';

class AddFormEvent extends Equatable {
  const AddFormEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberChanged extends AddFormEvent {
  final String? phoneNumber;
  const PhoneNumberChanged({this.phoneNumber});
}

class Submit extends AddFormEvent {
  const Submit();
}

class ResetState extends AddFormEvent {
  const ResetState();
}
