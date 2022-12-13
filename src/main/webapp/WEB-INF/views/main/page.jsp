<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
	<title>관리자 대시보드</title>
<!--  	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
	
	버전 3
	<script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script> -->
	
	
	<!-- <script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
	 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/chart.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0-rc"></script>
</head>

<body class="hold-transition sidebar-mini">
		<div class="wrapper">
			<div class="content-wrapper">
				<!-- Main content -->
				<div class="content" style="margin-top: 5%">
					<div class="content-header">
						<div class="container-fluid">
							<h1 class="title">대시보드</h1>
						</div>
					</div>
					<div class="container-fluid">
						<div class="row row-30">
							<div class="col-6">
								<div class="p-4 card h-100">
									<div>
										<div class="d-flex align-items-end">
											<span class="font-weight-bold font-size-lg">월간 채널 가입 통계</span>
											<span class="text-gray m-l-20" id="todayText1"></span>
										</div>
										<style>
											.monthly-chart-inner {
												position: absolute;
												top: 50%;
												left: 50%;
												transform: translate(-50%, -50%);
												text-align: center;
											}
										</style>
										<div class="p-5 d-flex justify-content-center align-items-center mt-4 h-100 m-auto position-relative" style="width: 500px!important;">
											<canvas id="monthly-chart"></canvas>
											<div class="monthly-chart-inner">
												<strong class="font-size-lg">채널 가입 통계</strong>
												<p>100%</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="p-4 card h-100">
									<div>
										<div class="d-flex align-items-end">
											<span class="font-weight-bold font-size-lg">주간 가입자수 통계</span>
											<span class="text-gray m-l-20" id="todayText2"></span>
										</div>
										<div class="p-5 d-flex justify-content-center align-items-center mt-4 h-100">
											<canvas id="weekly-chart"></canvas>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
</body>
<script>
$(document).ready(function() { 
	var dateFrom = new Date()
	var startOfMonth = new Date(dateFrom.setDate(1));
    var month = startOfMonth.getMonth()+1;
    var year = startOfMonth.getFullYear();
    $("#todayText1").html("("+ year+"년 "+month+"월"+")");
    
	fun_draw_char1();
	fun_draw_char2();
});


function fun_draw_char1(){
	var inputData = {};
	fun_ajaxPostSend("/marketing/select/marketingMonthly.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			var _chartData1 = [0,0,0,0];
			var a1 = tempResult[0].clickCnt;
			var a2 = tempResult[0].moveStoreCnt;
			var a3 = tempResult[0].downCnt;
			var a4 = tempResult[0].regitCnt;
			
			_chartData1[0] = Number(a1);
			_chartData1[1] = Number(a2);
			_chartData1[2] = Number(a3);
			_chartData1[3] = Number(a4);
			
			// 월간 채널 가입 통계 차트
			const ctx = document.getElementById('monthly-chart').getContext('2d');
			const chartMonthly = new Chart(ctx, {
				type: 'doughnut',
				plugins: [ChartDataLabels],
				data: {
					labels: ['유입수', '스토어이동', '설치완료수', '가입자수'],
					datasets: [{
						data:_chartData1,
						backgroundColor: ['rgb(255, 99, 132)', 'rgb(255, 159, 64)', 'rgb(255, 205, 86)', 'rgb(75, 192, 192)', ],
						}]
				},
	 		options: {
					plugins: {
						legend: {
							display: true,
						},
						tooltip: {
							enabled: true,
						},
						datalabels: {
							display: true,
								textAlign: 'center',
								color: '#555',
								font: {
									weight: 'bold',
									size: '14',
								},
								formatter: function(value, ctx) {
									value = c21.set_addComma(value);
									return ctx.chart.data.labels[ctx.dataIndex] + '\n' + value;
								}
						},
						doughnutlabel: {
							labels: [{
								text: '채널 가입 통계',
								font: {
									size: 20,
									weight: 'bold'
								}
							}, {
								text: ' 100%',
							}]
						}
					}
				}
			});
		}
	}); 
}//월간채널 가입통계 차트 셋팅 end


function fun_draw_char2(){
	var inputData = {};
	fun_ajaxPostSend("/marketing/select/marketingweekly.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
		var tempResult = JSON.parse(msg.result);
		var _chartData1 = [];
		var _chartData2 = [];
		for (var i = 0; i < tempResult.length; i++) {
			_chartData1[i] = Number(tempResult[i].osTypeAos);
			_chartData2[i] = Number(tempResult[i].osTypeIos);
		}

		//주간 차트
		const dailylabels = ['월', '화', '수', '목', '금', '토', '일'];
		const weeklydata = {
				
				labels: dailylabels,
				datasets: [
					{
					label: 'AOS',
					data: _chartData1,
					backgroundColor: [
						'rgba(255, 99, 132, 0.7)',
					]
					} ,
					
					{
						label: 'IOS',
						data: _chartData2,
						backgroundColor: [
							'rgba(75, 192, 192, 0.7)',
						]
					}
				
				],
				options: {
					plugins: {
						legend: {
							display: false,
						},
						tooltip: {
							enabled: false,
						},
						datalabels: {
							display: true,
							textAlign: 'center',
							color: '#555',
							font: {
								weight: 'bold',
								size: '14',
							},
							formatter: function(value, ctx) {
								value = c21.set_addComma(value);
								return ctx.chart.data.labels[ctx.dataIndex] + '\n' + value;
							}
						}
					}
			}
		};
		
		
		
		
		const weeklyChart = {
			type: 'bar',
			plugins: [ChartDataLabels],
			data: weeklydata,
			options: {
				plugins: {
				    legend: {
				        display: false,
				    },
				},
				scales: {
					y: {
						beginAtZero: true
					},
				}
			},
		};
		const weekly = new Chart(
			document.getElementById('weekly-chart'),
			weeklyChart
		);
		}
	});
}//주간 가입자수 통계
</script>