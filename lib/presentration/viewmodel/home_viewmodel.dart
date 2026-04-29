import 'package:datepickertask/core/models/app_model.dart';
import 'package:datepickertask/core/repositories/app_repositories.dart';
import 'package:datepickertask/core/service/app_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';


final appApiServiceProvider = Provider<AppApiService>((ref) {
  return AppApiService();
});

final appRepositoryProvider = Provider<AppRepository>((ref) {
  return AppRepository(ref.read(appApiServiceProvider));
});

final selectedDateProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

class AppViewModel extends StateNotifier<AsyncValue<AppModel?>> {
  final AppRepository repository;

  AppViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadApod(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  Future<void> loadApod(String date) async {
    try {
      state = const AsyncValue.loading();

      final result = await repository.getApod(date);

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateDate(String date, WidgetRef ref) async {
    ref.read(selectedDateProvider.notifier).state = date;
    await loadApod(date);
  }
}

final appViewModelProvider =
    StateNotifierProvider<AppViewModel, AsyncValue<AppModel?>>((ref) {
  final repository = ref.watch(appRepositoryProvider);
  return AppViewModel(repository);
});