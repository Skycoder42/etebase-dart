// ignore_for_file: discarded_futures

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/exceptions/async_crypto_executor_isolate_failure.dart';
import 'package:etebase/src/api/exceptions/conflict.dart';
import 'package:etebase/src/api/exceptions/connection_problem.dart';
import 'package:etebase/src/api/exceptions/crypto_failure.dart';
import 'package:etebase/src/api/exceptions/etebase_exception.dart';
import 'package:etebase/src/api/exceptions/http_error_content.dart';
import 'package:etebase/src/api/exceptions/http_failure.dart';
import 'package:etebase/src/api/exceptions/http_field_error.dart';
import 'package:etebase/src/api/exceptions/integrity_compromised.dart';
import 'package:etebase/src/api/exceptions/invalid_message_pack_data.dart';
import 'package:etebase/src/api/exceptions/missing_content.dart';
import 'package:etebase/src/api/exceptions/not_found.dart';
import 'package:etebase/src/api/exceptions/permission_denied.dart';
import 'package:etebase/src/api/exceptions/server_problem.dart';
import 'package:etebase/src/api/exceptions/temporary_server_problem.dart';
import 'package:etebase/src/api/exceptions/unauthorized.dart';
import 'package:sodium/sodium.dart';
import 'package:test/test.dart';

void main() {
  group('$EtebaseException', () {
    const testErrorContent = HttpErrorContent(
      code: 'ERR_TST',
      detail: 'Test Error',
      errors: [HttpFieldError(code: 'ERR_TST_FLD', detail: 'Test Field Error')],
    );

    testData(
      'Simple exceptions print type and message',
      [
        (ApiMissuse('test'), '$ApiMissuse: test'),
        (AsyncCryptoExecutorIsolateFailure('test'), 'test'),
        (Conflict('test'), '$Conflict(409): test'),
        (
          ConnectionProblem(Exception('test')),
          '$ConnectionProblem: Exception: test',
        ),
        (
          CryptoFailure(originalMessage: 'test'),
          '$CryptoFailure: A low level cryptographic operation has failed',
        ),
        (IntegrityCompromised('test'), '$IntegrityCompromised: test'),
        (InvalidMessagePackData('test'), '$InvalidMessagePackData: test'),
        (MissingContent('test'), '$MissingContent: test'),
        (NotFound('test'), '$NotFound(404): test'),
        (PermissionDenied('test'), '$PermissionDenied(403): test'),
        (ServerProblem(512, 'test'), '$ServerProblem(512): test'),
        (
          TemporaryServerProblem(513, 'test'),
          '$TemporaryServerProblem(513): test',
        ),
        (Unauthorized('test'), '$Unauthorized(401): test'),
        (HttpFailure(412, 'test'), '$HttpFailure(412): test'),
      ],
      (fixture) {
        expect(fixture.$1.toString(), fixture.$2);
      },
    );

    testData(
      'http exceptions print content instead of message if given',
      [
        (
          Conflict('test', testErrorContent),
          '$Conflict(409): $testErrorContent',
        ),
        (
          NotFound('test', testErrorContent),
          '$NotFound(404): $testErrorContent',
        ),
        (
          PermissionDenied('test', testErrorContent),
          '$PermissionDenied(403): $testErrorContent',
        ),
        (
          ServerProblem(512, 'test', testErrorContent),
          '$ServerProblem(512): $testErrorContent',
        ),
        (
          TemporaryServerProblem(513, 'test', testErrorContent),
          '$TemporaryServerProblem(513): $testErrorContent',
        ),
        (
          Unauthorized('test', testErrorContent),
          '$Unauthorized(401): $testErrorContent',
        ),
        (
          HttpFailure(412, 'test', testErrorContent),
          '$HttpFailure(412): $testErrorContent',
        ),
      ],
      (fixture) {
        expect(fixture.$1.toString(), fixture.$2);
      },
    );

    group('$CryptoFailure', () {
      group('wrap', () {
        group('sync', () {
          test('returns callback result by default', () {
            expect(CryptoFailure.wrap<int, int>(() => 42), 42);
          });

          test('rethrows SodiumException as CryptoFailure', () {
            expect(
              () => CryptoFailure.wrap<int, int>(
                () => throw SodiumException('testMessage'),
              ),
              throwsA(
                isA<CryptoFailure>().having(
                  (m) => m.originalMessage,
                  'originalMessage',
                  'testMessage',
                ),
              ),
            );
          });
        });

        group('async', () {
          test('returns callback result by default', () {
            expect(
              CryptoFailure.wrap<Future<int>, int>(() async => 42),
              completion(42),
            );
          });

          test('rethrows immediate SodiumException as CryptoFailure', () {
            expect(
              () => CryptoFailure.wrap<Future<int>, int>(
                () => throw SodiumException('testMessage'),
              ),
              throwsA(
                isA<CryptoFailure>().having(
                  (m) => m.originalMessage,
                  'originalMessage',
                  'testMessage',
                ),
              ),
            );
          });

          test('rethrows delayed SodiumException as CryptoFailure', () {
            expect(
              () => CryptoFailure.wrap<Future<int>, int>(
                () => Future.delayed(
                  const Duration(milliseconds: 100),
                  () => throw SodiumException('testMessage'),
                ),
              ),
              throwsA(
                isA<CryptoFailure>().having(
                  (m) => m.originalMessage,
                  'originalMessage',
                  'testMessage',
                ),
              ),
            );
          });
        });

        test(
          'preserves StackTrace',
          onPlatform: {
            'js': const Skip(
              'On web the trace looks the same, but is not identical',
            ),
          },
          () {
            final testTrace = StackTrace.current;
            try {
              CryptoFailure.wrap<int, int>(
                () => Error.throwWithStackTrace(
                  SodiumException('testMessage'),
                  testTrace,
                ),
              );
              fail('No exception was thrown');
            } on CryptoFailure catch (_, s) {
              expect(s, same(testTrace));
            }
          },
        );
      });
    });
  });
}
