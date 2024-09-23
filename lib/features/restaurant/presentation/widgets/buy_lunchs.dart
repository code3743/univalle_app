import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/student_restarant_provider.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/confirm_luch_order.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/lunch_purchase_link.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/ticket_item.dart';

class BuyLunchs extends StatefulWidget {
  const BuyLunchs({
    super.key,
    required this.minLunches,
    required this.maxLunches,
    required this.lunchPrice,
  });

  final int minLunches;
  final int maxLunches;
  final double lunchPrice;

  @override
  State<BuyLunchs> createState() => _BuyLunchsState();
}

class _BuyLunchsState extends State<BuyLunchs> {
  late int _lunches;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _lunches = widget.minLunches;
    _controller.text = _lunches.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    final int lunches = int.tryParse(value) ?? 0;
    if (lunches < widget.minLunches) {
      _controller.text = widget.minLunches.toString();
      _lunches = widget.minLunches;
      return;
    }
    if (lunches > widget.maxLunches) {
      _controller.text = widget.maxLunches.toString();
      _lunches = widget.maxLunches;
      return;
    }
    _lunches = lunches;
    return;
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un valor';
    }
    if (int.tryParse(value) == null) {
      return 'Ingrese un valor numérico';
    }
    if (int.parse(value) < widget.minLunches) {
      return 'Lo mínimo es ${widget.minLunches}';
    }
    if (int.parse(value) > widget.maxLunches) {
      return 'Lo máximo es ${widget.maxLunches}';
    }
    return null;
  }

  void addLaunch() {
    if (_lunches == widget.maxLunches) return;
    _controller.text = (++_lunches).toString();
  }

  void removeLaunch() {
    if (_lunches == widget.minLunches) return;
    _controller.text = (--_lunches).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('Comprar almuerzos',
              style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomTextFormField(
              suffixIcon:
                  IconButton(icon: const Icon(Icons.add), onPressed: addLaunch),
              prefixIcon: IconButton(
                  icon: const Icon(Icons.remove), onPressed: removeLaunch),
              onChanged: onChanged,
              validator: validator,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: _controller,
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, _) {
                return TicketItem(
                    title: 'Total a pagar',
                    value: '${_lunches * widget.lunchPrice.toInt()}',
                    icon: Icons.monetization_on);
              }),
          Consumer(builder: (context, ref, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomButton(
                text: 'Comprar',
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final total = _lunches * widget.lunchPrice;
                  final confirm = await showModalBottomSheet<bool>(
                          context: context,
                          builder: (_) => ConfirmLunchOrder(total: total)) ??
                      false;
                  if (!confirm) return;

                  ref.read(dialogHandlerProvider).showAlertDialog(
                      title: 'Procesando solicitud',
                      barrierDismissible: false,
                      content: LunchPurchaseLink(
                          setPaymentProcess: ref
                              .read(studentRestaurantProvider.notifier)
                              .setPaymentProcess(_lunches, total)));
                },
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          }),
        ],
      ),
    );
  }
}
