import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:give_now/blocs/authentication/authentication_bloc.dart';
import 'package:give_now/blocs/image/image_bloc.dart';
import 'package:give_now/blocs/image/image_state.dart';
import 'package:give_now/blocs/tab/tab_bloc.dart';
import 'package:give_now/blocs/tab/tab_event.dart';
import 'package:give_now/models/app_tab/app_tab.dart';
import 'package:give_now/screens/log_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:give_now/widgets/tab_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());

  @override
  Widget build(BuildContext context) => BlocBuilder<TabBloc, AppTab>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Givenow',
              style: TextStyle(
                  color: Colors.black, fontSize: 28, letterSpacing: 1.2),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    context.read<AuthenticationBloc>().add(LogOut());
                    Navigator.of(context).pushAndRemoveUntil(
                        LogInScreen.route(), (route) => false);
                  })
            ],
          ),
          body: _renderImages(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _uploadImageToStorage(context),
            child: Icon(
              Icons.add,
            ),
            backgroundColor: Colors.brown[600],
          ),
          bottomNavigationBar: TabSelector(
              activeTab: state,
              onTabSelected: (tab) =>
                  context.read<TabBloc>().add(UpdateTab(tab: tab))),
        ),
      );

  void _uploadImageToStorage(BuildContext context) async {
    final _imagePicker = ImagePicker();
    PickedFile pickedImage;

    await Permission.photos.request();

    final permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);

      final file = File(pickedImage.path);

      if (file != null) {
        context.read<ImageBloc>().uploadImage(file);
      }
    }
  }

  _renderImages() => BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImagesUpdated) {
            return state.images.isEmpty
                ? Center(child: Text('No images to load'))
                : ListView.builder(
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      final image = state.images[index];

                      return Container(
                          child: Card(
                        elevation: 4,
                        child: CachedNetworkImage(
                          imageUrl: image.mainImageUrl,
                        ),
                      ));
                    });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
}
