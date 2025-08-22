const cds = require('@sap/cds')
const { uuid } = cds.utils
const XLSX = require('xlsx');

let GLOBAL_ATTACHMENT = 'null';
let GLOBAL_MIMETYPE = null;
let GLOBAL_FILENAME = null;
let GLOBAL_PDFS = null;

module.exports = cds.service.impl(srv => {
  srv.before('READ', 'GMS_HEADER', async (req) => {
    console.log('11111', req);
    // if (req.subject.ref[0].where != undefined && req.subject.ref[0].where.length == 3) {
    if (GLOBAL_ATTACHMENT != 'null') {
      // var buffer = null;
      // var base64 = null;
      // if (GLOBAL_ATTACHMENT != null) {
      //   buffer = Buffer.from(GLOBAL_ATTACHMENT); // từ object {type: "Buffer", data: [...]}
      //   base64 = buffer.toString('binary');
      // }
      await cds.transaction(req).run(`
        UPDATE "btp_g_GMS_XL_USER"
        SET "attachment" = ?, "filename" = ?, "mimetype" = ? 
        where "GMS_HEADER_Magms" = ?
        `, [GLOBAL_ATTACHMENT, GLOBAL_FILENAME,
        GLOBAL_MIMETYPE, req.subject.ref[0].where[2].val]
      );
      GLOBAL_ATTACHMENT = 'null';
    }
    if (GLOBAL_PDFS != null) {
      GLOBAL_PDFS.forEach(async (PDF) => {
        const buffer = Buffer.from(PDF.attachment); // từ object {type: "Buffer", data: [...]}
        const base64 = buffer.toString('binary');
        await cds.transaction(req).run(`
            UPDATE "btp_g_PDF"
            SET "attachment" = ?, "filename" = ?, "mimetype" = ? 
            where "GMS_HEADER_Magms" = ? and "file_id" = ?
            `, [base64, PDF.filename, PDF.mimetype, req.subject.ref[0].where[2].val, PDF.file_id]
        );
      });
      GLOBAL_PDFS = null;
    }
    // }
  })

  srv.before('READ', 'GMS_HEADER.drafts', async (req) => {

  })

  srv.before('READ', 'TLINE.drafts', async (req) => {
    console.log('11111', req);
    // req.data.Department_ID = req.params[0].ID;

    // if (req.params[0].manhomcv == 4) {
    //   return;
    // }

    const existPDFs = await cds.transaction(req).run(`
      SELECT "file_id", "attachment"
      from "GMSHeaderServices_PDF"
      where "GMS_HEADER_Magms" = ?
      `, [req.params[0].Magms]
    );

    existPDFs.forEach(async (PDF) => {
      await cds.transaction(req).run(`
        UPDATE "GMSHeaderServices_PDF_drafts"
        SET "attachment" = ?
        where "GMS_HEADER_Magms" = ? and "file_id" = ?
        `, [PDF.attachment, req.params[0].Magms, PDF.file_id]
      );
    });

    const existNext = await cds.transaction(req).run(`
      SELECT "attachment"
      from "GMSHeaderServices_GMS_XL_USER"
      where "GMS_HEADER_Magms" = ?
      `, [req.params[0].Magms]
    );

    if (existNext.length > 0) {

      await cds.transaction(req).run(`
        UPDATE "GMSHeaderServices_GMS_XL_USER_drafts"
        SET "attachment" = ?
        where "GMS_HEADER_Magms" = ? and mimetype is not null
        `, [existNext[0].attachment, req.params[0].Magms]
      );
      return;
    }

    const exists = await cds.transaction(req).run(`
      SELECT "DraftAdministrativeData_DraftUUID"
      from "GMSHeaderServices_GMS_HEADER_drafts"
      where "Magms" = ?
      `, [req.params[0].Magms]
    );
    // var TENNHOMCV;
    // if ((req.data.endda != null && exists[0].begda != null) || (req.data.begda != null && exists[0].endda != null)) {
    //   switch (req.params[0].manhomcv) {
    //     case 1:
    //       TENNHOMCV = 'Phê duyệt kết quả chấm điểm NCC'
    //       break;
    //     case 2:
    //       TENNHOMCV = 'Phê duyệt chọn NCC, giá và điều khoản'
    //       break;
    //     case 3:
    //       TENNHOMCV = 'Ký hợp đồng'
    //       break;

    //     default:
    //       break;
    //   }

    await cds.transaction(req).run(
      INSERT.into('GMSHeaderServices_GMS_XL_USER_drafts').entries({
        file_id: uuid(),
        end_user: 'anonymous',
        HasActiveEntity: 0,
        DraftAdministrativeData_DraftUUID: exists[0].DraftAdministrativeData_DraftUUID,
        GMS_HEADER_Magms: req.data.GMS_HEADER_Magms
      })
    );

    // console.log('22222', req);
    // }
  })

  srv.before('UPDATE', 'GMS_HEADER', async (req) => {
    console.log('11111', req);

    await cds.transaction(req).run(`
      Delete
      from "btp_g_GMS_XL_DATA"
      where "GMS_HEADER_magms" = ?
      `, req.subject.ref[0].where[2].val
    );

    const exists = await cds.transaction(req).run(`
      SELECT "attachment", "filename", "mimetype"
      from "GMSHeaderServices_gms_xl_user_drafts"
      where "GMS_HEADER_Magms" = ?
      `, req.subject.ref[0].where[2].val
    );
    if (exists.length > 0) {
      GLOBAL_ATTACHMENT = exists[0].attachment
      GLOBAL_FILENAME = exists[0].filename
      GLOBAL_MIMETYPE = exists[0].mimetype
    }
    const existPDFs = await cds.transaction(req).run(`
      SELECT "file_id", "attachment", "filename", "mimetype"
      from "GMSHeaderServices_PDF_drafts"
      where "GMS_HEADER_Magms" = ?
      `, req.subject.ref[0].where[2].val
    );
    if (existPDFs.length > 0) {
      GLOBAL_PDFS = existPDFs
    }
  })

  srv.before('UPDATE', 'TLINE.drafts', async (req) => {
    console.log('11111', req);
    // req.data.Department_ID = req.params[0].ID;

    if (req.params[0].manhomcv == 4) {
      return;
    }

    const existNext = await cds.transaction(req).run(`
      SELECT "begda"
      from "GMSHeaderServices_TLINE_drafts"
      where "GMS_HEADER_Magms" = ? and "manhomcv" = ?
      `, [req.params[0].GMS_HEADER_Magms, req.params[0].manhomcv + 1]
    );

    if (existNext.length > 0) {
      return;
    }

    const exists = await cds.transaction(req).run(`
      SELECT "begda", "endda", "DraftAdministrativeData_DraftUUID"
      from "GMSHeaderServices_TLINE_drafts"
      where "GMS_HEADER_Magms" = ? and "manhomcv" = ?
      `, [req.params[0].GMS_HEADER_Magms, req.params[0].manhomcv]
    );
    var TENNHOMCV;
    if ((req.data.endda != null && exists[0].begda != null) || (req.data.begda != null && exists[0].endda != null)) {
      switch (req.params[0].manhomcv) {
        case 1:
          TENNHOMCV = 'Phê duyệt kết quả chấm điểm NCC'
          break;
        case 2:
          TENNHOMCV = 'Phê duyệt chọn NCC, giá và điều khoản'
          break;
        case 3:
          TENNHOMCV = 'Ký hợp đồng'
          break;

        default:
          break;
      }

      await cds.transaction(req).run(
        INSERT.into('GMSHeaderServices_TLINE_drafts').entries({
          manhomcv: req.params[0].manhomcv + 1,
          tennhomcv: TENNHOMCV,
          HasActiveEntity: 0,
          DraftAdministrativeData_DraftUUID: exists[0].DraftAdministrativeData_DraftUUID,
          GMS_HEADER_magms: req.params[0].GMS_HEADER_Magms
        })
      );
    }
  })

  async function streamToBuffer(stream) {
    const chunks = [];
    for await (const chunk of stream) {
        chunks.push(chunk);
    }
    return Buffer.concat(chunks);
}

  srv.before('UPDATE', 'GMS_XL_USER.drafts', async (req) => {
    console.log('11111', req);

    if (req.data.attachment == null && req.data.filename == null) {
      req.data.mimetype = null;
      req.data.filename = null;

      await cds.transaction(req).run(`
        Delete
        from "GMSHeaderServices_GMS_XL_DATA_drafts"
        where "file_id" = ?
        `, req.subject.ref[0].where[6].val
      );
    } else if (req.data.attachment != null && req.data.filename == null) {
      const buffer = await streamToBuffer(req.data.attachment);
      const base64 = buffer.toString('base64');
      req.data.attachment = base64;
    }
  })

  srv.before('NEW', 'GMSHeaderServices.GMS_XL_data.drafts', async (req) => {
    console.log('11111', req);

    req.data.file_id = '00000000-0000-0000-0000-000000000000';
  })

  srv.on('addReview', async (req) => {
    const existNext = await cds.transaction(req).run(`
      SELECT "begda"
      from "GMSHeaderServices_TLINE_drafts"
      where "GMS_HEADER_Magms" = ? and "manhomcv" = ?
      `, [req.params[0].Magms, 1]
    );

    if (existNext.length > 0) {
      return;
    }

    const exists = await cds.transaction(req).run(`
      SELECT "DraftAdministrativeData_DraftUUID" 
      from "GMSHeaderServices_GMS_HEADER_drafts"
      where "Magms" = ?
      `, req.params[0].Magms
    );

    await cds.transaction(req).run(
      INSERT.into('GMSHeaderServices_TLINE_drafts').entries({
        manhomcv: '1',
        tennhomcv: 'Phê duyệt đầu bài',
        HasActiveEntity: 0,
        DraftAdministrativeData_DraftUUID: exists[0].DraftAdministrativeData_DraftUUID,
        GMS_HEADER_magms: req.params[0].Magms
      })
    );
  });

  srv.on('uploadData', async (req) => {

    const existNext = await cds.transaction(req).run(`
      SELECT "attachment", "file_id"
      from "GMSHeaderServices_GMS_XL_USER_drafts"
      where "GMS_HEADER_Magms" = ?
      `, [req.params[0].Magms]
    );

    if (existNext.length > 0) {

      // Đọc workbook từ buffer
      const workbook = XLSX.read(existNext[0].attachment, { type: 'base64' });

      // Lấy danh sách sheet
      const sheetNames = workbook.SheetNames;

      // Đọc nội dung sheet đầu tiên
      const sheet = workbook.Sheets[sheetNames[0]];

      // Chuyển sheet thành JSON
      const dataList = XLSX.utils.sheet_to_json(sheet, { header: 1 });

      const exists = await cds.transaction(req).run(`
        SELECT "DraftAdministrativeData_DraftUUID" 
        from "GMSHeaderServices_GMS_HEADER_drafts"
        where "Magms" = ?
        `, req.params[0].Magms
      );

      await cds.transaction(req).run(`
        Delete
        from "GMSHeaderServices_GMS_XL_DATA_drafts"
        where "GMS_HEADER_magms" = ? and "file_id" <> ?
        `, [req.params[0].Magms, "00000000-0000-0000-0000-000000000000"]
      );

      const idMax = await cds.transaction(req).run(`
        SELECT max("line_no") as idMax
        from "GMSHeaderServices_GMS_XL_data_drafts"
        where "GMS_HEADER_Magms" = ?
        `, [req.params[0].Magms]
      );

      for (let i = 1; i < dataList.length; i++) {
        const element = dataList[i];
        if (element.length > 0) {
          await cds.transaction(req).run(
            INSERT.into('GMSHeaderServices_GMS_XL_DATA_drafts').entries({
              file_id: existNext[0].file_id,
              end_user: 'anonymous',
              line_id: uuid(),
              line_no: idMax[0].idMax + i,
              product_name: element[0],
              product_group: element[1],
              quantity: element[2],
              unit: element[3],
              price: element[4],
              total_price: element[5],
              currency: element[6],
              HasActiveEntity: 0,
              DraftAdministrativeData_DraftUUID: exists[0].DraftAdministrativeData_DraftUUID,
              GMS_HEADER_magms: req.params[0].Magms
            })
          );
        }
      }
    }
  });

  srv.before('*', async (req) => {
    console.log('11111', req);
  });
})