part of 'display_list_bloc.dart';

enum DisplayListStatus {
   initial, 
   success, 
   loading, 
   loaded, 
   error ,
   deletelist
   }

class DisplayListState extends Equatable {
  final DisplayListStatus? displayListStatus;
  final List<ListModel>? listpostmodel;

   DisplayListState({
    this.displayListStatus = DisplayListStatus.initial,
    this.listpostmodel = const[]
    
  });

  @override
  List<Object> get props => [
    displayListStatus!,
     listpostmodel!];

  DisplayListState copyWith({DisplayListStatus? displayListStatus,
  List<ListModel>? listpostmodel,}) {
    return DisplayListState(
        displayListStatus: displayListStatus ?? this.displayListStatus,
        listpostmodel: listpostmodel?? this.listpostmodel
        );
        
  }
}
