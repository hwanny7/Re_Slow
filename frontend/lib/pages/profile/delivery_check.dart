import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeliveryCheck extends StatefulWidget {
  const DeliveryCheck({super.key});

  @override
  State<DeliveryCheck> createState() => _DeliveryCheckState();
}

class _DeliveryCheckState extends State<DeliveryCheck> {
  late final WebViewController controller;
  String htmlString = '''<html><head><meta charset="UTF-8" />
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>스마트택배 배송조회</title>
	<link rel="stylesheet" href="/webjars/github-com-twbs-bootstrap/v3.3.7/dist/css/bootstrap.min.css" />
	<link rel="stylesheet" href="/webjars/github-com-twbs-bootstrap/v3.3.7/dist/css/bootstrap-theme.css" />
	<link rel="stylesheet" href="../../static/css/parcel/tracking-sky.css" />
</head>

<body>

	<div class="header-area">스마트택배 배송조회</div>
	<div class="title-border"></div>
	<div class="title-content">
		<div class="title-notice">운송장 번호</div>
		<div class="title-invoice">564093320652</div>
		<div class="title-company">CJ대한통운</div>
	</div>

	<div class="col-xs-12 info-area no-padding">
		<div class="info-back-line">

			<div class="col-xs-15 text-center">
				<img src="../../static/images/sky/ic_sky_delivery_step1_off.png" class="parcel-img" />
				<div class="info-parcel-text-none">상품인수</div>
			</div>


			<div class="col-xs-15 text-center">
				<img src="../../static/images/sky/ic_sky_delivery_step2_off.png" class="parcel-img" />
				<div class="info-parcel-text-none">상품이동중</div>
			</div>


			<div class="col-xs-15 text-center">
				<img src="../../static/images/sky/ic_sky_delivery_step3_off.png" class="parcel-img" />
				<div class="info-parcel-text-none">배송지도착</div>
			</div>


			<div class="col-xs-15 text-center">
				<img src="../../static/images/sky/ic_sky_delivery_step4_off.png" class="parcel-img" />
				<div class="info-parcel-text-none">배송출발</div>
			</div>

			<div class="col-xs-15 text-center">
				<img src="../../static/images/sky/ic_sky_delivery_step5_on.png" class="parcel-img" />
				<div class="info-parcel-text-active">배송완료</div>
			</div>

		</div>
	</div>

	<div class="col-xs-12 tracking-status-item-list" style="padding-left: 0px; padding-right: 0px;">
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">대전유성신노은</span> | <span class="status-text">배달완료</span>
			<div class="time-text">2023-02-14 16:32:36</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">대전유성신노은</span> | <span class="status-text">배달출발
(배달예정시간
:16∼18시)</span>
			<div class="time-text">2023-02-14 12:00:24</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">유성Sub</span> | <span class="status-text">간선하차</span>
			<div class="time-text">2023-02-14 09:21:27</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">유성Sub</span> | <span class="status-text">간선하차</span>
			<div class="time-text">2023-02-14 09:19:30</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">곤지암Hub</span> | <span class="status-text">간선상차</span>
			<div class="time-text">2023-02-14 03:07:35</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">곤지암Hub</span> | <span class="status-text">간선하차</span>
			<div class="time-text">2023-02-14 03:04:53</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">곤지암Hub</span> | <span class="status-text">간선하차</span>
			<div class="time-text">2023-02-14 02:53:43</div>
			<div class="vertical-line"></div>
		</div>
		<div class="tracking-status-item">
			<div class="list-circle"></div>
			<span class="location-text">여주LM(직영)</span> | <span class="status-text">집화처리</span>
			<div class="time-text">2023-02-13 23:13:12</div>
			<div class="vertical-line"></div>
		</div>
	</div>
	<div class="col-xs-12 notice-area">
		<img src="../../static/images/banner/ic_info-24px.png" style="width:20px; margin-right: 5px;" />
		<span class="template-notice">

    배송 정보 제공 : 스윗트래커 스마트택배API
  </span>
	</div>
	<div class="col-xs-12 banner-area" style="text-align: center">
		<img src="../../static/images/banner/banner_sky.png" style="width: 100%; max-width: 450px; cursor: pointer" class="download-img" />
</div>

		<script src="/webjars/jquery/3.2.1/dist/jquery.min.js"></script>
		<script src="/webjars/github-com-twbs-bootstrap/v3.3.7/dist/js/bootstrap.min.js"></script>
		<script src="../../static/js/smart-download-module.js"></script>

</body>

</html>''';

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.dataFromString(htmlString.replaceAll(RegExp(r'\n'), ''),
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter WebView Example'),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ));
  }
}
