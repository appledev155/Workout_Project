class MapCoordinateModel {
  final int? id;
  final String? name;
  final String? duration;
  final String? date;
  final String? distance;
  final List<double>? latitude;
  final List<double>? longitude;

  MapCoordinateModel(
      {this.id,
      this.name,
      this.duration,
      this.date,
      this.distance,
      this.latitude,
      this.longitude});
  @override
  String toString() {
    return 'LocationData{id: $id, Date: $date, startLatlng: $latitude, endLatlng: $longitude, distance: $distance, duration:$duration}';
  }
}
