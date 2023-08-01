import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

List<String> hashes = [
  "mUS4t0Z3};nA_IV=9ckrR.b]nya0S6f6xoW9t2fkRmbYxZfPR-e.",
  "mc8%q%R0a{ajtqjdV\$a{fiorn-aRk8fQk6jKfifhayoak9fPj=az",
  "m67o9V0e%MV@00?bMxs:~qs:WBNGRj4.%gxuae^+IARjIUIA%2fQ",
  "mbIy45NFA3\$u}zS6Eos%\$ts,WVNft8s\$sjNfoFs,s;s;xaoLoeoH",
  "mXNJ56M}ozV@G1oeR:n#BaoekDobBGj[oMk9EWRmRRt6IytPf5Ro",
];

List<String> images = [
  "assets/images/1.png",
  "assets/images/2.png",
  "assets/images/3.png",
  "assets/images/4.png",
  "assets/images/5.png",
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _controller;
  int pageIndex = 0;
  double pageValue = 0.0;
  ValueNotifier<String> currentBlurHash = ValueNotifier<String>(
      "mUS4t0Z3};nA_IV=9ckrR.b]nya0S6f6xoW9t2fkRmbYxZfPR-e.");
  var opacity = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {
          pageValue =
              ((_controller.page! - (_controller.page!.toInt() + 1)).abs());
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: currentBlurHash,
            builder: (context, value, __) {
              return AnimatedOpacity(
                opacity: calculateOpacity(pageValue),
                duration: Duration.zero,
                child: Opacity(opacity: 0.8, child: BlurHash(hash: value)),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        pageIndex = value;
                        currentBlurHash.value = hashes[value];
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * .1,
                          vertical: size.width * .15,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(3, 3),
                              color: Colors.black12,
                              blurRadius: 12,
                            ),
                            BoxShadow(
                              offset: Offset(-3, -3),
                              color: Colors.black12,
                              blurRadius: 12,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      size.width * .1, 0, size.width * .1, size.width * .15),
                  alignment: Alignment.center,
                  child: Text(
                    "<-- Swipe -->",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateOpacity(double input) {
    double opacity;
    opacity = 1 - (input * 2);
    return opacity.abs();
  }
}
