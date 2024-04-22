part of 'download_image_bloc.dart';

enum DownloadImageStatus { initial, loading, success, failed }

class DownloadImageState extends Equatable {
  final DownloadImageStatus? status;
  final List downloadedImageArray;
  final int currentImageCount;

  const DownloadImageState({
    this.status = DownloadImageStatus.initial,
    this.downloadedImageArray = const [],
    this.currentImageCount = 1,
  });

  DownloadImageState copyWith(
      {DownloadImageStatus? status,
      List? downloadedImageArray,
      int? currentImageCount}) {
    return DownloadImageState(
        status: status ?? this.status,
        downloadedImageArray: downloadedImageArray ?? this.downloadedImageArray,
        currentImageCount: currentImageCount ?? this.currentImageCount);
  }

  @override
  List<Object> get props => [status!, downloadedImageArray, currentImageCount];
}
