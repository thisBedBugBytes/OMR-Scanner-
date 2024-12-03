import 'package:dashboard_ui/data/course_details.dart';
import 'package:dashboard_ui/util/scanner.dart';
import 'package:flutter/material.dart';
import 'custom_card_widget.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const courses = CourseDetails.courses; // Access the static list directly

    return GridView.builder(
      itemCount: courses.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        final course = courses[index];
        if(course.title == 'Upload OMR'){
        return CustomCard(
          child: InkWell(

            onTap: () async {
            //   Navigator.push(context,
            //   MaterialPageRoute(builder: (context) => course.destination));
            //
            Scanner obj = Scanner(context);
            obj.onPressed();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  course.icon,
                  width: 77,
                  height: 77,
                ),
                const SizedBox(height: 8),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );}
        else{
          return CustomCard(
            child: InkWell(

              onTap: () async {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => course.destination));

              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    course.icon,
                    width: 77,
                    height: 77,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}