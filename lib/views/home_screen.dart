import 'dart:io'; // For File operations.
import 'package:flutter/material.dart'; // Core UI framework for Flutter.
import 'package:geocoding/geocoding.dart'; // For converting coordinates into addresses.
import 'package:get/get.dart'; // State management package.
import 'package:geolocator/geolocator.dart'; // For fetching the device's location.
import 'package:task/controllers/user_controllers.dart'; // User-defined controller for managing user data.
import 'package:task/models/location_model.dart'; // User-defined model to represent location data.

class HomeScreen extends StatelessWidget {
  // Initialize the UserController using GetX for state management.
  final UserController userController = Get.put(UserController());

  // Method to fetch the current position and convert it into a LocationModel.
  Future<LocationModel> getCurrentPosition() async {
    // Request location permission from the user.
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission.
      throw 'Location permission denied';
    }

    // Fetch the current position of the device.
    Position position = await Geolocator.getCurrentPosition();

    // Convert the coordinates into human-readable address details.
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0]; // Use the first Placemark from the result.

    // Log the Placemark details (optional debugging step).
    print(place.toJson().toString());

    // Return the LocationModel with latitude, longitude, and formatted address.
    return LocationModel(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      address: "${place.thoroughfare}, ${place.subLocality!}, ${place.locality}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // AppBar background color.
          title: const Text('Home'), // Title displayed in the AppBar.
          centerTitle: true, // Centers the title in the AppBar.
          elevation: 5, // Adds a shadow under the AppBar.
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Padding around the content.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start.
              children: [
                // FutureBuilder to handle asynchronous location fetching.
                FutureBuilder<LocationModel>(
                  future: getCurrentPosition(),
                  builder: (context, snapshot) {
                    // Show a loading indicator while fetching location.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } 
                    // Handle errors in location fetching.
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error fetching location: ${snapshot.error}', // Display error message.
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } 
                    // Display the fetched location data.
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the section title with an icon.
                            const Row(
                              children: [
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.location_on,
                                  size: 32,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Display latitude, longitude, and address.
                            Text(
                              'Latitude: ${snapshot.data?.latitude}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Longitude: ${snapshot.data?.longitude}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Address: ${snapshot.data?.address}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Display the list of users managed by the UserController.
                Obx(() {
                  // Show a loading indicator if user data is being loaded.
                  if (userController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Display a message if no users are found.
                  if (userController.users.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  // Display a list of users.
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(), // Separator between list items.
                    shrinkWrap: true, // Prevents unnecessary scroll.
                    physics: const NeverScrollableScrollPhysics(), // Disables scrolling for the list.
                    itemCount: userController.users.length, // Number of users.
                    itemBuilder: (context, index) {
                      var user = userController.users[index];
                      return ListTile(
                        // Display the user's avatar.
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: user.avatar.startsWith('http') // Check if avatar is a URL or local file.
                              ? NetworkImage(user.avatar)
                              : FileImage(File(user.avatar)) as ImageProvider,
                        ),
                        // Display the user's name.
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email), // Display the user's email.,
                        // Edit button for changing the user's image.
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            userController.changeImage(context, user.id);
                          },
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
