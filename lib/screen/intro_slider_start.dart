import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/OnboardingModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/screen/selecte_login_register_screen.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../navigation.dart';
import '../uatheme.dart';
import '../widgets/User/GradientButton.dart';

class IntroSliderStart extends StatefulWidget {
  @override
  _IntroSliderStartState createState() => _IntroSliderStartState();
}

class _IntroSliderStartState extends State<IntroSliderStart> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<OnBoardingModel> onBoardingList = Constants.onBoardingList;
  bool isLoading = false;
  bool isResponseReceived = false;

  List<Widget> buildOnBoardingPages() {
    final children = <Widget>[];
    for (int i = 0; i < onBoardingList.length; i++) {
      children.add(_showPageData(onBoardingList[i]));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorPrimary,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: buildOnBoardingPages(),
                    ),
                  ),
                  Container(
                    height: height * 0.16,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DotsIndicator(
                          dotsCount: onBoardingList.length,
                          position: double.parse(_currentPage.toString()),
                          decorator: DotsDecorator(
                            color: indicatorDotColor, // Inactive color
                            activeColor: colorWhite,
                            size: Size(8.0, UATheme.extraSmall()),
                          ),
                        ),
                        GradientButton(
                          paddingBottom: UATheme.screenHeight * 0.03,
                          paddingTop: 10,
                          onPressed: () {
                            if (_currentPage == 3) {
                              Navigation.clearOpen(
                                context,
                                SelectLoginOrRegisterScreen(),
                              );
                            } else {
                              _currentPage = _currentPage + 1;
                              _pageController
                                  .animateToPage(_currentPage,
                                      curve: Curves.decelerate,
                                      duration: Duration(milliseconds: 300))
                                  .then((value) {
                                setState(() {});
                              });
                            }
                          },
                          text: S.of(context).buttonTitleList[_currentPage],
                          textColor: colorWhite,
                          size: UATheme.normalSize(),
                          height: 50,
                          width: 140,
                          borderRadius: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showPageData(OnBoardingModel onBoardingModel) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double totalScreenHeight = constraints.maxHeight;
        double totalScreenWidth = constraints.maxWidth;
        return Column(
          children: [
            SizedBox(
              height: totalScreenHeight * 0.04,
            ),
            Container(
              margin: EdgeInsets.only(bottom: totalScreenHeight * 0.015),
              height: totalScreenHeight * 0.3,
              child: SvgPicture.asset(onBoardingModel.imagePath),
            ),
            UALabel(
              text: onBoardingModel.title.toUpperCase(),
              color: colorWhite,
              size: UATheme.extraLargeSize(),
              bold: true,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: totalScreenHeight * 0.015,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: totalScreenWidth * 0.1),
              child: UALabel(
                text: onBoardingModel.description,
                color: colorWhite,
                alignment: TextAlign.center,
                size: 13,
              ),
            ),
          ],
        );
      },
    );
  }
}

/*
class IntroSliderStart extends StatefulWidget {
  @override
  _IntroSliderStartState createState() => _IntroSliderStartState();
}

class _IntroSliderStartState extends State<IntroSliderStart> {
  IntroSlider introSlider;
  int count = 0;
  final controller = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();

    List<Slide> slides = [
      _buildSliderTab(
        stickerImages_2,
        S.current.titleList[0],
        S.current.subTitleList[0],
      ),
      _buildSliderTab(
        stickerImages_3,
        S.current.titleList[1],
        S.current.subTitleList[1],
      ),
      _buildSliderTab(
        stickerImages_4,
        S.current.titleList[2],
        S.current.subTitleList[2],
      ),
      _buildSliderTab(
        stickerImages_5,
        S.current.titleList[3],
        S.current.subTitleList[3],
      ),
    ];

    introSlider = IntroSlider(
      slides: slides,
      isShowSkipBtn: false,
      isShowDoneBtn: false,
      isShowDotIndicator: true,
      isShowNextBtn: false,
      isShowPrevBtn: false,
      isScrollable: true,
      onTabChangeCompleted: _onTabChangCompleted,
      colorDot: indicatorDotColor,
      colorActiveDot: colorWhite,
      sizeDot: UATheme.extraSmall(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: _buildSlider(),
    );
  }

  _buildSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 8, child: _buildIntro()),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: GradientButton(
              paddingBottom: UATheme.screenHeight * 0.03,
              onPressed: () {
                if (count == 3) {
                  Navigation.clearOpen(
                    context,
                    SelectLoginOrRegisterScreen(),
                  );
                } else {
                  IntroSliderState.goToNext();
                  setState(() {});
                }
              },
              text: S.of(context).buttonTitleList[count],
              textColor: colorWhite,
              size: UATheme.normalSize(),
              height: 50,
              width: 140,
              borderRadius: 100,
            ),
          ),
        )
      ],
    );
  }

  _buildIntro() {
    return introSlider;
  }

  _buildSliderTab(String imagePath, String title, String subtite) {
    return Slide(
        widgetDescription: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: UATheme.screenHeight * 0.015),
              height: UATheme.screenHeight * 0.3,
              child: SvgPicture.asset(imagePath),
            ),
            UALabel(
              text: title.toUpperCase(),
              color: colorWhite,
              size: UATheme.extraLargeSize(),
              bold: true,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: UATheme.screenHeight * 0.015,
            ),
            UALabel(
              text: subtite,
              color: colorWhite,
              alignment: TextAlign.center,
              HtmlText: true,
              size: UATheme.normalTinySize(),
            ),
          ],
        ),
        backgroundColor: colorTransparent);
  }

  _onTabChangCompleted(int index) {
    setState(() {
      count = index;
    });
  }
}
*/
