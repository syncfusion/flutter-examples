import 'transactional_data.dart';
import 'transactional_details.dart';
import 'user_profile.dart';

class ExpenseAnalysisData {
  ExpenseAnalysisData({required this.users});

  final List<UserDetails> users;
}

class UserDetails {
  UserDetails({required this.userProfile, required this.transactionalData});

  factory UserDetails.fromExcel(
    Profile profile,
    TransactionalDetails transactionalDetails,
  ) {
    return UserDetails(
      userProfile: Profile.fromExcel(profile),
      transactionalData: TransactionalData(data: transactionalDetails),
    );
  }

  Profile userProfile;
  TransactionalData transactionalData;
}
