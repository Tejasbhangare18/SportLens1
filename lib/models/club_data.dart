// lib/models/club_data.dart

class Club {
  final String id;
  final String name;
  final String city;
  final String sport;
  final String logoUrl;
  final String bannerUrl;
  final int followers; // Example field

  Club({
    required this.id,
    required this.name,
    required this.city,
    required this.sport,
    required this.logoUrl,
    required this.bannerUrl,
    required this.followers,
  });

  get description => null;

  // Sample data generation methods
  static List<Club> getSampleJoinedClubs() {
    return [
  // Use available assets for logos/banners (assets/ directory contains these files)
  Club(id: 'club1', name: 'Pune Strikers', city: 'Pune', sport: 'Cricket', logoUrl: 'assets/profile1.png', bannerUrl: 'assets/fourth.png', followers: 1200),
  Club(id: 'club2', name: 'Mumbai Indians Fan Club', city: 'Mumbai', sport: 'Cricket', logoUrl: 'assets/profile3.png', bannerUrl: 'assets/third1.png', followers: 5000),
    ];
  }

   static List<Club> getSampleFeaturedClubs() {
    return [
  Club(id: 'club3', name: 'Delhi Capitals Academy', city: 'Delhi', sport: 'Cricket', logoUrl: 'assets/profile4.png', bannerUrl: 'assets/home3.png', followers: 850),
  Club(id: 'club4', name: 'Nashik Knights', city: 'Nashik', sport: 'Football', logoUrl: 'assets/profile5.png', bannerUrl: 'assets/home2.png', followers: 450),
  Club(id: 'club1', name: 'Pune Strikers', city: 'Pune', sport: 'Cricket', logoUrl: 'assets/profile1.png', bannerUrl: 'assets/fourth.png', followers: 1200),

    ];
  }

  static List<Club> getSampleAllClubs() {
    return [
  Club(id: 'club5', name: 'Basketball Bounce Pune', city: 'Pune', sport: 'Basketball', logoUrl: 'assets/profile7.png', bannerUrl: 'assets/home4.png', followers: 300),
  Club(id: 'club6', name: 'Mumbai City FC Supporters', city: 'Mumbai', sport: 'Football', logoUrl: 'assets/profile8.png', bannerUrl: 'assets/fourth.png', followers: 2100),
  Club(id: 'club1', name: 'Pune Strikers', city: 'Pune', sport: 'Cricket', logoUrl: 'assets/profile1.png', bannerUrl: 'assets/fourth.png', followers: 1200),
  Club(id: 'club3', name: 'Delhi Capitals Academy', city: 'Delhi', sport: 'Cricket', logoUrl: 'assets/profile4.png', bannerUrl: 'assets/home3.png', followers: 850),
  Club(id: 'club4', name: 'Nashik Knights', city: 'Nashik', sport: 'Football', logoUrl: 'assets/profile5.png', bannerUrl: 'assets/home2.png', followers: 450),

    ];
  }
}