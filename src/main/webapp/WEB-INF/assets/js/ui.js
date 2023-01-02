/* gnb */
function gnb() {
	var url = window.location.pathname;
	var $active = $('nav a[href="' + url + '"]');

	$active.parent().addClass('menu-open');
	$active.addClass("active");
	$active.parent().parents('li').addClass('menu-open');
	$active.parent().closest(".treeview-menu").siblings("a").addClass("active");

	var dataMenu = $(".content").attr("data-menu");
	var $activeSubMenu = $('nav a[data-menu="' + dataMenu + '"]');
	$activeSubMenu.addClass('active');

	$(".nav-treeview a.active").parent().parent(".nav-treeview").siblings("a").addClass("active");
	$(".nav-treeview a.active").closest(".has-treeview").addClass("menu-open");

}
//gnb();

// 컬러피커
document.querySelectorAll('input[type=color]').forEach(function (picker) {

	var targetLabel = document.querySelector('label[for="' + picker.id + '"]'),
		codeArea = document.createElement('span');

	codeArea.innerHTML = picker.value;
	targetLabel.appendChild(codeArea);

	picker.addEventListener('change', function () {
		codeArea.innerHTML = picker.value;
		targetLabel.appendChild(codeArea);
	});
});


$(document).on('click', '.sort a', function (e) {
	e.preventDefault();

	var list = $(this);
	var listView = $(this).next(".sortList");
	//활성화 되어있는 상태에서 한번더 클릭했을 때
	if ($(this).hasClass('active')) {
		// list.toggleClass("rotate");
	} else {
		$(this).closest('.sort').attr('data-sorting', 'asc');
		list.removeClass("rotate");
		$(".sortList").not(listView).slideUp(300);
	}
	$(this).closest('li').siblings().find('a').removeClass('active');
	$(this).addClass('active');
	$(listView).slideToggle(300);

	// if($(".sortList"))
});


// // // 인풋 파일명 추출
var fileTarget = $('.filebox').children(".upload-hidden");
fileTarget.on('change', function () { // 값이 변경되면
	if (window.FileReader) { // modern browser
		var filename = $(this)[0].files[0].name;
	} else { // old IE
		var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출
	} // 추출한 파일명 삽입
	$(this).siblings('.upload-name').val(filename);
});

// 콘텐츠 수정 :: 사진 수정 시 이미지 미리보기
function readURL(input) {
	// 인풋 태그에 파일이 있는 경우
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function (e) {
			$(".previewImg").show();
			$('.previewImg').attr('src', e.target.result);
		}
		// reader가 이미지 읽도록 하기
		reader.readAsDataURL(input.files[0]);
	}
}
// input file에 change 이벤트 부여
$(":input[name='u_file']").change(function () {
	if ($(":input[name='u_file']").val() == '') {
		$('.previewImg').attr('src', '');
	}
	$('.previewImg').parent(".thumbImg").css({
		'display': ''
	});
	readURL(this);
});

// 이미지 에러 시 미리보기영역 미노출

function imgAreaError() {
	$('#previewImg').css({
		'display': 'none'
	});
}


//드래그
$(document).ready(function () {
	drag();
})

function drag() {
	$('html').addClass('is-editing');
	$("#drag-area").sortable({
		cursor: "move",
		items: ".drag-item:not(.item-disabled)",
		placeholder: "box-placeholder",
		change: function (event, ui) {
			console.log('change');
		}
	});
}



var Common = {
	init: function () {
		Common.event();
		Common.scrolling();
		Common.top();
		window.addEventListener('mousewheel', Common.scrolling);
		window.addEventListener('touchmove', Common.scrolling);

		$(window).scroll(function () {
			Common.scrolling();
		});
	},
	scrolling: function (e) {
		var scrollTop = $(window).scrollTop();

		if (scrollTop > 0) {
			$('html').addClass('is-scrolled');
		} else {
			$('html').removeClass('is-scrolled');
		}

		if ($(window).scrollTop() + $(window).height() > $(document).height() - $('.main-footer').height()) {
			$('.btn-top').addClass('moveup');
		} else {
			$('.btn-top').removeClass('moveup');
		}
	},
	top: function () {
		$('.btn-top').on('click', function (e) {
			e.preventDefault();
			$('html, body').animate({
				scrollTop: 0
			}, 300);
		});
	},
	event: function () {
		$('[data-toggle="tooltip"]').tooltip();

		//length check
		$('textarea, input').on("input", function () {
			if ($(this).attr('maxlength') !== "") {
				var maxlength = $(this).attr("maxlength");
				var content = $(this).val();

				$($(this).attr('data-byte-target')).html(content.length);

				if (content.length > maxlength) {
					$(this).val(content.substring(0, maxlength));
					$($(this).attr('data-byte-target')).html();
				}
			}
		});

		$('.form-datepicker').datepicker({
			format: "yyyy-mm-dd",
			// inDate: '+7',
			closeText: "닫기",
			prevText: "이전달",
			nextText: "다음달",
			currentText: "오늘",
			monthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
			monthNamesShort: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
			dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
			dayNamesShort: ["(일)", "(월)", "(화)", "(수)", "(목)", "(금)", "(토)"],
			dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
			weekHeader: "주",
			dateFormat: "yy-mm-dd",
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			showOtherMonths: true,
			changeMonth: true,
			changeYear: true,
			beforeShow: function (input, inst) {
				$('#ui-datepicker-div').addClass('datepicker-wrapper');
			}
		});

		// 년도 월만 선택할수 있는 데이트 피커
		$("#month-datepicker-area").datepicker({
			closeText: '닫기',
			nextText: '다음 달',
			prevText: '이전 달',
			currentText: "오늘",
			changeMonth: true,
			changeYear: true,
			monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
			dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
			dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			weekHeader: "주",
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: "년",
			showOn: 'both',
			// buttonText: "달력",
			showButtonPanel: true,
			dateFormat: 'yy-mm',
			yearRange: "-10:+0",
			yearRange: 'c-5:c+5', //년도 범위 선택
			showOtherMonths: true,
			selectOtherMonths: true,
		});



		// 풀캘린더
	}
};

Common.init();

$('.icon-del').click(function () {
	$(this).parent().remove();
})
