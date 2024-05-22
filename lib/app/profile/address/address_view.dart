import 'dart:developer';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/user/add_address_response.dart';
import 'package:bismo/core/models/user/address_request.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/presentation/components/app_radio.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/address_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AddressView extends StatefulWidget {
  final String? title;
  const AddressView({Key? key, this.title}) : super(key: key);

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  GetAddressResponse? getAddressResponse;
  bool isLoading = true;
  List<AllAdress>? addresses = [];
  List<bool> checkedList = [];
  late Dio dio;
  String selectedAddress = '';

  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  String? dolgota;
  String? shirota;

  @override
  void dispose() {
    cityController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dio = Dio(); // Создание экземпляра Dio
    fetchAdressWithDio(); // Вызов метода для получения адресов
  }

  Future<void> fetchAdressWithDio() async {
    var headers = {'Authorization': 'Basic d2ViOjc3NTc0OTk0NTFkbA=='};
    const bUrl =
        'http://api.bismo.kz/server/hs/all/user_adress?phone_number=7777017100';

    try {
      final response = await dio.get(
        bUrl,
        options: Options(
          headers: headers,
        ),
      );

      final body = response.data;

      GetAddressResponse getAddressResponse = GetAddressResponse.fromJson(body);

      setState(() {
        addresses = getAddressResponse.allAdress;
        isLoading = false; // Остановка индикатора загрузки
        checkedList = List<bool>.filled(addresses!.length,
            false); // Заполняем список выбранных адресов false
      });

      print(getAddressResponse.success);
    } on DioException catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Адрес доставки',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addresses?.length ?? 0,
                separatorBuilder: (context, index) =>
                    const Divider(), // Добавление линии-разделителя
                itemBuilder: (context, index) {
                  final adres = addresses?[index];
                  final dolgota = adres?.dolgota;
                  final shirota = adres?.shirota;
                  final adress = adres?.adres;

                  if (adress != null && adress.isNotEmpty) {
                    return ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        hoverColor: Colors.green,
                        focusColor: Colors.green,
                        value: checkedList[index],
                        onChanged: (newValue) {
                          setState(() {
                            for (var i = 0; i < checkedList.length; i++) {
                              if (i != index) {
                                checkedList[i] = false;
                              }
                            }
                            checkedList[index] = newValue!;
                            if (newValue == true) {
                              selectedAddress =
                                  adress; // Установить выбранный адрес
                            } else {
                              selectedAddress =
                                  ''; // Сбросить выбранный адрес, если снят выбор
                            }
                          });
                        },
                      ),
                      title: Text(adress,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red),
                        onPressed: () {},
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Возвращаем виджет, представляющий ваше диалоговое окно
                    return AlertDialog(
                      title: const Text(
                        'Добавить новый адрес',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: cityController,
                            decoration:
                                const InputDecoration(labelText: 'Город *'),
                          ),
                          TextFormField(
                            controller: streetController,
                            decoration: const InputDecoration(
                                labelText: 'Улица и номер дома *'),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/location')
                                      .then((location) {
                                    // Предполагается, что `location` будет содержать `dolgota` и `shirota`
                                    if (location != null &&
                                        location is Map<String, String>) {
                                      setState(() {
                                        dolgota = location['dolgota'];
                                        shirota = location['shirota'];
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  'Указать геолокацию на карте *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () async {
                            var userProvider = context.read<UserProvider>();

                            AddressRequest addAddressRequest = AddressRequest(
                              deliveryAddress:
                                  '${cityController.text}, ${streetController.text}',
                              dolgota: dolgota ?? '',
                              shirota: shirota ?? '',
                            );

                            await addAddress(addAddressRequest,
                                userProvider.user?.phoneNumber ?? "", context);

                            Navigator.of(context)
                                .pop(); // Закрыть диалог после сохранения
                          },
                          child: const Text('Сохранить'),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: AppColors.primary,
              splashColor: AppColors.primary,
              label: const Text(
                'Добавить новый адрес',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (selectedAddress.isNotEmpty) // Отображение выбранного адреса
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Выбранный адрес: $selectedAddress',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> addAddress(AddressRequest addressRequest, String phoneNumber,
      BuildContext ctx) async {
    showLoader(ctx);

    try {
      var res = await AddressService().addAddress(addressRequest, phoneNumber);

      if (res != null) {
        if ((res.success ?? false) == false) {
          if (ctx.mounted) {
            hideLoader(ctx);
            showAlertDialog(
              context: ctx,
              barrierDismissible: true,
              title: "Ошибка",
              content: "Неудалось отменить заказ",
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(),
                  textStyle: const TextStyle(color: AppColors.primaryColor),
                  child: const Text("OK"),
                ),
              ],
            );
          }

          return false;
        }

        if (ctx.mounted) {
          hideLoader(ctx);
        }

        return true;
      }
    } on DioException catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();
      if (e.response?.statusCode == 401) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: "Неправильный адрес",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      } else {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: errorMessage,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      }

      return false;
    }

    return false;
  }
}
