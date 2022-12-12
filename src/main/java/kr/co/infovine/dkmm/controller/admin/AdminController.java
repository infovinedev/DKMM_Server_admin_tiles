package kr.co.infovine.dkmm.controller.admin;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.admin.PermissionOfAdminUser;
import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminProgramModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.service.admin.EncryptService;
import kr.co.infovine.dkmm.service.admin.TAdminService;
import lombok.extern.slf4j.Slf4j;


/**
 * kr.co.infovine.dkmm.controller.admin
 * AdminController.java
 * 2021-05-10 Made by Duhyun, Kim
 */
@Controller
@RequestMapping(value ="/admin")
@Slf4j
public class AdminController{
	@Autowired
	TAdminService tbAdminService;
	
	@Autowired
	EncryptService encryptService;
	
	// region 설명: 로그인 페이지 호출 
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/loginView.do")
	public ModelAndView viewLogin(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/login");
		//session.invalidate();
		return model;
	}
	// end region
	
	
//	// region 설명: Security 로그아웃 호출 
//	/**
//	 * 2021-11-17 Made by Duhyun, Kim
//	 * @param args
//	 * return : ModelAndView
//	 */
//	@RequestMapping(value="/logout.do")
//	public ModelAndView viewLogout(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
//		ModelAndView model = new ModelAndView();
//		session.invalidate();
//		model.setViewName("admin/login");
//		return model;
//	}
//	// end region
//	
	
