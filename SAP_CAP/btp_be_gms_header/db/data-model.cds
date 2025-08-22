namespace btp.g;

using {
    managed
} from '@sap/cds/common';

entity GMS_HEADER {
    key Magms       : String(15);
        htms        : String(30);
        hscg        : String(30);
        ptms        : String(30);
        note        : String(255);
        TLINE       : Composition of many TLINE
                          on TLINE.GMS_HEADER = $self;
        PDF         : Composition of many PDF
                          on PDF.GMS_HEADER = $self;
        GMS_XL_USER : Composition of one GMS_XL_USER
                          on GMS_XL_USER.GMS_HEADER = $self;
        GMS_XL_data : Composition of many GMS_XL_data
                          on GMS_XL_data.GMS_HEADER = $self;
}

entity TLINE {
    key manhomcv   : Integer ;
        tennhomcv  : String(60);
        begda      : Date;
        endda      : Date;
    key GMS_HEADER : Association to GMS_HEADER;
}

entity PDF : managed {
    key end_user   : managed:createdBy;
    key file_id    : UUID;
        attachment : LargeBinary @Core.MediaType: mimetype @Core.ContentDisposition.Filename: filename @Core.ContentDisposition.Type: 'inline' @Core.AcceptableMediaTypes: ['application/pdf'];
        mimetype   : String(128) @Core.IsMediaType;
        filename   : String(128);
        GMS_HEADER : Association to GMS_HEADER;
}

entity GMS_XL_USER : managed {
    key end_user    : managed:createdBy;
    key file_id     : UUID;
        attachment : LargeBinary @Core.MediaType: mimetype @Core.ContentDisposition.Filename: filename @Core.ContentDisposition.Type: 'inline' @Core.AcceptableMediaTypes: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'];
        mimetype   : String(128) @Core.IsMediaType;
        filename    : String(128);
        GMS_XL_data : Composition of many GMS_XL_data
                          on GMS_XL_data.GMS_XL_USER = $self;
        GMS_HEADER  : Association to GMS_HEADER;
}

entity GMS_XL_data {
    key end_user      : managed:createdBy;
    key file_id       : UUID;
    key line_id       : UUID;
    key line_no       : Integer;
        product_name  : String(40);
        product_group : String(10);
        quantity      : Integer;
        unit          : String(3);
        price         : Decimal(15, 2);
        total_price   : Decimal(15, 2);
        currency      : String;
        GMS_HEADER    : Association to GMS_HEADER ;
        GMS_XL_USER   : Association to GMS_XL_USER ;
}
