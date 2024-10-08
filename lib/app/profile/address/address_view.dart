import 'dart:developer';
import 'package:bismo/core/app_cache.dart';
import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/location/screens/current_location.dart';
import 'package:bismo/core/models/user/address_request.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/address_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool showError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    cityController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAdressWithDio();
    });
  }

  Future<void> fetchAdressWithDio() async {
    var userProvider = context.read<UserProvider>();
    var phoneNumber = userProvider.user?.phoneNumber ?? "";

    if (phoneNumber.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRegistrationDialog(context);
      });
      return;
    }

    try {
      final response = await AddressService().getAddresses(phoneNumber);

      getAddressResponse = response;
      setState(() {
        addresses = getAddressResponse?.allAdress;
        isLoading = false;
        checkedList = List<bool>.filled(addresses!.length, false);
        checkedList = List<bool>.generate(addresses!.length, (index) {
          return addresses?[index].adres ==
              userProvider.userAddress?.deliveryAddress;
        });
      });
    } on DioException catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Регистрация требуется'),
          content: const Text(
              'У вас нет регистрации. Пожалуйста, зарегистрируйтесь.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
                Navigator.of(context).pop(); // Вернуться назад
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
                Nav.toNamed(
                    context, "/register"); // Перейти на страницу регистрации
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Адрес доставки',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final adres = addresses?[index];
                  final dolgota = adres?.dolgota;
                  final shirota = adres?.shirota;
                  final adress = adres?.adres;

                  if (adress != null && adress.isNotEmpty) {
                    return ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
                        activeColor: AppColors.primaryColor,
                        hoverColor: AppColors.primaryColor,
                        focusColor: AppColors.primaryColor,
                        value: checkedList[index],
                        onChanged: (newValue) {
                          var userProvider = context.read<UserProvider>();
                          setState(() {
                            for (var i = 0; i < checkedList.length; i++) {
                              if (i != index) {
                                checkedList[i] = false;
                              }
                            }
                            checkedList[index] = newValue!;
                            if (newValue == true) {
                              selectedAddress = adress;

                              var pickedAddress = AddressRequest(
                                  deliveryAddress: adress,
                                  dolgota: dolgota,
                                  shirota: shirota);

                              userProvider.setUserAddress(pickedAddress);

                              AppCache().setUserAddress(pickedAddress);
                            } else {
                              selectedAddress = '';
                            }
                          });
                        },
                      ),
                      title: Text(adress,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red),
                        onPressed: () async {
                          var userProvider = context.read<UserProvider>();

                          bool? confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Подтверждение удаления'),
                                content: const Text(
                                    'Вы уверены, что хотите удалить этот адрес?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Удалить'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            await deleteAddress(adress,
                                userProvider.user?.phoneNumber ?? "", context);
                          }
                        },
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
                  builder: (
                    BuildContext context,
                  ) {
                    return StatefulBuilder(builder: (context, setDialogState) {
                      return AlertDialog(
                        title: const Text(
                          'Добавить новый адрес',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: cityController,
                                decoration:
                                    const InputDecoration(labelText: 'Город *'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Это поле обязательно для заполнения';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: streetController,
                                decoration: const InputDecoration(
                                    labelText: 'Улица и номер дома *'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Это поле обязательно для заполнения';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.red,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var location = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return const CurrentLocationScreen();
                                      }));

                                      if (location != null) {
                                        setDialogState(() {
                                          dolgota =
                                              location['longitude'].toString();
                                          shirota =
                                              location['latitude'].toString();
                                          showError = false;
                                        });
                                      }
                                    },
                                    child: Text(
                                      dolgota == null
                                          ? 'Указать геолокацию на карте *'
                                          : "Изменить точку",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              if (showError) // Показываем текст ошибки, если геолокация не выбрана
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    'Геолокация обязательна',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showError = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  dolgota != null &&
                                  shirota != null) {
                                var userProvider = context.read<UserProvider>();

                                AddressRequest addAddressRequest =
                                    AddressRequest(
                                  deliveryAddress:
                                      '${cityController.text}, ${streetController.text}',
                                  dolgota: dolgota ?? '',
                                  shirota: shirota ?? '',
                                );

                                await addAddress(
                                    addAddressRequest,
                                    userProvider.user?.phoneNumber ?? "",
                                    context);

                                setDialogState(() {
                                  cityController.clear();
                                  streetController.clear();
                                  dolgota = null;
                                  shirota = null;
                                });

                                Navigator.of(context).pop();
                              } else if (dolgota == null || shirota == null) {
                                setDialogState(() {
                                  showError = true;
                                });
                              }
                            },
                            child: const Text('Сохранить'),
                          ),
                        ],
                      );
                    });
                  },
                );
              },
              backgroundColor: AppColors.primaryColor,
              splashColor: AppColors.primaryColor,
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
              content: "Не удалось отменить заказ",
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
          setState(() {
            fetchAdressWithDio();
          });
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

  Future<bool> deleteAddress(
      String deliveryAddress, String phoneNumber, BuildContext ctx) async {
    showLoader(ctx);
    var userProvider = ctx.read<UserProvider>();

    try {
      var res =
          await AddressService().deleteAddress(phoneNumber, deliveryAddress);

      if (res != null) {
        if ((res.success ?? false) == false) {
          if (ctx.mounted) {
            hideLoader(ctx);
            showAlertDialog(
              context: ctx,
              barrierDismissible: true,
              title: "Ошибка",
              content: "Не удалось удалить адрес",
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

        if (userProvider.userAddress?.deliveryAddress == deliveryAddress) {
          userProvider.setUserAddress(null);

          AppCache().setUserAddress(null);
        }

        fetchAdressWithDio();

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
