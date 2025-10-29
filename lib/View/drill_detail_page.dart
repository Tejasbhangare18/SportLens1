import 'dart:async'; // Added for the Timer
import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/_Submit_DrillPage.dart';
import 'package:flutter_application_3/models/drill.dart';

// --- UI Theme Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);

// --- MODIFIED: Converted to StatefulWidget ---
class DrillDetailPage extends StatefulWidget {
  final Drill drill;
  const DrillDetailPage({super.key, required this.drill});

  @override
  State<DrillDetailPage> createState() => _DrillDetailPageState();
}

class _DrillDetailPageState extends State<DrillDetailPage> {
  bool _hasAttempted = false;

  void _handleDrillSubmission() {
    setState(() {
      _hasAttempted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildSliverContent(context, _hasAttempted),
        ],
      ),
      bottomNavigationBar: _hasAttempted
          ? _buildRedoDrillFooter(context)
          : _buildStartDrillButton(context),
    );
  }

  Widget _buildStartDrillButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 12),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              return _buildAttemptSheet(context, _handleDrillSubmission);
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Start Drill",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildRedoDrillFooter(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return _buildAttemptSheet(context, _handleDrillSubmission);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.grey[400],
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Redo Drill",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "1 Attempt Left",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kDarkBlue,
      pinned: true,
      expandedHeight: 300,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.drill.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: kFieldColor,
                  child: const Icon(Icons.play_circle_fill,
                      color: Colors.white24, size: 80),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.drill.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.drill.category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.volume_up_outlined,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSliverContent(
      BuildContext context, bool hasAttempted) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This drill is designed to test your upper body strength. Make sure each repetition is fully completed to ensure you achieve the highest score possible.",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            if (widget.drill.subCategory.isNotEmpty)
              _buildTag(widget.drill.subCategory),
            const SizedBox(height: 24),
            if (hasAttempted) _buildDrillAttemptsSection(),
            _ExpandableSection(title: "Equipment"),
            _ExpandableSection(title: "Player Instructions"),
            _ExpandableSection(title: "Filming Instructions"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDrillAttemptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Drill Attempts",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        _DrillAttemptTile(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAttemptSheet(BuildContext context, VoidCallback onSubmit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_upward_rounded, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          const Text(
            "2x Attempt(s) left",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Before you film your drill make sure you:",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildInstructionTile("Watch the instructional video"),
          _buildInstructionTile(
              "Have all of the equipment needed for the drill"),
          _buildInstructionTile(
              "Set your drill up accurately e.g. distances between cones"),
          _buildInstructionTile(
              "Film from chest height, holding the camera in the correct position"),
          _buildInstructionTile(
              "Film without moving the camera and from the correct angle"),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CameraPage(onDrillSubmitted: onSubmit),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Got It",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInstructionTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  final String title;
  const _ExpandableSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.grey,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(bottom: 12),
            title: Text(
              "Detailed instructions for $title will appear here. This explains everything the user needs before starting the drill.",
              style:
                  TextStyle(color: Colors.black.withOpacity(0.7), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrillAttemptTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: const Text(
          "1st Attempt",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("a few seconds ago",
            style: TextStyle(color: Colors.grey, fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sync,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
        children: const [
          ListTile(
            title: Text(
              "Details about the 1st attempt.",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// --- DUMMY CAMERA PAGE WIDGET (UPDATED: Submit -> UploadProgressPage)
// ===================================================================

class CameraPage extends StatefulWidget {
  final VoidCallback onDrillSubmitted;

  const CameraPage({super.key, required this.onDrillSubmitted});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isRecording = false;
  bool _isReviewing = false;
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startRecording() {
    setState(() {
      _isRecording = true;
      _isReviewing = false;
      _countdown = 5;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRecording = false;
          _isReviewing = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            child: _isRecording ? _buildRecordingIndicator() : null,
          ),
          Expanded(
            child: Center(
              child: _isReviewing
                  ? _buildReviewPreview()
                  : const Text("Camera Preview",
                      style: TextStyle(color: Colors.white38)),
            ),
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: _isReviewing ? _buildReviewButtons() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(backgroundColor: Colors.red, radius: 6),
          const SizedBox(width: 8),
          Text(
            "00:0$_countdown",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewPreview() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.play_arrow, color: Colors.white, size: 60),
      ),
    );
  }

  Widget _buildReviewButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: startRecording,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Redo Drill",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          // ✅ UPDATED: Now goes to UploadProgressPage
          Expanded(
            child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadProgressPage(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: const Text(
    "Submit",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
),

          ),
        ],
      ),
    );
  }
}

// Dummy placeholder for your actual UploadProgressPage class

