import 'package:flutter/material.dart';

class DashBoardCard extends StatelessWidget {
  const DashBoardCard(
      {required this.colors,
      this.title,
      this.titleIcon,
      this.mainIcon,
      this.bottomText,
      required this.onTap,
      super.key});
  final List<Color> colors;
  final String? title;
  final IconData? titleIcon;
  final IconData? mainIcon;
  final String? bottomText;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 250,
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: colors),
        ),
        child: Column(
          children: [
            if (title != null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        titleIcon,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                  Text(
                    bottomText!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )
            else
              Column(
                children: [
                  Icon(
                    mainIcon,
                    size: 150,
                    color: Colors.white,
                  ),
                  Text(
                    bottomText!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
