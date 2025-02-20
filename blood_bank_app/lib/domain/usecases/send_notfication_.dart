// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:blood_bank_app/core/error/failures.dart';
import 'package:blood_bank_app/domain/repositories/notfication_repository.dart';

class SendNotficationUseCase {
  final SendNotficationRepository sendNotificationRepository;
  SendNotficationUseCase({
    required this.sendNotificationRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required SendNotificationData sendNotficationData}) async {
    return sendNotificationRepository.senNotficationToGroup(
        sendNotificationData: sendNotficationData);
  }
}

class SendNotificationData {
  List<String> listToken;
  String title;
  String body;
  SendNotificationData({
    required this.listToken,
    required this.title,
    required this.body,
  });
}
