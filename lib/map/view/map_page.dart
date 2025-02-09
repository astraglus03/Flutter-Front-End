import 'package:dimple/common/const/colors.dart';
import 'package:dimple/map/models/walk_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/dog.dart';
import '../models/position_service.dart';
import '../models/walk_record.dart';
import '../providers/selected_dogs_provider.dart';
import '../repositories/walk_record_repository.dart';
import '../viewmodels/polyline_update.dart';
import '../viewmodels/position_provider.dart';
import '../viewmodels/polyline_provider.dart';
import '../viewmodels/walk_record_provider.dart';
import '../viewmodels/walkstate_provider.dart';
import '../view/walk_start_dialog.dart';
import '../view/toilet_record_dialog.dart';
import '../view/walk_result_page.dart';

class MapScreen extends ConsumerStatefulWidget {
  static String get routeName => 'map';
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  bool _isFirstLocationUpdate = true;
  Set<Marker> _markers = {};
  BitmapDescriptor _customMarker = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _checkLocationPermission();
  }

  Future<void> _loadCustomMarker() async {
    try {
      _customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)),
        'assets/img/location_marker.png',
      );
      setState(() {});
    } catch (e) {
      print('마커 로드 실패: $e');
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      await requestLocationPermission();
      if (mounted) {
        _showWalkStartDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showWalkStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WalkStartDialog(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _animateToLocation(LatLng location) async {
    final controller = _mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 17.0,
          tilt: 0,
        ),
      ),
    );
  }

  void _moveToCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);
    _animateToLocation(latLng);
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(positionProvider).value;
    final walkState = ref.watch(walkStateProvider);
    final polylineCoordinates = ref.watch(polylineCoordinatesProvider);
    final selectedDogs = ref.watch(selectedDogsProvider);

    if (currentPosition != null) {
      _markers = {
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
          rotation: currentPosition.heading,
          icon: _customMarker,
          flat: true,
        ),
      };
    }

    ref.listen(positionProvider, (previous, next) {
      if (next.value != null && walkState == WalkState.riding) {
        final location = LatLng(
          next.value!.latitude,
          next.value!.longitude,
        );
        
        if (_isFirstLocationUpdate) {
          _animateToLocation(location);
          _isFirstLocationUpdate = false;
        } else {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(location),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('산책')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.5665, 126.9780),
              zoom: 17.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            //markers: _markers,
            polylines: {
              Polyline(
                polylineId: PolylineId('walkPath'),
                points: polylineCoordinates,
                color: Colors.blue,
                width: 5,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                jointType: JointType.round,
              ),
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _moveToCurrentLocation,
                    child: Container(
                      child: Image.asset(
                        "assets/img/gps.png",
                        width: 47.58,
                        height: 47.58,
                      ),
                    ),
                  ),
                ],
              ),
              if (walkState == WalkState.paused)
                Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD747),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(160, 50),
                      ),
                      onPressed: () {
                        ref.read(walkStateProvider.notifier).state = WalkState.finished;
                        ref.read(positionControllerProvider.notifier).stopListening();
                        
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WalkResultPage(
                              walkRecord: ref.read(walkRecordProvider)!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "산책종료",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              _buildWalkControls(),
            ],
          ),
        ],
      ),
      floatingActionButton: walkState == WalkState.riding ? 
        Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: _buildToiletRecordButton(selectedDogs),
        ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildWalkControls() {
    final walkState = ref.watch(walkStateProvider);
    final walkRecord = ref.watch(walkRecordProvider);
    final selectedDogs = ref.watch(selectedDogsProvider);
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            "이동거리",
            "${walkRecord?.distance.toStringAsFixed(1) ?? '0.0'}",
            "km",
          ),
          GestureDetector(
            onTap: () {
              if (walkState == WalkState.before) {
                ref.read(walkRecordProvider.notifier).startWalk(selectedDogs);
                ref.read(walkStateProvider.notifier).state = WalkState.riding;
                ref.read(positionControllerProvider.notifier).startListening();
              } else if (walkState == WalkState.riding) {
                ref.read(walkStateProvider.notifier).state = WalkState.paused;
                ref.read(positionControllerProvider.notifier).stopListening();
              } else if (walkState == WalkState.paused) {
                ref.read(walkStateProvider.notifier).state = WalkState.riding;
                ref.read(positionControllerProvider.notifier).startListening();
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(
                walkState == WalkState.riding ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: PRIMARY_COLOR,
              ),
            ),
          ),
          _buildInfoItem(
            "산책시간",
            "${walkRecord?.duration.inMinutes ?? 0}",
            "분",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 2),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToiletRecordButton(List<Dog> selectedDogs) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ToiletRecordDialog(
              walkingDogs: selectedDogs,
              onRecord: (dogs, type) {
                for (final dog in dogs) {
                  ref.read(walkRecordProvider.notifier).addToiletRecord(
                    ToiletRecord(
                      dogId: dog.id,
                      time: DateTime.now(),
                      location: LatLng(
                        _markers.first.position.latitude,
                        _markers.first.position.longitude,
                      ),
                      type: type,
                    ),
                  );
                }
              },
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Image.asset('assets/img/poop_icon.png', width: 40, height: 40),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
