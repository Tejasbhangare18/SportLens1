// lib/models/coach_data.dart

// VERY Simple Placeholder Model - Expand with more fields as needed
class Coach {
  final String id;
  final String name;
  final String sport;
  final String profileImageUrl;
  final String bannerImageUrl; // For featured cards
  final String specialization;
  final double rating;
  final String experience;

  var location;


  Coach({
    required this.id,
    required this.name,
    required this.sport,
    required this.profileImageUrl, // Assuming local asset paths
    required this.bannerImageUrl,
    required this.specialization,
    required this.rating,
    required this.experience,
  });

  get city => null;

  // Sample data generation methods
  static List<Coach> getSampleFollowedCoaches() {
    return [
  // Map sample coaches to existing files in assets/
  Coach(id: 'c1', name: 'Alex Morgan', sport: 'Soccer', profileImageUrl: 'assets/coach.png', bannerImageUrl: 'assets/fourth.png', specialization: 'Striker Skills', rating: 4.8, experience: 'Pro Player'),
  Coach(id: 'c2', name: 'Virat Kohli', sport: 'Cricket', profileImageUrl: 'assets/coach2.png', bannerImageUrl: 'assets/third1.png', specialization: 'Batting Masterclass', rating: 4.9, experience: 'Intl. Captain'),
  Coach(id: 'c3', name: 'Serena Williams', sport: 'Tennis', profileImageUrl: 'assets/coach3.png', bannerImageUrl: 'assets/home3.png', specialization: 'Power Serve', rating: 4.9, experience: '23 Grand Slams'),
  Coach(id: 'c4', name: 'LeBron James', sport: 'Basketball', profileImageUrl: 'assets/coach4.png', bannerImageUrl: 'assets/coach5.png', specialization: 'All-Around Play', rating: 4.7, experience: 'NBA Champion'),

    ];
  }

   static List<Coach> getSampleFeaturedCoaches() {
    return [
  Coach(id: 'c2', name: 'Virat Kohli', sport: 'Cricket', profileImageUrl: 'assets/coach2.png', bannerImageUrl: 'assets/third1.png', specialization: 'Batting Masterclass', rating: 4.9, experience: 'Intl. Captain'),
  Coach(id: 'c3', name: 'Serena Williams', sport: 'Tennis', profileImageUrl: 'assets/coach3.png', bannerImageUrl: 'assets/home3.png', specialization: 'Power Serve', rating: 4.9, experience: '23 Grand Slams'),
  Coach(id: 'c1', name: 'Alex Morgan', sport: 'Soccer', profileImageUrl: 'assets/coach.png', bannerImageUrl: 'assets/fourth.png', specialization: 'Striker Skills', rating: 4.8, experience: 'Pro Player'),
    ];
  }

  static List<Coach> getSampleAllCoaches() {
    return [
  Coach(id: 'c5', name: 'P.V. Sindhu', sport: 'Badminton', profileImageUrl: 'assets/coach5.png', bannerImageUrl: 'assets/home2.png', specialization: 'Net Play', rating: 4.6, experience: 'Olympic Medalist'),
  Coach(id: 'c6', name: 'Rohit Sharma', sport: 'Cricket', profileImageUrl: 'assets/coach6.png', bannerImageUrl: 'assets/home4.png', specialization: 'Opening Batsman', rating: 4.7, experience: 'IPL Captain'),
  Coach(id: 'c7', name: 'Megan Rapinoe', sport: 'Soccer', profileImageUrl: 'assets/tejas1.png', bannerImageUrl: 'assets/third1.png', specialization: 'Set Pieces', rating: 4.5, experience: 'World Cup Winner'),
  Coach(id: 'c1', name: 'Alex Morgan', sport: 'Soccer', profileImageUrl: 'assets/coach.png', bannerImageUrl: 'assets/fourth.png', specialization: 'Striker Skills', rating: 4.8, experience: 'Pro Player'),
  Coach(id: 'c4', name: 'LeBron James', sport: 'Basketball', profileImageUrl: 'assets/coach4.png', bannerImageUrl: 'assets/coach5.png', specialization: 'All-Around Play', rating: 4.7, experience: 'NBA Champion'),

    ];
  }
}