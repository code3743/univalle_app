import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class MessageRating extends StatelessWidget {
  const MessageRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: 200,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 140,
              width: size.width,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Evaluar a los docentes nos ayuda a mejorar la calidad educativa.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.1,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: SizedBox(
              height: 190,
              width: 120,
              child: Image.asset('assets/img/uv_ardilla.png'),
            ),
          ),
          Positioned(
            right: 10,
            top: 45,
            child: IconButton(
                onPressed: () {
                  context.pop();
                },
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: AppColors.white,
                  elevation: 2,
                ),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primaryBlue,
                )),
          )
        ],
      ),
    );
  }
}
