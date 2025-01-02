import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:task/constants/app_urls.dart';
import 'package:task/constants/camera_gallery_popup.dart';
import 'package:task/models/location_model.dart';
import 'package:task/models/user_model.dart';
import 'package:task/network/network_base_service.dart';

/// Controller for managing user data and handling business logic.
class UserController extends GetxController {
  // Observable list to hold user data, updated in real-time with UI
  RxList<UserModel> users = <UserModel>[].obs;

  // Location model to store current location data
  late LocationModel locationModel;

  // Observable flag for tracking loading state
  var isLoading = false.obs;

  // Network service instance for API calls
  final NetworkBaseService _networkService =
      NetworkBaseService(baseUrl: AppUrls.baseUrl);

  /// Called when the controller is initialized.
  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Fetch user data on initialization
  }

  /// Fetches the list of users from the API and updates the `users` list.
  Future<void> fetchUsers() async {
    isLoading.value = true; // Set loading state to true
    try {
      final data = await _networkService.get(AppUrls.usersList); // API call
      var userData = data['data']; // Extract user data from response
      users.value =
          userData.map<UserModel>((user) => UserModel.fromJson(user)).toList(); // Map JSON to user models
    } catch (e) {
      // Handle errors during fetch
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  /// Updates the avatar of a user based on the user ID and new image path.
  void updateUserAvatar(int userId, String imagePath) {
    int index = users.indexWhere((user) => user.id == userId); // Find user index
    if (index != -1) {
      users[index] = UserModel(
        email: users[index].email,
        id: users[index].id,
        avatar: imagePath, // Update avatar path
        firstName: users[index].firstName,
        lastName: users[index].lastName,
      );
    }
  }

  /// Displays a bottom sheet to choose between camera or gallery for picking an image.
  void changeImage(BuildContext context, int userId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (_) => CameraGalleryPopup(
        onTapCamera: () {
          Navigator.pop(context); // Close bottom sheet
          uploadImageToHive(ImageSource.camera, userId); // Use camera
        },
        onTapGallery: () {
          Navigator.pop(context); // Close bottom sheet
          uploadImageToHive(ImageSource.gallery, userId); // Use gallery
        },
      ),
    );
  }

  /// Handles image selection from the specified source and saves it in Hive.
  Future<void> uploadImageToHive(ImageSource source, int userId) async {
    try {
      // Open image picker for the specified source (camera/gallery)
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        String path = pickedFile.path; // Get image file path
        var box = await Hive.openBox('userImages'); // Open Hive box
        box.put(userId, path); // Save image path in Hive with user ID as key
        print("--------- Image stored in hive --------\n $path");
        updateUserAvatar(userId, path); // Update user's avatar
      }
    } catch (e) {
      // Handle errors during image picking or Hive operations
      print('Error picking image: $e');
    }
  }
}
