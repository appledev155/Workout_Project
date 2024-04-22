part of 'agent_detail_bloc.dart';

enum AgentDetailStatus { initial, success, failure }

@immutable
class AgentDetailState extends Equatable {
  final AgentDetailStatus? agentDetailStatus;
  final AgentDetail? agentDetail;

  const AgentDetailState(
      {this.agentDetailStatus = AgentDetailStatus.initial,
      this.agentDetail = const AgentDetail()});

  @override
  List<Object> get props => [agentDetailStatus!, agentDetail!];

  AgentDetailState copyWith(
      {AgentDetailStatus? agentDetailStatus, AgentDetail? agentDetail}) {
    return AgentDetailState(
        agentDetailStatus: agentDetailStatus ?? this.agentDetailStatus,
        agentDetail: agentDetail ?? this.agentDetail);
  }
}
