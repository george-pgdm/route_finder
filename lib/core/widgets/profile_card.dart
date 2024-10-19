import 'package:flutter/material.dart';
import 'package:locaview/core/resources/color_file.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: ColorFile.primaryColor,
      child: Stack(
        children: [
          ClipPath(
            clipper: MirroredWaveClippp(),
            child: Container(
              width: 300,
              height: 200,
              decoration: const BoxDecoration(color: Colors.white24),
            ),
          ),
          ClipPath(
            clipper: MirroredWaveClipp(),
            child: Container(
              height: 200,
              width: 300,
              decoration: const BoxDecoration(color: Colors.white10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4), // Shadow position
                  blurRadius: 8.0, // Shadow blur radius
                ),
              ],
              //                 color: Color(0xFF256bf5),
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset(
                      "assets/images/user_pic.png",
                      height: 35,
                      width: 35,
                      color: ColorFile.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Robert Doe",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "robertdoe@gmail.com",
                        style: TextStyle(
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MirroredWaveClipp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Draw the top wave
    path.lineTo(0, size.height - 25);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 1, size.height - 90);
    path.quadraticBezierTo(
        6 * size.width / 4, size.height - 100, size.width, size.height - 70);

    // Draw the bottom wave
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class MirroredWaveClippp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Draw the top wave
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 1, size.height - 130);
    path.quadraticBezierTo(
        6 * size.width / 4, size.height - 100, size.width, size.height - 70);

    // Draw the bottom wave
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

// class MirroredWaveClippp extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     // Draw the top wave
//     path.lineTo(0, size.height - 180);
//     path.quadraticBezierTo(
//         size.width / 6, size.height, size.width / 2, size.height - 180);
//     path.quadraticBezierTo(
//         6 * size.width / 8, size.height - 300, size.width, size.height - 370);

//     // Draw the bottom wave
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
// }