	// region 설명: 첫 로그인시 비밀번호 변경 페이지 불러오기 
	/**
	 * 2021-06-08 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/firstPassword.do")
	public ModelAndView viewFirstPassword(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
		String userName = sessionModel.getUserName();
		model.addObject("userName", userName);
		model.setViewName("admin/firstPassword");
		return model;
	}
	// end region
	
	
	// region 설명: 로그인 프로세스
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/login.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel processLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUser
			) {
		ResponseModel result = new ResponseModel();
		
		TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		SimpleDateFormat fileDateSdf = new SimpleDateFormat("yyMMdd");
		Calendar currentTime = Calendar.getInstance(Locale.KOREA);
		String tryLoginDate = dateFormat.format(currentTime.getTime());
		if(resultSet!=null) {
			//로그인 성공시
			result.setCode("0000");
			Integer passwordErrorCount = resultSet.getPasswordErrorCount();
			String passwordErrorDate = resultSet.getPasswordErrorDate();
			String passwordLostCheck = resultSet.getPasswordLostCheck();
			String passwordLostDate = resultSet.getPasswordLostDate();
			int adminUserSeq = resultSet.getAdminUserSeq();
			String userName = resultSet.getUserName();
			
			String block = resultSet.getBlockYn();
			if(block != null) {
				if(block.equals("Y")) {
					result.setCode("0005");
					return result;
				}
			}
			
			if(passwordLostCheck != null) {
				if(passwordLostCheck.equals("Y")) {
					System.out.println("현재날짜 : " + sdf.format(currentTime.getTime()));
					String localDate = sdf.format(currentTime.getTime());
					String startDate = "";
					String endDate = "";
					String fileStartDate = "";
					String fileEndDate = "";
					currentTime.add(Calendar.DATE, -7);
					System.out.println("현재날짜-7 : " + sdf.format(currentTime.getTime()));
					currentTime.add(Calendar.DATE, 2 - currentTime.get(Calendar.DAY_OF_WEEK));
					currentTime.set(Calendar.HOUR_OF_DAY, 10);
					currentTime.set(Calendar.MINUTE, 0);
					currentTime.set(Calendar.SECOND, 0);
					currentTime.set(Calendar.MILLISECOND, 000);
					System.out.println("첫번째 요일(월요일)날짜:"+sdf.format(currentTime.getTime()));
					startDate = sdf.format(currentTime.getTime());
					fileStartDate = fileDateSdf.format(currentTime.getTime());
					
					currentTime.add(Calendar.DATE, 9 - currentTime.get(Calendar.DAY_OF_WEEK));
					currentTime.set(Calendar.HOUR_OF_DAY, 9);
					currentTime.set(Calendar.MINUTE, 59);
					currentTime.set(Calendar.SECOND, 59);
					currentTime.set(Calendar.MILLISECOND, 999);
					System.out.println("마지막 요일(일요일)날짜:"+sdf.format(currentTime.getTime()));
					endDate = sdf.format(currentTime.getTime());
					fileEndDate = fileDateSdf.format(currentTime.getTime());
					
					//4월 5일을 월요일로 기준점을 잡는다
					//오늘은 4월 7일이야
					//4월 12일을 기준으로 잡아야돼
//					vo.setStartDate(startDate);
//					vo.setEndDate(endDate);
					//if(passwordLostDate.equals(lastloginDate)) {
					result.setCode("0002");
					return result; 
					//}
				}
				else if(passwordLostCheck.equals("F")){
					result.setCode("0004");
					String userId = tbAdminUser.getUserId();
					SessionModel sessionModel = new SessionModel();
					sessionModel.setUserId(userId);
					sessionModel.setAdminUserSeq(adminUserSeq);
					sessionModel.setUserName(userName);
					session.setAttribute("userInfo", sessionModel);
					return result;
				}
			}
			
			tbAdminUser.setPasswordErrorCount(0);
			tbAdminUser.setPasswordErrorDate("");
			tbAdminUser.setPasswordLostCheck("");
			tbAdminUser.setPasswordLostDate("");
			tbAdminUser.setLastloginDate(tryLoginDate);
			
			tbAdminService.updateByAdminUserUserId(tbAdminUser);
			
			String userId = tbAdminUser.getUserId();
			SessionModel sessionModel = new SessionModel();
			String sha512 = encryptService.getEncryptSha512(userId);
			sha512 = sha512.substring(0, 32);			
			sessionModel.setUserId(userId);
			sessionModel.setAdminUserSeq(adminUserSeq);
			sessionModel.setUserName(userName);
			sessionModel.setCryptoAes(sha512.toUpperCase());
			session.setAttribute("userInfo", sessionModel);
			
		}
		else {
			//로그인 실패시
			//tryLoginDate
			
//			TbAdminUserModel faildLogin = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
//			int errorCount = faildLogin.getPasswordErrorCount();
//			String errorTime = faildLogin.getPasswordErrorDate();
//			if(errorCount>=4) {
//				
//			}
//			
//			tbAdminService.updateByAdminUserPrimaryKey(tbAdminUser);
			
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
//			SimpleDateFormat fileDateSdf = new SimpleDateFormat("yyMMdd");
//
//			
//			Calendar currentTime = Calendar.getInstance(Locale.KOREA);
//			
//			System.out.println("현재날짜 : " + sdf.format(currentTime.getTime()));
//			String localDate = sdf.format(currentTime.getTime());
//			String startDate = "";
//			String endDate = "";
//			String fileStartDate = "";
//			String fileEndDate = "";
//			currentTime.add(Calendar.DATE, -7);
//			System.out.println("현재날짜-7 : " + sdf.format(currentTime.getTime()));
//			currentTime.add(Calendar.DATE, 2 - currentTime.get(Calendar.DAY_OF_WEEK));
//			currentTime.set(Calendar.HOUR_OF_DAY, 10);
//			currentTime.set(Calendar.MINUTE, 0);
//			currentTime.set(Calendar.SECOND, 0);
//			currentTime.set(Calendar.MILLISECOND, 000);
//			System.out.println("첫번째 요일(월요일)날짜:"+sdf.format(currentTime.getTime()));
//			startDate = sdf.format(currentTime.getTime());
//			fileStartDate = fileDateSdf.format(currentTime.getTime());
//			
//			currentTime.add(Calendar.DATE, 9 - currentTime.get(Calendar.DAY_OF_WEEK));
//			currentTime.set(Calendar.HOUR_OF_DAY, 9);
//			currentTime.set(Calendar.MINUTE, 59);
//			currentTime.set(Calendar.SECOND, 59);
//			currentTime.set(Calendar.MILLISECOND, 999);
//			System.out.println("마지막 요일(일요일)날짜:"+sdf.format(currentTime.getTime()));
//			endDate = sdf.format(currentTime.getTime());
//			fileEndDate = fileDateSdf.format(currentTime.getTime());
//			
//			//4월 5일을 월요일로 기준점을 잡는다
//			//오늘은 4월 7일이야
//			//4월 12일을 기준으로 잡아야돼
//			vo.setStartDate(startDate);
//			vo.setEndDate(endDate);
			
			result.setCode("0001");
		}
		
		return result;
	}
	// end region

	
	// region 설명: 메뉴 불러오기
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/left/menu.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectLeftMenu(HttpServletRequest request, HttpServletResponse response, HttpSession session
		) {
		ResponseModel result = new ResponseModel();
		
		SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
		if(sessionModel!=null) {
			int adminUserSeq = sessionModel.getAdminUserSeq();
			List<TbAdminPermissionModel> resultSet = tbAdminService.selectByUserLeftMenu(adminUserSeq);
			
			if(resultSet!=null) {
				//로그인 성공시
				try {
					
					ObjectMapper mapper = new ObjectMapper();
					String strLeftMenu = mapper.writeValueAsString(resultSet);
					result.setResult(strLeftMenu);
				} catch (Exception e) {
					log.error(e.getMessage());
				}
			}
			else {
				
				result.setCode("0001");
			}
		}
		else {
			result.setCode("0004");
		}
		return result;
	}
	// end region


	// region 설명: 프로그램 수정 페이지 불러오기 
	/**
	 * 2021-06-08 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/modifyProgramMenu.do")
	public ModelAndView viewModifyProgram(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/modifyProgramMenu");
		model.addObject("leftPageUrl", "admin/modifyProgramMenu");
		return model;
	}
	// end region

	
	// region 설명: 사용자 등록 및 수정 페이지 불러오기 
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/modifyUser.do")
	public ModelAndView viewModifyUser(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/modifyUser");
		model.addObject("leftPageUrl", "admin/modifyUser");
		return model;
	}
	// end region

	
	// region 설명: 사용자 권환 관리 페이지 불러오기 
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/modifyPermission.do")
	public ModelAndView viewModifyPermission(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/modifyPermission");
		model.addObject("leftPageUrl", "admin/modifyPermission");
		return model;
	}
	// end region
	
	
	// region 설명: 공통코드 수정 페이지 불러오기 
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/modifyCommon.do")
	public ModelAndView viewModifyCommon(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/modifyCommon");
		model.addObject("leftPageUrl", "admin/modifyCommon");
		return model;
	}
	// end region
	
	
	// region 설명: 전체 메뉴 불러오기
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/select/programMenu.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectProgramMenu(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminProgramModel programMenu
		) {
		ResponseModel result = new ResponseModel();
		
		List<TbAdminProgramModel> resultSet = tbAdminService.selectAllProgramMenu(programMenu);
		
		if(resultSet!=null) {
			try {
				
				ObjectMapper mapper = new ObjectMapper();
				String strLeftMenu = mapper.writeValueAsString(resultSet);
				result.setResult(strLeftMenu);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		else {
			
			result.setCode("0001");
		}
		
		return result;
	}
	// end region
	
	@RequestMapping(value="/select/nextProgramId.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectNextProgramId(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminProgramModel programMenu
		) {
		ResponseModel result = new ResponseModel();
		
		TbAdminProgramModel tbAdminProgramModel = tbAdminService.selectNextProgramId(programMenu);
		
		try {
			result.setCode("0000");
			ObjectMapper mapper = new ObjectMapper();
			String jsonBean = mapper.writeValueAsString(tbAdminProgramModel);
			result.setResult(jsonBean);
		} catch (Exception e) {
			result.setCode("0001");
			log.error(e.getMessage());
		}
		
		return result;
	}
	
	
	// region 설명: 사용자의 허가를 주기위한 메뉴 불러오기
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/select/programMenuOfPermission.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectProgramMenuOfPermission(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUserModel) {
		ResponseModel result = new ResponseModel();
		
		List<TbAdminProgramModel> resultModel = new ArrayList<TbAdminProgramModel>();
		try {
			List<TbAdminProgramModel> resultAllMenu = tbAdminService.selectAllProgramMenu(null);
			for(TbAdminProgramModel model : resultAllMenu) {
				
				
				String level = model.getLevel();
				String programName = model.getProgramName();
				if(level != null) {
					if(level.equals("1")) {
						programName = "<b><font Color='Blue'>" + programName + "</font></b>"; 
					}
					else {
						
						try {
							String nbsp = "";
							int iLevel = Integer.parseInt(level);
							for (int i=0; i<iLevel; i++) {
								nbsp = nbsp + "&nbsp;&nbsp;";
							}
							
							programName = nbsp + "▶ "  + programName;
						} catch (Exception e) {
							programName = "&nbsp;&nbsp;└ "  + programName;
						}
					}
				}
				
				model.setProgramName(programName);
				resultModel.add(model);
				
				ObjectMapper mapper = new ObjectMapper();
				String strSelectMenu = mapper.writeValueAsString(resultModel);
				result.setResult(strSelectMenu);
				result.setCode("0000");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		return result;
	}
	// end region
	
	
	
	// region 설명: 사용자의 허가 된 메뉴 불러오기
	/**
	 * 2021-07-02 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/select/permissionOfAdminUser.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectPermissionOfAdminUser(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUserModel) {
		ResponseModel result = new ResponseModel();
		
		int adminUserSeq = tbAdminUserModel.getAdminUserSeq();
		
		List<TbAdminPermissionModel> resultSet = tbAdminService.selectByUserLeftMenu(adminUserSeq);
		
		if(resultSet.size()>0) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				String strLeftMenu = mapper.writeValueAsString(resultSet);
				result.setResult(strLeftMenu);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		result.setCode("0000");
		
		return result;
	}
	// end region
	
	

	// region 설명: 사용자의 허가 된 메뉴 저장하기
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/insert/programPermissionOfAdminUser.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel insertProgramPermissionOfAdminUser(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody PermissionOfAdminUser permission) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = permission.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				//tbAdminService
				List<TbAdminPermissionModel> tempPermission = permission.getTbAdminPermission();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
				Calendar currentTime = Calendar.getInstance(Locale.KOREA);
				String localDate = sdf.format(currentTime.getTime());
				int i=0;
				for(TbAdminPermissionModel model : tempPermission) {
					if(i==0) {		//먼저 전체 데이터를 삭제 한다
						int adminUserSeq = model.getAdminUserSeq();
						tbAdminService.deletePermissionOfAdminUser(adminUserSeq);
					}
					//그 뒤로부터 권한을 부여 합니다.
					model.setRegDate(localDate);
					
					tbAdminService.insertPermissionOfAdminUser(model);
					i++;
				}
				
//				if(adminProgramSeq == -1) {
//					programMenu.setAdminProgramSeq(null);
//					programMenu.setRegDate(localDate);
//					tbAdminService.insertByProgramMenu(programMenu);
//				}
//				else {
//					programMenu.setUpdateDate(localDate);
//					tbAdminService.updateByProgramMenu(programMenu);
//				}
				result.setCode("0000");
			}
			else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
	
	
	
	// region 설명: programMenu 프로그램 저장하기
	/**
	 * 2021-06-08 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value = "/insert/programMenu.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel insertProgramMenu(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminProgramModel programMenu) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = programMenu.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				int adminProgramSeq = programMenu.getAdminProgramSeq();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
				Calendar currentTime = Calendar.getInstance(Locale.KOREA);
				String localDate = sdf.format(currentTime.getTime());
				if(adminProgramSeq == -1) {
					programMenu.setAdminProgramSeq(null);
					programMenu.setRegDate(localDate);
					tbAdminService.insertByProgramMenu(programMenu);
				}
				else {
					programMenu.setUpdateDate(localDate);
					tbAdminService.updateByProgramMenu(programMenu);
				}
				result.setCode("0000");
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
	
	// region 설명: programMenu 프로그램 삭제하기
	/**
	 * 2021-06-08 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value = "/delete/programMenu.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel deleteProgramMenu(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminProgramModel programMenu) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = programMenu.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				int adminProgramSeq = programMenu.getAdminProgramSeq();
				if(adminProgramSeq != -1) {
					tbAdminService.deleteByProgramMenu(adminProgramSeq);
					result.setCode("0000");
				}
				else {
					result.setCode("0001");
				}
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
	
	
	// region 설명: 사용자 등록 및 수정 불러오기
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/select/adminUser.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectAdminUser(HttpServletRequest request, HttpServletResponse response
			, HttpSession session, @RequestBody TbAdminUserModel tbAdminUserModel
		) {
		ResponseModel result = new ResponseModel();
		
		List<TbAdminUserModel> resultSet = tbAdminService.selectAllAdminUser(tbAdminUserModel);
		
		if(resultSet!=null) {
			try {
				//password 공개되지 않은 데이터를 돌려주기위함
				List<TbAdminUserModel> resultAdminUser = new ArrayList<TbAdminUserModel>();
				for(TbAdminUserModel userModel : resultSet) {
					userModel.setPassword("");
					resultAdminUser.add(userModel);
				}
				ObjectMapper mapper = new ObjectMapper();
				String strAdminUser = mapper.writeValueAsString(resultAdminUser);
				result.setResult(strAdminUser);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		else {
			
			result.setCode("0001");
		}
		
		return result;
	}
	// end region
	
	

	// region 설명: 사용자 등록 및 수정 저장하기
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value = "/insert/adminUser.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel insertAdminUser(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUserModel) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = tbAdminUserModel.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				int adminUserSeq = tbAdminUserModel.getAdminUserSeq();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
				Calendar currentTime = Calendar.getInstance(Locale.KOREA);
				String localDate = sdf.format(currentTime.getTime());
				if(adminUserSeq == -1) {
					tbAdminUserModel.setRegDate(localDate);
					tbAdminService.insertAdminUser(tbAdminUserModel);
				}
				else {
					tbAdminUserModel.setUpdateDate(localDate);
					tbAdminService.updateByAdminUserPrimaryKey(tbAdminUserModel);
				}
				result.setCode("0000");
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
	
	// region 설명: 사용자 등록 및 수정 삭제하기(아직 사용안함)
	/**
	 * 2021-06-09 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value = "/delete/adminUser.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel deleteAdminUser(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUserModel) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = tbAdminUserModel.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				int adminUserSeq = tbAdminUserModel.getAdminUserSeq();
				if(adminUserSeq == -1) {
					tbAdminService.deleteByPrimaryKey(adminUserSeq);
					result.setCode("0000");
				}
				else {
					result.setCode("0001");
				}
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
	

	// region 설명: 사용자 등록 및 수정 블럭
	/**
	 * 2021-06-18 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value = "/update/block.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel updateAdminUserBlock(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel tbAdminUserModel) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = tbAdminUserModel.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				int adminUserSeq = tbAdminUserModel.getAdminUserSeq();
				if(adminUserSeq != -1) {
					if(adminUserSeq != 1) {			//최고 관리자 admin은 블럭 할 수 없음
						tbAdminService.updateByAdminUserBlock(tbAdminUserModel);
						result.setCode("0000");
					}
					else {
						result.setCode("9999");
						result.setErrorMessage("최고 관리자는 블럭 할 수 없습니다.");
					}
				}
				else {
					result.setCode("0002");
					result.setErrorMessage("관리자 정보를 조회 할 수 없습니다.");
				}
			}else {
				result.setCode("0001");
				result.setErrorMessage("비밀번호가 다릅니다.");
			}
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage("비밀번호가 다릅니다.");
		}
		return result;
	}
	// end region



	// region 설명: 프로그램 수정 페이지 불러오기 
	/**
	 * 2021-08-12 Made by Duhyun, Kim
	 * @param args
	 * return : ModelAndView
	 */
	@RequestMapping(value="/log.do")
	public ModelAndView viewLoghistory(HttpServletRequest request, HttpServletResponse responsee, HttpSession session) {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/log");
		model.addObject("leftPageUrl", "admin/log");
		return model;
	}
	// end region

	
	
