import 'dart:io' show Platform;
import 'package:dimple/common/const/colors.dart';
import 'package:dimple/common/const/const.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialLoginWebviewScreen extends ConsumerStatefulWidget {
  static String get routeName => 'social-login';

  const SocialLoginWebviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SocialLoginWebviewScreen> createState() => _SocialLoginWebviewScreenState();
}

class _SocialLoginWebviewScreenState extends ConsumerState<SocialLoginWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.clearCache();
      await _controller.clearLocalStorage();
    });
    super.dispose();
  }

  Future<void> _initializeWebView() async {
    final fullUrl = 'https://$ip/oauth2/authorization/google';

    final userAgent = Platform.isAndroid
        ? 'Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36'
        : 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: _handleNavigation,
        ),
      );

    await _controller.loadRequest(Uri.parse(fullUrl));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = Uri.parse(request.url);
    // print('Navigation request to: ${request.url}'); // 네비게이션 요청 확인용 로그

    // 성공 URL 체크
    if (uri.path == '/auth/success') {
      final token = uri.queryParameters['token'];
      if (token != null) {
        _handleLoginSuccess(token);
        return NavigationDecision.prevent;
      }
    }

    return NavigationDecision.navigate;
  }

  Future<void> _handleLoginSuccess(String token) async {
    try {
      final userState = await ref.read(userMeProvider.notifier).handleSocialLoginCallback(token);

      if (!mounted) return;

      if (userState is UserModel) {
        // 사용자 정보 유무에 따라 다른 화면으로 이동
        if (userState.name.isNotEmpty) {
          context.go('/');
        }
        // else {
        //   context.go('/dog-register');
        // }
      } else {
        _showError('로그인에 실패했습니다.');
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        _showError('로그인 처리 중 오류가 발생했습니다.');
        context.go('/login');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('구글 로그인'),
        backgroundColor: PRIMARY_COLOR,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
} 