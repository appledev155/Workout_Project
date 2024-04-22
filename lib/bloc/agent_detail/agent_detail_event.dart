part of 'agent_detail_bloc.dart';

@immutable
abstract class AgentDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AgentDetailFetched extends AgentDetailEvent {
  final int? userId;
  AgentDetailFetched({this.userId});
}

class ResetAgentDetailState extends AgentDetailEvent {}
