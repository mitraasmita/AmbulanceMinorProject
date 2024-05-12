import 'package:flutter/cupertino.dart';
import 'package:third_project/models/address_model.dart';

class AppInfo extends ChangeNotifier
{
  AddressModel? pickUpLocation;//instance 1
  AddressModel? dropOffLocation;//instance 2

  void updatePickUpLocation(AddressModel pickUpModel)
  {
    pickUpLocation = pickUpModel;
    notifyListeners();
  }

  void updateDropOffLocation(AddressModel dropOffModel)
  {
    dropOffLocation = dropOffModel;
    notifyListeners();
  }
}