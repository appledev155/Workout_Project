part of 'display_list_bloc.dart';

class DisplayListEvent extends Equatable {
  const DisplayListEvent();

  @override
  List<Object> get props => [];
}

class FetchIsarData extends DisplayListEvent {
  const FetchIsarData();
}

class DeleteListpage extends DisplayListEvent{
 final String? id;

  const DeleteListpage({this.id});
}