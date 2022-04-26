import 'package:flutter/material.dart';
import 'package:gladbettor/model/OnboardingModel.dart';
import 'package:gladbettor/model/TrendModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:intl/intl.dart';

class Constants {
  static final String user = "user";
  static final String firstTime = "first_time";
  static final String introSliderTitle1 = "";
  static final String tipster = "tipster";
  static final String pronostics = "pronostics";
  static final dateFormat = new DateFormat('dd/MM/yyyy');
  static final String language = "language";
  static bool isTrendsAdShow = true;
  static bool isHighlightsAdShow = true;
  static final List<Trend> allTrends = List<Trend>();
  static bool isTrendScreen = true;
  static bool isRankScreen=false;
  static bool isHighlightScreen = false;
  static int credit = 0;
  static String today;
  static ValueNotifier<bool> creditTap = ValueNotifier<bool>(false);
  static String yestardat =  DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).toString();
 // static String yestardat =  "2021-01-10 00:00:00.000";
  static int set=0;
 static int onOneTap=1;

  /*static var startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .millisecondsSinceEpoch;*/
  static var startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  ).millisecondsSinceEpoch;
  static var endDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
      .millisecondsSinceEpoch;

  static var currentDate = DateTime.now();
  static var notification = "notification";

  static List<String> titleList = [
    "Application unique",
    "Gain de temps",
    "Prenez le contrôle",
    "Attention",
  ];

  static List<String> titleListEnglish = [
    "Single application",
    "Time saving",
    "Take control",
    "Warning",
  ];

  static List<String> subTitleList = [
    "La puissance du Big Data s’invite pour la première fois dans votre smartphone lors de vos paris sportifs sur le football.\n\nChaque seconde, de nouvelles données utiles à votre prise de décision sont générées par Internet.\n\nMettez en relation plusieurs dizaines de sources connus en temps réel.",
    "Vous suivez de près les pronostics sportifs sur internet et vous consultez régulièrement la presse mais cela vous prend de nombreuses heures de visionnage et de lecture et vous n’arrivez pas à recouper les informations à votre avantage ?\n\nGlad Bettor extrait des informations utiles provenant de nombreuses sources de données.",
    "Notre technologie d’apprentissage automatique ainsi que nos analystes seront présents pour vous fournir des conseils plusieurs fois par semaine.\n\nVous connaîtrez les sources les plus fiables selon le contexte, ainsi que les sources les moins fiables. Chaque jour les tendances seront affichées en temps réels et toutes les cartes seront entre vos mains.",
    "Cette application n’incite pas aux paris sportifs et n’est pas en partenariat avec un book maker. Pour cette raison nous n’affichons pas les quotes.\n\nCette application a un but pédagogique et analytique pour une meilleure prise de décision en utilisant simplement des tendances, toutes nos données sont publiques, sourcées et vérifiables en un clic.\n\nLe pari sportif vous expose à des risques.",
    /*"La puissance du Big Data s’invite pour la première fois dans votre smartphone lors de vos paris sportifs sur le football.\n\nChaque seconde, de nouvelles données utiles à votre prise de décision sont générées par Internet.\n\nMettez en relation plusieurs dizaines de sources connus en temps réel.",
    "Vous suivez de près les pronostics sportifs sur internet et vous consultez régulièrement la presse mais cela vous prend de nombreuses heures de visionnage et de lecture et vous n’arrivez pas à recouper les informations à votre avantage ?\n\nGlad Bettor extrait des informations utiles provenant de nombreuses sources de données.",
    "Notre technologie d’apprentissage automatique ainsi que nos analystes seront présents pour vous fournir des conseils plusieurs fois par semaine.\n\nVous connaîtrez les sources les plus fiables selon le contexte, ainsi que les sources les moins fiables. Chaque jour les tendances seront affichées en temps réels et toutes les cartes seront entre vos mains.",
    "Cette application n’incite pas au paris sportif et n’est pas en partenariat avec un book maker. Pour cette raison nous n’affichons pas les quotes.\n\nCette application a un but pédagogique et analytique pour une meilleure prise de décision en utilisant simplement des tendances, toutes nos données sont publiques, sourcées et vérifiables en un clic.\n\nLe pari sportif vous expose à des risques.",*/
  ];

  static List<String> subTitleListEnglish = [
    "The power of Big Data comes to your smartphone for the first time when you are betting on football.\n\nEvery second, new data useful to your decision making are generated by the Internet.\n\nConnect several dozen known sources in real time.",
    "You closely follow sports forecasts on the internet and consult the press regularly, but it takes you many hours of viewing and reading and you cannot cross-check the information to your advantage?\n\nGlad Bettor extracts useful information from many data sources.",
    "Our machine learning technology as well as our analysts will be there to provide advice several times a week.\n\nYou will know the most reliable sources depending on the context, as well as the less reliable sources. Every day the trends will be displayed in real time and all the charts will be in your hands.",
    "This application does not encourage sports betting and is not in partnership with a book maker. For this reason we do not display quotes.\n\nThis application has an educational and analytical purpose for better decision making by simply using trends, all our data is public, sourced and verifiable with one click.\n\nSports betting exposes you to risks.",
    /*"The power of Big Data comes to your smartphone for the first time when you are betting on football.\n\nEvery second, new data useful to your decision making are generated by the Internet.\n\nConnect several dozen known sources in real time.",
    "You closely follow sports forecasts on the internet and consult the press regularly, but it takes you many hours of viewing and reading and you cannot cross-check the information to your advantage?\n\nGlad Bettor extracts useful information from many data sources.",
    "Our machine learning technology as well as our analysts will be there to provide advice several times a week.\n\nYou will know the most reliable sources depending on the context, as well as the less reliable sources. Every day the trends will be displayed in real time and all the charts will be in your hands.",
    "This application does not encourage sports betting and is not in partnership with a book maker. For this reason we do not display quotes.\n\nThis application has an educational and analytical purpose for better decision making by simply using trends, all our data is public, sourced and verifiable with one click.\n\nSports betting exposes you to risks.",*/
  ];

  static List<String> buttonTitleList = [
    "Suivant",
    "Suivant",
    "Suivant",
    "Valider",
  ];

  static List<String> buttonTitleListEnglish = [
    "Next",
    "Next",
    "Next",
    "Validate",
  ];

  static List<OnBoardingModel> onBoardingList = [
    OnBoardingModel(
      imagePath: stickerImages_2,
      title: S.current.titleList[0],
      description: S.current.subTitleList[0],
    ),
    OnBoardingModel(
      imagePath: stickerImages_3,
      title: S.current.titleList[1],
      description: S.current.subTitleList[1],
    ),
    OnBoardingModel(
      imagePath: stickerImages_4,
      title: S.current.titleList[2],
      description: S.current.subTitleList[2],
    ),
    OnBoardingModel(
      imagePath: stickerImages_5,
      title: S.current.titleList[3],
      description: S.current.subTitleList[3],
    ),
  ];
}
