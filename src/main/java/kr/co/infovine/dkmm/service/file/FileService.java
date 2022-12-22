package kr.co.infovine.dkmm.service.file;

import kr.co.infovine.dkmm.db.model.file.TFileModel;
import kr.co.infovine.dkmm.db.model.file.TFileSubModel;

import java.util.List;

public interface FileService {
    int deleteFileByPrimaryKey(Integer fileSeq);

    int insertFile(TFileModel row);

    TFileModel selectFileByPrimaryKey(Integer fileSeq);

    List<TFileModel> selectAllFile();

    int updateFileByPrimaryKey(TFileModel row);

    int deleteFileSubByPrimaryKey(Integer fileSubSeq);

    int insertFileSub(TFileSubModel row);

    TFileSubModel selectFileSubByPrimaryKey(Integer fileSubSeq);

    List<TFileSubModel> selectAllFileSub();

    int updateFileSubByPrimaryKey(TFileSubModel row);

    int insertUploadFile(TFileModel row, TFileSubModel row2);
}
