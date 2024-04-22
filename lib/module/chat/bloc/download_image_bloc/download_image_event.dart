part of 'download_image_bloc.dart';

abstract class DownloadImageEvent extends Equatable {
  const DownloadImageEvent();

  @override
  List<Object> get props => [];
}

class DownloadImage extends DownloadImageEvent {
  final List imageArray;
  const DownloadImage({required this.imageArray});
}

class ResetImageSlider extends DownloadImageEvent {}

class ShowCurrentImageCount extends DownloadImageEvent {
  final int currentImageCount;
  const ShowCurrentImageCount({required this.currentImageCount});
}
