import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/styles/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

final List urls = [urlGithub, urlFreepik, urlAuthor, urlSvgRepo];
final Uri urlGithub = Uri.parse('https://github.com/PandaHunterX');
final Uri urlFreepik = Uri.parse('https://www.freepik.com/');
final Uri urlAuthor = Uri.parse('https://soco-st.com/?ref=svgrepo.com');
final Uri urlSvgRepo = Uri.parse('https://www.svgrepo.com/');

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(urls[url])) {
      throw Exception('Could not launch ${urls[url]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _launchUrl(0),
          child: Row(
            children: [
              TitleText(
                words: 'App Created by: ',
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black87,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/github.svg'),
                      SecondaryText(
                        words: 'PandaHunterX',
                        size: 20,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            TitleText(
              words: 'Profile Picture Designed by ',
              size: 20,
              fontWeight: FontWeight.w700,
            ),
            GestureDetector(
              onTap: () => _launchUrl(1),
              child: Text(
                'FreePik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Divider(),
        SizedBox(
          width: MediaQuery.sizeOf(context).width - 150,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Text(
                'Vectors and icons by ',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(2),
                child: Text(
                  'Soco St ',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'in CC Attribution License via ',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(3),
                child: Text(
                  'SVG Repo',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
