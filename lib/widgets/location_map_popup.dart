import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class LocationMapPopup extends StatefulWidget {
  const LocationMapPopup({
    super.key,
    required this.location,
    this.lat,
    this.lon,
    required this.onClose,
  });

  final Map<String, dynamic> location;
  final double? lat;
  final double? lon;
  final VoidCallback onClose;

  @override
  State<LocationMapPopup> createState() => _LocationMapPopupState();
}

class _LocationMapPopupState extends State<LocationMapPopup> {
  late final WebViewController _controller;
  bool _isLoading = true;
  static const _mapUrl = 'https://bhoomigeoportal-nbsslup.in/IndianNationalSoilGrid/';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() => _isLoading = false);
              _injectAutoZoom();
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView Error: ${error.description} (${error.errorCode})');
          },
        ),
      )
      ..loadRequest(Uri.parse(_mapUrl));
  }

  void _injectAutoZoom() {
    if (widget.lat == null || widget.lon == null) return;
    
    final lat = widget.lat!;
    final lon = widget.lon!;

    // Best-effort JS injection for common mapping libraries
    final js = '''
      try {
        // Try Leaflet
        if (typeof map !== 'undefined' && map.setView) {
          map.setView([$lat, $lon], 12);
        } 
        // Try OpenLayers (common variable names: map, olMap)
        else if (typeof map !== 'undefined' && map.getView) {
           if (typeof ol !== 'undefined') {
             map.getView().setCenter(ol.proj.fromLonLat([$lon, $lat]));
             map.getView().setZoom(12);
           }
        }
        else if (typeof olMap !== 'undefined' && olMap.getView) {
           if (typeof ol !== 'undefined') {
             olMap.getView().setCenter(ol.proj.fromLonLat([$lon, $lat]));
             olMap.getView().setZoom(12);
           }
        }
      } catch(e) {
        console.log("Auto-zoom failed: " + e);
      }
    ''';
    _controller.runJavaScript(js);
  }

  Future<void> _launchMap() async {
    final uri = Uri.parse(_mapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locText = (widget.location['district'] != null && widget.location['state'] != null)
        ? '${widget.location['district']}, ${widget.location['state']}'
        : 'Unknown location';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Location'),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  
                  // Transparent overlay to capture taps
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _launchMap,
                        splashColor: AppColors.primary.withOpacity(0.2),
                        highlightColor: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ),

                  // "Your location" indicator overlay
                  Center(
                    child: IgnorePointer( // Allow taps to pass through to the InkWell
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            child: const Icon(Icons.my_location, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Your Location', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // "Tap to open" hint
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text('Tap to open', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(locText, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        TextButton(onPressed: widget.onClose, child: const Text('Close')),
      ],
    );
  }
}
