
/**
 * 달력 오늘,어제 등... 기간 설정하기
 */
$(function(){
		// 기간 설정하기
		$('.btn-group .btn').on('click', function(e) {
			$(this).siblings().removeClass('active');
			$(this).addClass('active');
			
			var v = $(this).attr("day");
			var sDate = c21.date_today("yyyyMMdd");
			var eDate = c21.date_today("yyyy-MM-dd");
			var beforeDay = "";
			if (v == "all") {
				$("#search_startDt").val("");
				$("#search_endDt").val("");
			} else {
				if (Number(v) > 30) {
					v = Number(v) - 30;
					beforeDay = c21.date_addMonth(-v, "yyyy-MM-dd", sDate);  // function(num, type, defineDate)
				} else {
					beforeDay = c21.date_addDay(-v, "yyyy-MM-dd", sDate);
				}
				$("#search_startDt").val(beforeDay);
				$("#search_endDt").val(eDate);
			}
		});
});