class ApiError {
  final String message;
  final Map<String, dynamic>? details;

  ApiError({required this.message, this.details});

  factory ApiError.fromDioException(dynamic error) {
    if (error is Map<String, dynamic>) {
      // Handle DRF error format
      final messages = <String>[];

      // Handle non_field_errors
      if (error.containsKey('non_field_errors')) {
        final nonFieldErrors = error['non_field_errors'];
        if (nonFieldErrors is List) {
          messages.addAll(nonFieldErrors.map((e) => e.toString()));
        }
      }

      // Handle field errors
      error.forEach((key, value) {
        if (key != 'non_field_errors' && value is List) {
          final fieldErrors = value.map((e) => e.toString()).join(', ');
          messages.add('$key: $fieldErrors');
        }
      });

      // Handle single 'error' key
      if (error.containsKey('error')) {
        messages.add(error['error'].toString());
      }

      // If no specific errors, use the whole map as string
      if (messages.isEmpty) {
        messages.add(error.toString());
      }

      return ApiError(
        message: messages.join('; '),
        details: error,
      );
    } else {
      return ApiError(message: error?.toString() ?? 'Unknown error');
    }
  }

  @override
  String toString() => message;
}