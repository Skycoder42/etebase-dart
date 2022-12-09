import 'dart:ffi';

import 'package:etebase/src/isolate/etebase_pool.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class Callable1<TReturn, T0> {
  TReturn call(T0 t0);
}

class MockAllocator extends Mock implements Allocator {}

class MockCallable1<TReturn, T0> extends Mock
    implements Callable1<TReturn, T0> {}

void main() {
  group('$EtebasePool', () {
    final mockAllocator = MockAllocator();
    final mockDestroy = MockCallable1<void, Pointer<Int64>>();

    late EtebasePool sut;

    setUp(() {
      reset(mockAllocator);
      reset(mockDestroy);

      sut = EtebasePool(mockAllocator);
    });

    test('free does nothing', () {
      sut.free(nullptr);
      verifyZeroInteractions(mockAllocator);
    });

    group('scoped', () {
      setUp(() {
        // global pointers should not be affected
        sut.attachGlobal(nullptr);
      });

      test('can attach and free simple pointers', () {
        final testPtr = Pointer<Int16>.fromAddress(42);

        final attached = sut.attachScoped(testPtr);
        expect(attached, same(testPtr));
        verifyZeroInteractions(mockAllocator);

        sut.freeScoped(testPtr);
        verify(() => mockAllocator.free(testPtr));
        verifyNoMoreInteractions(mockAllocator);
      });

      test('attaching or freeing multiple times has no effect', () {
        final testPtr = Pointer<Uint16>.fromAddress(0x24);

        sut
          ..attachScoped(testPtr)
          ..attachScoped(testPtr);
        verifyZeroInteractions(mockAllocator);

        sut.freeScoped(testPtr);
        verify(() => mockAllocator.free(testPtr));

        sut.freeScoped(testPtr);
        verifyNoMoreInteractions(mockAllocator);
      });

      test('can attach pointer with custom destroy method', () {
        final testPtr = Pointer<Int64>.fromAddress(0x42);

        final attached = sut.attachScoped(testPtr, mockDestroy);
        expect(attached, same(testPtr));
        verifyZeroInteractions(mockAllocator);

        sut.freeScoped(testPtr);
        verify(() => mockDestroy(testPtr));
        verifyZeroInteractions(mockAllocator);
        verifyNoMoreInteractions(mockDestroy);
      });

      test('can allocate and free pointers', () {
        const testAllocBytes = 123;
        final testPtr = Pointer<Int8>.fromAddress(0x11);
        when(() => mockAllocator.allocate(any())).thenReturn(testPtr);

        final allocated = sut.allocate(testAllocBytes);
        expect(allocated, same(testPtr));
        verify(() => mockAllocator.allocate(testAllocBytes));
        verifyNoMoreInteractions(mockAllocator);

        sut.freeScoped(testPtr);
        verify(() => mockAllocator.free(testPtr));
        verifyNoMoreInteractions(mockAllocator);
      });

      test('can release all scoped pointers', () {
        final testPtr1 = Pointer<Int8>.fromAddress(0x11);
        final testPtr2 = Pointer<Int16>.fromAddress(0x12);
        final testPtr3 = Pointer<Int64>.fromAddress(0x13);
        final testPtr4 = Pointer<Int64>.fromAddress(0x14);

        sut
          ..attachScoped(testPtr1)
          ..attachScoped(testPtr2)
          ..attachScoped(testPtr3, mockDestroy)
          ..attachScoped(testPtr4, mockDestroy)
          ..freeScoped(testPtr2)
          ..freeScoped(testPtr4);
        clearInteractions(mockAllocator);
        clearInteractions(mockDestroy);

        sut.releaseScope();

        verify(() => mockAllocator.free(testPtr1));
        verify(() => mockDestroy(testPtr3));
        verifyNoMoreInteractions(mockAllocator);
        verifyNoMoreInteractions(mockDestroy);
      });
    });

    group('global', () {
      setUp(() {
        // global pointers should not be affected
        sut.attachScoped(nullptr);
      });

      test('can attach and free simple pointers', () {
        final testPtr = Pointer<Int16>.fromAddress(42);

        final attached = sut.attachGlobal(testPtr);
        expect(attached, same(testPtr));
        verifyZeroInteractions(mockAllocator);

        sut.freeGlobal(testPtr);
        verify(() => mockAllocator.free(testPtr));
        verifyNoMoreInteractions(mockAllocator);
      });

      test('attaching or freeing multiple times has no effect', () {
        final testPtr = Pointer<Uint16>.fromAddress(0x24);

        sut
          ..attachGlobal(testPtr)
          ..attachGlobal(testPtr);
        verifyZeroInteractions(mockAllocator);

        sut.freeGlobal(testPtr);
        verify(() => mockAllocator.free(testPtr));

        sut.freeGlobal(testPtr);
        verifyNoMoreInteractions(mockAllocator);
      });

      test('can attach pointer with custom destroy method', () {
        final testPtr = Pointer<Int64>.fromAddress(0x42);

        final attached = sut.attachGlobal(testPtr, mockDestroy);
        expect(attached, same(testPtr));
        verifyZeroInteractions(mockAllocator);

        sut.freeGlobal(testPtr);
        verify(() => mockDestroy(testPtr));
        verifyZeroInteractions(mockAllocator);
        verifyNoMoreInteractions(mockDestroy);
      });

      test('can release all global and scoped pointers', () {
        final testPtr1 = Pointer<Int8>.fromAddress(0x11);
        final testPtr2 = Pointer<Int16>.fromAddress(0x12);
        final testPtr3 = Pointer<Int64>.fromAddress(0x13);
        final testPtr4 = Pointer<Int64>.fromAddress(0x14);
        final testPtr5 = Pointer<Int32>.fromAddress(0x15);
        final testPtr6 = Pointer<Int64>.fromAddress(0x16);

        sut
          ..attachGlobal(testPtr1)
          ..attachGlobal(testPtr2)
          ..attachGlobal(testPtr3, mockDestroy)
          ..attachGlobal(testPtr4, mockDestroy)
          ..attachScoped(testPtr5)
          ..attachScoped(testPtr6, mockDestroy)
          ..freeGlobal(testPtr2)
          ..freeGlobal(testPtr4);
        clearInteractions(mockAllocator);
        clearInteractions(mockDestroy);

        sut.releaseAll();

        verify(() => mockAllocator.free(testPtr1));
        verify(() => mockDestroy(testPtr3));
        verify(() => mockAllocator.free(testPtr5));
        verify(() => mockDestroy(testPtr6));
        verify(() => mockAllocator.free(nullptr));
        verifyNoMoreInteractions(mockAllocator);
        verifyNoMoreInteractions(mockDestroy);
      });
    });
  });
}
