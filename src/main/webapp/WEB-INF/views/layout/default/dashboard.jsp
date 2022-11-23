<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
<body class="hold-transition sidebar-mini">
    <div class="wrapper">

    	<div class="content-wrapper">
            <!-- Main content -->
            <div class="content">
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
	<script id="div_char1">
	  // labels: ['유입수', '스토어이동', '설치완료수', '가입자수'],
		var _chartData1 = [0,0,0,0];
        var a1 = "[[${bean.clickCnt}]]";
        var a2 = "[[${bean.moveStoreCnt}]]";
        var a3 = "[[${bean.downCnt}]]";
        var a4 = "[[${bean.regitCnt}]]";

        _chartData1[0] = Number(a1);
        _chartData1[1] = Number(a2);
        _chartData1[2] = Number(a3);
        _chartData1[3] = Number(a4);

        console.log(_chartData1);
     </script>

	<script id="div_char2">
		var _chartData2 = [];
		var b1 = "[[${bean.cnt1}]]";
		var b2 = "[[${bean.cnt2}]]";
		var b3 = "[[${bean.cnt3}]]";
		var b4 = "[[${bean.cnt4}]]";
		var b5 = "[[${bean.cnt5}]]";
		var b6 = "[[${bean.cnt6}]]";
		var b7 = "[[${bean.cnt7}]]";

		_chartData2[0] = Number(b1);
		_chartData2[1] = Number(b2);
		_chartData2[2] = Number(b3);
		_chartData2[3] = Number(b4);
		_chartData2[4] = Number(b5);
		_chartData2[5] = Number(b6);
		_chartData2[6] = Number(b7);
     </script>

	<script>
		// 주차구하기
		const getWeekNumber = (dateFrom = new Date()) => {	  // 해당 날짜 (일)
		  const currentDate = dateFrom.getDate();
		  const startOfMonth = new Date(dateFrom.setDate(1));
		  const weekDay = startOfMonth.getDay();
		  return parseInt(((weekDay - 1) + currentDate) / 7) + 1;
		}

		const getMonth =  (dateFrom = new Date()) => {	  // 해당 날짜 (일)
			  const currentDate = dateFrom.getDate();
			  const startOfMonth = new Date(dateFrom.setDate(1));
			  return startOfMonth.getMonth()+1;
		}

        $(document).ready(function() {
        	 Chart.register(ChartDataLabels);
        	 fn_go_list1();
        	 fn_go_list2();

        	var dateFrom = new Date()
        	var currentDate = dateFrom.getDate();
   		  	var startOfMonth = new Date(dateFrom.setDate(1));
   		  	var weekDay = startOfMonth.getDay();
   		    var month = startOfMonth.getMonth()+1;
   		    var year = startOfMonth.getFullYear();
   		    var week = parseInt(((weekDay - 1) + currentDate) / 7) + 1;
   		    var todayText = year+"년 "+month+"월 "+week+"주차";
   		    $("#todayText1").html("("+ year+"년 "+month+"월"+")");
   		 	$("#todayText2").html("("+todayText+")");
        });

    	function fn_go_list1(){
    		var params = {};
    		var url = "/common/marketing/list";
    		params.menuType = "admin";
    		params.menuNm = "marketing";
    		params.menuId = "analysis";
    		params.sqlId = "AnalysisChart1";
    		params.divId = "div_char1";
    		params.sqlType = "U";
    		params.originPage = "dashboard/dashboard_index";

    		// 페이징 처리
    		params.currentPage = 5000;	// 현제페이지
    		params.pageCnt = $("select[name=search_pageCnt]").val();	// 보여질 list개수
    		params.lastNo = 10;				// 페이징 번호 개수

    		var _callback = function (data) {
    			console.log(data);
    			$("#"+params.divId).replaceWith(data);
    			if(a1>0){
    				fn_draw_char1();
    			}
    		};
    		c21.common_ajaxCallback2(url, params, _callback);
    	}

    	function fn_go_list2(){
    		var params = {};
    		var url = "/common/marketing/list";
    		params.menuType = "admin";
    		params.menuNm = "marketing";
    		params.menuId = "analysis";
    		params.sqlId = "AnalysisChart2";
    		params.divId = "div_char2";
    		params.sqlType = "U";
    		params.originPage = "dashboard/dashboard_index";

    		// 페이징 처리
    		params.currentPage = 5000;	// 현제페이지
    		params.pageCnt = $("select[name=search_pageCnt]").val();	// 보여질 list개수
    		params.lastNo = 10;				// 페이징 번호 개수

    		var _callback = function (data) {
    			$("#"+params.divId).replaceWith(data);
              	 fn_draw_char2();
    		};
    		c21.common_ajaxCallback2(url, params, _callback);
    	}

    	function fn_draw_char1(){
    			console.log(_chartData1);
    			// 월간 채널 가입 통계 차트
    	        const ctx = document.getElementById('monthly-chart').getContext('2d');
    	        const chartMonthly = new Chart(ctx, {
    	            type: 'doughnut',
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

    	function fn_draw_char2(){
            //주간 차트
            const dailylabels = ['월', '화', '수', '목', '금', '토', '일'];
            const weeklydata = {
                labels: dailylabels,
                datasets: [{
                    label: '',
                    data: _chartData2,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                    ],
                    borderColor: [
                        'rgb(255, 99, 132)',
                    ],
                    borderWidth: 1
                }],
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
    </script>