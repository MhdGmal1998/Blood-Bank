// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blood_bank_app/domain/entities/blood_center.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/repositories/search_repository.dart';

class SearchCentersUseCase {
  final SearchRepository searchRepository;
  SearchCentersUseCase({
    required this.searchRepository,
  });
  Future<Either<Failure, List<BloodCenter>>> call({
    required String state,
    required String district,
  }) async {
    return await searchRepository.searchCenters(
      state: state,
      district: district,
    );
  }
}
