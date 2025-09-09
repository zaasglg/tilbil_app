import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:til_bil_app/screens/junior/animal_kingdom.dart';
import 'package:til_bil_app/screens/junior/forest_and_garden.dart';
import 'package:til_bil_app/screens/junior/magic_syllables_land.dart';
import 'package:til_bil_app/screens/junior/our_home.dart';
import 'package:til_bil_app/screens/junior/human_secret.dart';
import 'package:til_bil_app/screens/junior/colors_and_shapes.dart';
import 'package:til_bil_app/screens/junior/numbers_palace.dart';
import 'package:til_bil_app/screens/junior/action_game.dart';
import 'package:til_bil_app/screens/junior/sentence_builder.dart';
import 'package:til_bil_app/screens/junior/sound_hunters.dart';
import 'package:til_bil_app/screens/middle/dybys_patshalygy_turleri.dart';
import 'package:til_bil_app/screens/middle/jalgau_eli.dart';
import 'package:til_bil_app/screens/middle/matin_mekeni.dart';
import 'package:til_bil_app/screens/middle/soylem_qalasy.dart';
import 'package:til_bil_app/screens/middle/sozstan_jauan_jinishke.dart';
import 'package:til_bil_app/screens/middle/tubir_men_kosymsha.dart';
import 'package:til_bil_app/screens/middle/bastauysh_pen_bayandauysh.dart';
import 'package:til_bil_app/screens/middle/zat_esimder_auyly.dart';
import 'package:til_bil_app/screens/middle/sandary_sarayi.dart';
import 'package:til_bil_app/screens/middle/matin_sheberhanasy.dart';
import 'package:til_bil_app/screens/senior/birinshi_oyin.dart';
import 'package:til_bil_app/screens/senior/etistik_shaktary.dart';
import 'package:til_bil_app/screens/senior/sheber_oyini.dart';
import 'package:til_bil_app/screens/senior/sinonim_antonim_omonim.dart';
import 'package:til_bil_app/screens/senior/soz_taptary.dart';
import 'package:til_bil_app/screens/senior/tabigat_zerteushileri.dart';
import 'package:til_bil_app/screens/senior/tynys_belgileri.dart';
import 'package:til_bil_app/screens/senior/sozderdin_baylanysuy.dart';
import 'package:til_bil_app/screens/senior/jiktik_septik_jalgau.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with TickerProviderStateMixin {
  String? _error;
  late AnimationController _animationController;

  // Animation controllers
  late AnimationController _bounceController;
  late AnimationController _streakController;
  late AnimationController _progressController;

  int _userAge = 5; // Default age
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? age = prefs.getInt('userAge');

      setState(() {
        _userAge = age ?? 5; // Default to 5 if not found
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading user data: $e');
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  Widget _getLessonIcon(String title) {
    // Return different icons based on lesson title and age group
    if (_userAge >= 4 && _userAge <= 5) {
      // Icons for 4-5 age group
      switch (title) {
        case 'Дыбыс \n аңшылары':
          return const HeroIcon(
            HeroIcons.speakerWave,
            color: Colors.white,
            size: 40,
          );
        case 'Сиқырлы \n буындар елі':
          return const HeroIcon(
            HeroIcons.sparkles,
            color: Colors.white,
            size: 40,
          );
        case 'Сөйлем құраушы':
          return const HeroIcon(
            HeroIcons.chatBubbleLeftRight,
            color: Colors.white,
            size: 40,
          );
        case 'Жануарлар \n патшалығы':
          return const HeroIcon(
            HeroIcons.heart,
            color: Colors.white,
            size: 40,
          );
        case 'Орман мен \n бақтың сырлары':
          return const HeroIcon(
            HeroIcons.lifebuoy,
            color: Colors.white,
            size: 40,
          );
        case 'Менің бөлмем':
          return const HeroIcon(
            HeroIcons.home,
            color: Colors.white,
            size: 40,
          );
        case 'Адам құпиясы':
          return const HeroIcon(
            HeroIcons.user,
            color: Colors.white,
            size: 40,
          );
        case 'Түстер мен \n пішіндер әлемі':
          return const HeroIcon(
            HeroIcons.paintBrush,
            color: Colors.white,
            size: 40,
          );
        case 'Сандар сарайы':
          return const HeroIcon(
            HeroIcons.calculator,
            color: Colors.white,
            size: 40,
          );
        case 'Іс-әрекет ойыны':
          return const HeroIcon(
            HeroIcons.bolt,
            color: Colors.white,
            size: 40,
          );
        default:
          return const Icon(
            IconlyBold.play,
            color: Colors.white,
            size: 40,
          );
      }
    } else if (_userAge >= 6 && _userAge <= 8) {
      // Icons for 6-8 age group
      switch (title) {
        case 'Сөзстан':
          return const HeroIcon(
            HeroIcons.bookOpen,
            color: Colors.white,
            size: 40,
          );
        case 'Дыбыс \n патшалығы':
          return const HeroIcon(
            HeroIcons.musicalNote,
            color: Colors.white,
            size: 40,
          );
        case 'Түбір мен \n Қосымша':
          return const HeroIcon(
            HeroIcons.puzzlePiece,
            color: Colors.white,
            size: 40,
          );
        case 'Сөйлем қаласы':
          return const HeroIcon(
            HeroIcons.buildingLibrary,
            color: Colors.white,
            size: 40,
          );
        case 'Мәтін мекені':
          return const HeroIcon(
            HeroIcons.documentText,
            color: Colors.white,
            size: 40,
          );
        case 'Жалғаулар елі':
          return const HeroIcon(
            HeroIcons.link,
            color: Colors.white,
            size: 40,
          );
        case 'Бастауыш \n пен Баяндауыш':
          return const HeroIcon(
            HeroIcons.userGroup,
            color: Colors.white,
            size: 40,
          );
        case 'Зат \n есімдер ауылы':
          return const HeroIcon(
            HeroIcons.cube,
            color: Colors.white,
            size: 40,
          );
        case 'Сандар сарайы':
          return const HeroIcon(
            HeroIcons.hashtag,
            color: Colors.white,
            size: 40,
          );
        case 'Мәтін шеберханасы':
          return const HeroIcon(
            HeroIcons.wrenchScrewdriver,
            color: Colors.white,
            size: 40,
          );
        default:
          return const Icon(
            IconlyBold.play,
            color: Colors.white,
            size: 40,
          );
      }
    } else if (_userAge >= 9 && _userAge <= 14) {
      // Icons for 9-14 age group
      switch (title) {
        case 'Түбірден \n түйсікке':
          return const HeroIcon(
            HeroIcons.academicCap,
            color: Colors.white,
            size: 40,
          );
        case 'Сөйлем \n шеберлері':
          return const HeroIcon(
            HeroIcons.cog6Tooth,
            color: Colors.white,
            size: 40,
          );
        case 'Табиғат \n зерттеушілері':
          return const HeroIcon(
            HeroIcons.magnifyingGlass,
            color: Colors.white,
            size: 40,
          );
        case 'Шақтар \n шеруі':
          return const HeroIcon(
            HeroIcons.clock,
            color: Colors.white,
            size: 40,
          );
        case 'Сөздің сыры':
          return const HeroIcon(
            HeroIcons.key,
            color: Colors.white,
            size: 40,
          );
        case 'Патшалық':
          return const HeroIcon(
            HeroIcons.cloudArrowDown,
            color: Colors.white,
            size: 40,
          );
        case 'Тыныс \n белгі детективі':
          return const HeroIcon(
            HeroIcons.eyeSlash,
            color: Colors.white,
            size: 40,
          );
        case 'Мінез әлемі':
          return const HeroIcon(
            HeroIcons.faceSmile,
            color: Colors.white,
            size: 40,
          );
        case 'Байланыс көпірі':
          return const HeroIcon(
            HeroIcons.arrowsRightLeft,
            color: Colors.white,
            size: 40,
          );
        case 'Жалғау жорықтары':
          return const HeroIcon(
            HeroIcons.flag,
            color: Colors.white,
            size: 40,
          );
        default:
          return const Icon(
            IconlyBold.play,
            color: Colors.white,
            size: 40,
          );
      }
    } else {
      // Default icon for other ages
      return const Icon(
        IconlyBold.play,
        color: Colors.white,
        size: 40,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    _streakController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E8), // Очень светло-зеленый
              Color(0xFFE3F2FD), // Очень светло-синий
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _error != null ? _buildErrorState() : _buildLearningPath(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 70 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User Profile Avatar
              _buildProfileAvatar(),

              // Right section with age and hearts
              Row(
                children: [
                  // Age indicator
                  Container(
                    height: 41,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$_userAge жас",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildHeartsCounter(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          HapticFeedback.lightImpact();

          setState(() {
            _bounceController.reset();
            _bounceController.forward();
          });
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Добавляем легкое вращение и масштабирование для более живой анимации
            final wiggle = sin(_animationController.value * pi * 2) * 0.02;
            final scale = 1.0 + sin(_animationController.value * pi * 2) * 0.03;

            return Transform.rotate(
              angle: wiggle,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    'assets/images/character.png',
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeartsCounter() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticFeedback.lightImpact();
        },
        child: Container(
          height: 41,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 25,
              ),
              SizedBox(width: 6),
              Text(
                '5',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningPath() {
    return Stack(
      children: [
        // Scrollable content with background and path
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height:
                1500, // Extended height to accommodate more spaced out lessons
            child: Stack(
              children: [
                // Background landscape
                // _buildLandscapeBackground(),
                // Winding path with lessons based on age
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildAgeBasedLearningPath(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeBasedLearningPath() {
    debugPrint('Current user age: $_userAge');
    if (_userAge >= 4 && _userAge <= 5) {
      debugPrint('Selected path: 4-5 years');
      return _buildLearningPathFor4To5();
    } else if (_userAge >= 6 && _userAge <= 8) {
      debugPrint('Selected path: 6-8 years');
      return _buildLearningPathFor6To9();
    } else if (_userAge >= 9 && _userAge <= 14) {
      debugPrint('Selected path: 9-14 years');
      return _buildLearningPathFor9To14();
    } else {
      // For ages outside the defined ranges (default case)
      debugPrint('Selected path: Default (using 6-8 years path)');
      return _buildLearningPathFor6To9();
    }
  }

  Widget _buildLearningPathFor4To5() {
    // For younger kids, show the basic lessons
    return Stack(
      children: [
        // _buildWindingPath(),

        // Staircase layout - alternating left and right
        // Kazakh ornament for first button
        Positioned(
          top: 30,
          left: 20,
          child: Text('◇',
              style: TextStyle(fontSize: 20, color: Colors.amber[600])),
        ),

        Positioned(
          top: 45,
          left: 5,
          child: Text('◆',
              style: TextStyle(fontSize: 16, color: Colors.orange[400])),
        ),

        _buildLessonNode(
          top: 50,
          left: 60,
          title: 'Дыбыс \n аңшылары',
          description:
              "әріптер мен дыбыстарды табу, дауысты мен дауыссызды ажырату, жуан-жіңішке дыбыстарды танып білу.",
          progress: 0.46,
          page: const SoundHuntersScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.pink[400],
        ),

        // Kazakh ornament for second button
        Positioned(
          top: 160,
          right: 20,
          child: Text('✦',
              style: TextStyle(fontSize: 18, color: Colors.blue[300])),
        ),

        Positioned(
          top: 175,
          right: 5,
          child: Text('◇',
              style: TextStyle(fontSize: 14, color: Colors.cyan[400])),
        ),

        _buildLessonNode(
          top: 180,
          right: 60,
          title: 'Сиқырлы \n буындар елі',
          description: "сөзді буынға бөлу, дыбыстан сөз құрау.",
          progress: 0.65,
          page: const MagicSyllablesLand(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.blue[400],
        ),

        // Kazakh ornament for third button
        Positioned(
          top: 290,
          left: 25,
          child: Text('❋',
              style: TextStyle(fontSize: 16, color: Colors.green[300])),
        ),

        Positioned(
          top: 305,
          left: 10,
          child: Text('◈',
              style: TextStyle(fontSize: 12, color: Colors.teal[400])),
        ),

        _buildLessonNode(
          top: 310,
          left: 60,
          title: 'Сөйлем құраушы',
          description: "жеңіл сөз тіркестерінен өз сөйлемін құрау.",
          progress: 0.25,
          page: const SentenceBuilderScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.green[400],
        ),

        // Kazakh ornament for fourth button
        Positioned(
          top: 420,
          right: 25,
          child: Text('✧',
              style: TextStyle(fontSize: 17, color: Colors.purple[300])),
        ),

        Positioned(
          top: 435,
          right: 10,
          child: Text('◊',
              style: TextStyle(fontSize: 13, color: Colors.deepPurple[300])),
        ),

        _buildLessonNode(
          top: 440,
          right: 60,
          title: 'Жануарлар \n патшалығы',
          description: "үй жануарлары мен жабайы аңдар атауларын білу.",
          progress: 0.0,
          page: const AnimalKingdomScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.purple[500],
        ),

        // Kazakh ornament for fifth button
        Positioned(
          top: 550,
          left: 30,
          child: Text('✤',
              style: TextStyle(fontSize: 15, color: Colors.indigo[300])),
        ),

        Positioned(
          top: 565,
          left: 15,
          child: Text('◉',
              style: TextStyle(fontSize: 11, color: Colors.blue[400])),
        ),

        _buildLessonNode(
          top: 570,
          left: 60,
          title: 'Орман мен \n бақтың сырлары',
          description: "өсімдіктер мен табиғаттағы заттарды атау.",
          progress: 0.0,
          page: const ForestAndGardenScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.purple[500],
        ),

        // Kazakh ornament for sixth button
        Positioned(
          top: 680,
          right: 30,
          child: Text('❈',
              style: TextStyle(fontSize: 16, color: Colors.orange[300])),
        ),
        Positioned(
          top: 695,
          right: 15,
          child: Text('◎',
              style: TextStyle(fontSize: 12, color: Colors.amber[400])),
        ),
        _buildLessonNode(
          top: 700,
          right: 60,
          title: 'Менің бөлмем',
          description: "тұрмыстық заттарды табу және атау.",
          progress: 0.10,
          page: const OurHomeScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.orange[400],
        ),

        // Kazakh ornament for seventh button
        Positioned(
          top: 810,
          left: 35,
          child:
              Text('✥', style: TextStyle(fontSize: 14, color: Colors.red[300])),
        ),
        Positioned(
          top: 825,
          left: 20,
          child: Text('◐',
              style: TextStyle(fontSize: 10, color: Colors.pink[400])),
        ),

        _buildLessonNode(
          top: 830,
          left: 60,
          title: 'Адам құпиясы',
          description: "дене мүшелерін және сезімдерін тану.",
          progress: 0.0,
          page: HumanSecretScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.purple[500],
        ),

        // Kazakh ornament for eighth button
        Positioned(
          top: 940,
          right: 35,
          child: Text('✦',
              style: TextStyle(fontSize: 15, color: Colors.lime[400])),
        ),

        Positioned(
          top: 955,
          right: 20,
          child: Text('✦',
              style: TextStyle(fontSize: 11, color: Colors.green[300])),
        ),

        _buildLessonNode(
          top: 960,
          right: 60,
          title: 'Түстер мен \n пішіндер әлемі',
          description: "түстер мен геометриялық пішіндерді ажырату.",
          progress: 0.10,
          page: ColorsAndShapesScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.orange[400],
        ),

        // Kazakh ornament for ninth button
        Positioned(
          top: 1070,
          left: 40,
          child: Text('✧',
              style: TextStyle(fontSize: 16, color: Colors.cyan[300])),
        ),

        Positioned(
          top: 1085,
          left: 25,
          child: Text('◈',
              style: TextStyle(fontSize: 12, color: Colors.blue[400])),
        ),
        _buildLessonNode(
          top: 1090,
          left: 60,
          title: 'Сандар сарайы',
          description: "сандарды тану және қолдану.",
          progress: 0.0,
          page: NumbersPalaceScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.cyan[500],
        ),

        // Kazakh ornament for tenth button
        Positioned(
          top: 1200,
          right: 40,
          child: Text('❋',
              style: TextStyle(fontSize: 17, color: Colors.teal[300])),
        ),
        Positioned(
          top: 1215,
          right: 25,
          child: Text('◉',
              style: TextStyle(fontSize: 13, color: Colors.green[400])),
        ),
        _buildLessonNode(
          top: 1220,
          right: 60,
          title: 'Іс-әрекет ойыны',
          description:
              "бару, келу, беру, алу, жеу, ішу сияқты әрекеттерді сөзбен және қимылмен көрсету.",
          progress: 0.0,
          page: ActionGameScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.teal[500],
        ),
      ],
    );
  }

  Widget _buildLearningPathFor6To9() {
    return Stack(
      children: [
        _buildLessonNode(
          top: 50,
          left: 60,
          title: 'Сөзстан',
          description: "Жуан-жіңішке дауыстылар",
          progress: 0.0,
          page: const SozstanJauanJinishkeScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.pink[400],
        ),
        _buildLessonNode(
          top: 180,
          right: 60,
          title: 'Дыбыс \n патшалығы',
          description: "Дыбыстардың түрлері (қатаң, ұяң, үнді)",
          progress: 0.0,
          page: const DybysPatshalygyTurleriScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.blue[400],
        ),
        _buildLessonNode(
          top: 310,
          left: 60,
          title: 'Түбір мен \n Қосымша',
          description: "Сөз құрамы: түбір, қосымша",
          progress: 0.0,
          page: const TubirMenKosymshaScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.green[400],
        ),
        _buildLessonNode(
          top: 440,
          right: 60,
          title: 'Сөйлем қаласы',
          description:
              "Сөйлем және сөйлемнің бас әріптен басталып, соңында тыныс белгісімен аяқталуы",
          progress: 0.0,
          page: const SoylemQalasyScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.purple[500],
        ),
        _buildLessonNode(
          top: 570,
          left: 60,
          title: 'Мәтін мекені',
          description: "Мәтін және сөйлем түрлері (хабарлы, сұраулы, лепті)",
          progress: 0.0,
          page: const MatinMekeniScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.indigo[500],
        ),
        _buildLessonNode(
          top: 700,
          right: 60,
          title: 'Жалғаулар елі',
          description: "Жалғаулар (көптік, септік, тәуелдік жалғаулар)",
          progress: 0.0,
          page: const JalgauEliScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.orange[400],
        ),
        _buildLessonNode(
          top: 830,
          left: 60,
          title: 'Бастауыш \n пен Баяндауыш',
          description: "Сөйлем мүшелері: бастауыш пен баяндауыш",
          progress: 0.0,
          page: BastauyshPenBayandayushScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.red[500],
        ),
        _buildLessonNode(
          top: 960,
          right: 60,
          title: 'Зат \n есімдер ауылы',
          description: "Зат есімнің жекеше және көпше түрлері",
          progress: 0.0,
          page: ZatEsimderAuylyScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.teal[400],
        ),
        _buildLessonNode(
          top: 1090,
          left: 60,
          title: 'Сандар сарайы',
          description: "Сан есім түрлері: есептік, реттік",
          progress: 0.0,
          page: SandarySarayiScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.cyan[500],
        ),
        _buildLessonNode(
          top: 1220,
          right: 60,
          title: 'Мәтін шеберханасы',
          description: "Мәтіннің құрылымы: кіріспе, негізгі бөлім, қорытынды",
          progress: 0.0,
          page: MatinSheberhanasyScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.deepPurple[500],
        ),
      ],
    );
  }

  Widget _buildLearningPathFor9To14() {
    // For older kids (9-14), show advanced Kazakh language lessons
    return Stack(
      children: [
        // Staircase layout - alternating left and right
        _buildLessonNode(
          top: 50,
          left: 60,
          title: 'Түбірден \n түйсікке',
          description: "Күрделі тапсырмалар мен тілдік дағдыларды жетілдіру",
          progress: 0.0,
          page: BirinshiOyinScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.deepPurple[600],
        ),

        _buildLessonNode(
          top: 180,
          right: 60,
          title: 'Сөйлем \n шеберлері',
          description: "Толық, күрделі, құрмалас сөйлемдер құрау",
          progress: 0.0,
          page: const SheberOyiniScreen(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.teal[600],
        ),

        _buildLessonNode(
          top: 310,
          left: 60,
          title: 'Табиғат \n зерттеушілері',
          description: "Сын есімдерді үйрену және қолдану",
          progress: 0.0,
          page: const TabigatZerteushileri(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.green[500],
        ),

        _buildLessonNode(
          top: 440,
          right: 60,
          title: 'Шақтар \n шеруі',
          description:
              "Мәтінді оқып, етістіктерді тауып, олардың шақ түрін анықтау",
          progress: 0.0,
          page: const EtistikShaktary(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.orange[500],
        ),

        _buildLessonNode(
          top: 570,
          left: 60,
          title: 'Сөздің сыры',
          description: "4 дағды бойынша 10 тапсырма",
          progress: 0.0,
          page: const SinonimAntonimOmonim(),
          isCompleted: false,
          isLocked: false,
          themeColor: Colors.purple[500],
        ),

        _buildLessonNode(
          top: 700,
          right: 60,
          title: 'Сөз таптары',
          description: "Зат есім, етістік, сын есім, үстеу - 10 тапсырма",
          progress: 0.0,
          isCompleted: false,
          page: const SozTaptaryScreen(),
          isLocked: false,
          themeColor: Colors.indigo[500],
        ),

        _buildLessonNode(
          top: 830,
          left: 60,
          title: 'Тыныс \n белгі детективі',
          description: "Тыныс белгі, негізгі ойды табу, жоспар құру",
          progress: 0.0,
          isCompleted: false,
          page: const TynysBelgileriScreen(),
          isLocked: false,
          themeColor: Colors.red[500],
        ),

        // _buildLessonNode(
        //   // top: 960,
        //   // right: 60,
        //   title: 'Мінез әлемі',
        //   description: "Кейіпкердің мінезін сипаттау дағдылары",
        //   progress: 0.0,
        //   isCompleted: false,
        //   isLocked: false,
        //   themeColor: Colors.pink[500],
        // ),

        _buildLessonNode(
          // top: 1090,
          // left: 60,
          top: 960,
          right: 60,
          title: 'Байланыс көпірі',
          description: "Сөздердің байланысу түрлерін үйрену",
          progress: 0.0,
          isCompleted: false,
          page: const SozderdinBaylanysuyScreen(),
          isLocked: false,
          themeColor: Colors.cyan[500],
        ),

        _buildLessonNode(
          top: 1090,
          left: 60,
          title: 'Жалғау жорықтары',
          description: "Жіктік, септік, тәуелдік жалғаулар тақырыбы",
          progress: 0.0,
          isCompleted: false,
          page: const JiktikSeptikJalgauScreen(),
          isLocked: false,
          themeColor: Colors.amber[600],
        ),
      ],
    );
  }

  Widget _buildLessonNode({
    double? top,
    double? left,
    double? right,
    required String title,
    double? progress,
    required bool isCompleted,
    required bool isLocked,
    bool showCelebration = false,
    Color? themeColor,
    Widget? page,
    String? description,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final bounceValue = showCelebration
              ? 1.0 + (sin(_bounceController.value * 2 * pi) * 0.1)
              : 1.0;

          return Transform.scale(
            scale: bounceValue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main lesson content
                Column(
                  children: [
                    // 3D lesson button with Chiclet
                    ChicletAnimatedButton(
                      onPressed: isLocked
                          ? () {}
                          : () => _onLessonTap(title,
                              page: page, description: description),
                      width: 115,
                      height: 115,
                      backgroundColor: isLocked
                          ? Colors.grey[400]!
                          : isCompleted
                              ? const Color(0xFF6FD86F)
                              : themeColor ?? Colors.blue[600]!,
                      borderRadius: 57.5,
                      child: Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isLocked
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey[200]!,
                                    Colors.grey[600]!
                                  ],
                                )
                              : isCompleted
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF6FD86F),
                                        Color(0xFF2E7D32)
                                      ],
                                    )
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        themeColor?.withOpacity(0.9) ??
                                            Colors.blue[300]!,
                                        themeColor ?? Colors.blue[800]!,
                                      ],
                                    ),
                        ),
                        child: Center(
                          child: isLocked
                              ? const Icon(
                                  IconlyBroken.lock,
                                  color: Colors.white,
                                  size: 35,
                                )
                              : isCompleted
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 50,
                                    )
                                  : AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        final scale = 1.0 +
                                            sin(_animationController.value *
                                                    pi *
                                                    4) *
                                                0.08;

                                        return Transform.scale(
                                          scale: scale,
                                          child: _getLessonIcon(title),
                                        );
                                      },
                                    ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Lesson title
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onLessonTap(String lessonTitle, {Widget? page, String? description}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLessonInfoBottomSheet(lessonTitle,
          page: page, description: description),
    );
  }

  Widget _buildLessonInfoBottomSheet(String lessonTitle,
      {Widget? page, String? description}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              lessonTitle.toUpperCase(),
              style: GoogleFonts.nunito(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: ChicletAnimatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      if (page != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => page));
                      }
                    },
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: 60,
                    backgroundColor: const Color(0xFF58A6FF),
                    borderRadius: 30,
                    child: const Text(
                      'Сабақты бастау',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error mascot с анимацией грустного барса
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Медленно качающийся из стороны в сторону грустный барс
                final swayAngle = sin(_animationController.value * pi) * 0.05;

                return Transform.rotate(
                  angle: swayAngle,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF6B6B).withOpacity(0.1),
                          const Color(0xFFFF6B6B).withOpacity(0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Грустный барс с затемненным фильтром
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.5),
                              BlendMode.saturation,
                            ),
                            child: Image.asset(
                              'assets/images/character.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Грустный эмоджи поверх
                        const Icon(
                          Icons.sentiment_dissatisfied_rounded,
                          size: 50,
                          color: Color(0xFFFF6B6B),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              '😔 Қате! Бірдеңе дұрыс болмады',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Retry button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    setState(() {
                      _error = null;
                    });
                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Қайта көру',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
