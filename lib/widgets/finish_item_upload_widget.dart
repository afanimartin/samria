import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moostamil/blocs/upload/upload_event.dart';
import 'package:moostamil/screens/user_profile_screen.dart';

import '../blocs/upload/upload_bloc.dart';
import '../blocs/upload/upload_state.dart';
import '../models/item/item.dart';
import '../utils/category.dart';
import '../utils/condition.dart';
import '../utils/constants.dart';
import 'category_editing_widget.dart';
import 'condition_editing_widget.dart';
import 'description_editing_widget.dart';
import 'phone_number_widget.dart';
import 'price_editing_widget.dart';
import 'submit_button_widget.dart';
import 'title_editing_widget.dart';

///
class FinishItemUploadWidget extends StatefulWidget {
  ///
  const FinishItemUploadWidget({Key key}) : super(key: key);

  @override
  _FinishItemUploadWidgetState createState() => _FinishItemUploadWidgetState();
}

class _FinishItemUploadWidgetState extends State<FinishItemUploadWidget> {
  final _titleContentController = TextEditingController();
  final _descriptionContentController = TextEditingController();
  final _priceContentController = TextEditingController();
  final _phoneController = TextEditingController();

  String _conditionValue = conditionList[0];
  String _categoryValue = categoryList[0];

  bool _isFormValid;

  @override
  Widget build(BuildContext context) => BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          _isFormValid = _titleContentController.text.isNotEmpty &&
              _descriptionContentController.text.isNotEmpty &&
              _priceContentController.text.isNotEmpty &&
              _phoneController.text.isNotEmpty &&
              _phoneController.text.length == 10;

          final _item = Item(
              title: _titleContentController.text,
              description: _descriptionContentController.text,
              condition: _conditionValue,
              price: _priceContentController.text,
              category: _categoryValue,
              sellerPhoneNumber: _phoneController.text);

          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              title: Text(
                'Finish item upload',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    letterSpacing: 1),
              ),
              iconTheme: Theme.of(context).iconTheme,
            ),
            body: Padding(
              padding: const EdgeInsets.all(Constants.eight),
              child: Align(
                alignment: const Alignment(0, -1),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TitleEditingWidget(
                        controller: _titleContentController,
                        onChanged: (String title) =>
                            context.read<UploadBloc>().titleChanged(title),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark)),
                          labelText: 'title',
                          helperText: '',
                        ),
                      ),
                      const SizedBox(
                        height: Constants.six,
                      ),
                      DescriptionEditingWidget(
                        controller: _descriptionContentController,
                        maxLength: Constants.fiveHundred,
                        onChanged: (String description) => context
                            .read<UploadBloc>()
                            .descriptionChanged(description),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark)),
                          labelText: 'description',
                          helperText: '',
                        ),
                      ),
                      const SizedBox(
                        height: Constants.six,
                      ),
                      PriceEditingWidget(
                        controller: _priceContentController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark)),
                            labelText: 'price'),
                      ),
                      const SizedBox(
                        height: Constants.six,
                      ),
                      PhoneNumberEditingWidget(
                        controller: _phoneController,
                        onChanged: (String phone) =>
                            context.read<UploadBloc>().phoneChanged(phone),
                      ),
                      const SizedBox(
                        height: Constants.six,
                      ),
                      CategoryEditingWidget(
                        categoryValue: _categoryValue,
                        onChanged: (String value) {
                          setState(() {
                            _categoryValue = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: Constants.six,
                      ),
                      ConditonEditingWidget(
                          conditionValue: _conditionValue,
                          onChanged: (String value) {
                            setState(() {
                              _conditionValue = value;
                            });
                          }),
                      const SizedBox(
                        height: Constants.six,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Visibility(
                visible: _isFormValid,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    context.read<UploadBloc>().add(UploadItem(item: _item));

                    Navigator.of(context).pushAndRemoveUntil<void>(
                        UserProfileScreen.route, (route) => false);
                  },
                  child: const Icon(
                    Icons.check,
                    size: Constants.thirty,
                  ),
                )),
          );
        },
      );

  @override
  void dispose() {
    super.dispose();

    _titleContentController.clear();
    _descriptionContentController.clear();
    _priceContentController.clear();
    _phoneController.clear();
  }
}
