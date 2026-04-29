import 'package:datepickertask/presentration/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appViewModelProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    Future<void> selectDate() async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(selectedDate),
        firstDate: DateTime(1995, 6, 16),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

        ref.read(appViewModelProvider.notifier).updateDate(formattedDate, ref);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("NASA APOD Viewer"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      selectedDate,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: selectDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            appState.when(
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 80),
                child: CircularProgressIndicator(),
              ),

              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Something went wrong",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

              data: (data) {
                if (data == null) {
                  return const SizedBox();
                }

                if (data.mediaType != "image") {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "No image available for this date",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          data.url ?? '',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                "Image failed to load",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      data.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data.date ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      data.explanation ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