	// region 설명: 사용자 등록 및 수정 불러오기
	/**
	 * 2021-08-12 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/select/log.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectLoghistory(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserLogModel tbAdminUserLog
		) {
		ResponseModel result = new ResponseModel();
		
		String startDate = tbAdminUserLog.getStartDate();
		String closeDate = tbAdminUserLog.getCloseDate();
		
		if(startDate!=null && closeDate!=null) {
			List<TbAdminUserLogModel> resultSet = tbAdminService.selectByPrimaryKey(startDate, closeDate);
			
			if(resultSet!=null) {
				try {
					//password 공개되지 않은 데이터를 돌려주기위함
					ObjectMapper mapper = new ObjectMapper();
					String strAdminUser = mapper.writeValueAsString(resultSet);
					result.setResult(strAdminUser);
					result.setCode("0000");
				} catch (Exception e) {
					log.error(e.getMessage());
				}
			}
			else {
				result.setCode("0001");
			}
		}
		else {
			result.setCode("0002");
		}
		return result;
	}
	
	//공통코드 조회
	@RequestMapping(value="/select/tCommon.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectTbCommon(HttpServletRequest request, HttpServletResponse response, HttpSession session
			,@RequestBody TCommonCodeModel record
			) {
		ResponseModel result = new ResponseModel();
		List<TCommonCodeModel> resultSet = tbAdminService.selectAllTbCommonCode(record);
		if(resultSet!=null) {
			try {
				int i = 0;
				for(TCommonCodeModel code : resultSet) {
					code.setSeq(i);
					i++;
				}
				ObjectMapper mapper = new ObjectMapper();
				String strLeftMenu = mapper.writeValueAsString(resultSet);
				result.setResult(strLeftMenu);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		else {
			
			result.setCode("0001");
		}
		return result;
	}
	
	//공통코드그룹 조회
	@RequestMapping(value="/select/tCommonCodeGroup.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectCodeGroup(HttpServletRequest request, HttpServletResponse response, HttpSession session
			,@RequestBody TCommonCodeModel record
			) {
		ResponseModel result = new ResponseModel();
		List<TCommonCodeModel> resultSet = tbAdminService.selectCodeGroup();
		if(resultSet!=null) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				String data = mapper.writeValueAsString(resultSet);
				result.setResult(data);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		else {
			
			result.setCode("0001");
		}
		return result;
	}

	
	
	//공통코드 추가
	@RequestMapping(value = "/insert/tCommon.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel insertTbCommon(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TCommonCodeModel commonCodeModel) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = commonCodeModel.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				commonCodeModel.setInsSeq(sessionModel.getAdminUserSeq());
				tbAdminService.insertTCommonCode(commonCodeModel);
				result.setCode("0000");
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0002");
		}
		return result;
	}
	//공통코드 수정
	@RequestMapping(value = "/update/tCommon.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel updateTbCommon(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TCommonCodeModel commonCodeModel) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			String userId = sessionModel.getUserId();
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			String password = commonCodeModel.getPassword();
			tbAdminUser.setPassword(password);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
			
			if(resultSet!=null) {
				String codeGroup = commonCodeModel.getCodeGroup();
				String codeValue = commonCodeModel.getCodeValue();
				if(!codeGroup.equals("")&&!codeValue.equals("")) {
					commonCodeModel.setInsSeq(sessionModel.getAdminUserSeq());
					tbAdminService.updateByTbCommonCodePrimaryKey(commonCodeModel);
					result.setCode("0000");
				}
				else {
					result.setCode("0001");
				}
			}else {
				result.setCode("0001");
			}
		} catch (Exception e) {
			result.setCode("0002");
		}
		return result;
	}
	
	//공통코드 삭제
	@RequestMapping(value = "/delete/tCommon.do", method = RequestMethod.POST
		, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
		@ResponseBody
		public ResponseModel deleteTbCommon(HttpServletRequest request, HttpServletResponse response, HttpSession session
				, @RequestBody TCommonCodeModel commonCodeModel) {
			ResponseModel result = new ResponseModel();
			try {
				SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
				String userId = sessionModel.getUserId();
				TbAdminUserModel tbAdminUser = new TbAdminUserModel();
				tbAdminUser.setUserId(userId);
				String password = commonCodeModel.getPassword();
				tbAdminUser.setPassword(password);
				TbAdminUserModel resultSet = tbAdminService.selectByAdminUserIdAndPassword(tbAdminUser);
				
				if(resultSet!=null) {
					String codeGroup = commonCodeModel.getCodeGroup();
					String codeValue = commonCodeModel.getCodeValue();
					if(!codeGroup.equals("")) {
						tbAdminService.deleteByTCommonCodePrimaryKey(codeGroup, codeValue);
						result.setCode("0000");
					}
					else {
						result.setCode("0001");
					}
				}else {
					result.setCode("0001");
				}
			} catch (Exception e) {
				result.setCode("0001");
			}
			return result;
		}
	// end region
}