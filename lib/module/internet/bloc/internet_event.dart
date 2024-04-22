part of 'internet_bloc.dart';

abstract class InternetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InternetConnected extends InternetEvent {
  final ConnectionType connectionType;
  InternetConnected({required this.connectionType});
}

class InternetLoading extends InternetEvent {
  InternetLoading();
}

class InternetDisconnected extends InternetEvent {
  InternetDisconnected();
}

class InternetSpeedChanged extends InternetEvent {}

class MonitorSlowInternetSpeed extends InternetEvent {}

class BootApplication extends InternetEvent {
  BootApplication();
}
