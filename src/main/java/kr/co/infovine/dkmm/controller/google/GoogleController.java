package kr.co.infovine.dkmm.controller.google;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.service.store.OperationStoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping(value = "/google")
public class GoogleController {
    @Autowired
    OperationStoreService operationStoreService;

    @RequestMapping(value="/place.do")
    public ModelAndView mainPage(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView model = new ModelAndView();
        model.addObject("leftPageUrl", "store/store");
        TStoreInfoModel storeInfo = new TStoreInfoModel();
        model.addObject("storeCount", operationStoreService.selectStoreCount(storeInfo) );
        model.setViewName("google/place");
        return model;
    }

}
