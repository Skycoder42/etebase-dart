export 'js_client_wrapper_stub.dart' show Action;

export 'js_client_wrapper_stub.dart'
    if (dart.library.io) 'js_client_wrapper_vm.dart'
    if (dart.library.js_interop) 'js_client_wrapper_js.dart'
    hide Action;
