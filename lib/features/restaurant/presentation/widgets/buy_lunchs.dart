import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomTextFormField(
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_lunches == widget.maxLunches) return;
                  _controller.text = (++_lunches).toString();
                },
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (_lunches == widget.minLunches) return;
                  _controller.text = (--_lunches).toString();
                },
              ),
              onChanged: (value) {
                final int lunches = int.tryParse(value) ?? 0;
                if (lunches == 0) {
                  _lunches = 0;
                  return;
                }
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
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese un valor';
                }
                return null;
              },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton(
              text: 'Comprar',
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
              },
              backgroundColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
