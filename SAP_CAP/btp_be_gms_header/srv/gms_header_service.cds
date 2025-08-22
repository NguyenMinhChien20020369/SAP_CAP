using btp.g as bg from '../db/data-model';

service GMSHeaderServices @(impl: 'srv/gms_h_service.js') {

    entity GMS_HEADER @(Capabilities: {
        InsertRestrictions: {
            $Type: 'Capabilities.InsertRestrictionsType',
            Insertable,
        },
        UpdateRestrictions: {
            $Type: 'Capabilities.UpdateRestrictionsType',
            Updatable,
        },
        DeleteRestrictions: {
            $Type: 'Capabilities.DeleteRestrictionsType',
            Deletable,
        },
    })          as projection on bg.GMS_HEADER
        actions {
            @(
                cds.odata.bindingparameter.name: '_it',
                Common.SideEffects             : {TargetEntities: ['_it']}
            )
            @Core.OperationAvailable: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: '_it/IsActiveEntity'},
                    true
                ]},
                false,
                true
            ]}}
            action addReview();
            @(
                cds.odata.bindingparameter.name: '_it',
                Common.SideEffects             : {TargetEntities: ['_it/GMS_XL_data']}
            )
            @Core.OperationAvailable: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: '_it/IsActiveEntity'},
                    true
                ]},
                false,
                true
            ]}}
            action uploadData();
        };

    annotate GMS_HEADER with @odata.draft.enabled;

    annotate GMSHeaderServices.GMS_HEADER @(Common: {SideEffects #TLINEChanged: {
        SourceEntities: [TLINE],
        TargetEntities: [TLINE]
    },
    SideEffects #PDFChanged: {
        SourceEntities: [PDF],
        TargetEntities: [PDF]
    },
    SideEffects #GMS_XL_USERChanged: {
        SourceEntities: [GMS_XL_USER],
        TargetEntities: [GMS_XL_USER, GMS_XL_data]
    },
    });

    entity TLINE
                // @(Capabilities: {
                //     // InsertRestrictions: {
                //     //     $Type: 'Capabilities.InsertRestrictionsType',
                //     //     Insertable,
                //     // },
                //     UpdateRestrictions: {
                //         $Type: 'Capabilities.UpdateRestrictionsType',
                //         Updatable,
                //     },
                //     // DeleteRestrictions: {
                //     //     $Type: 'Capabilities.DeleteRestrictionsType',
                //     //     Deletable,
                //     // },
                // })
                as projection on bg.TLINE;

    entity PDF @(Capabilities: {
        InsertRestrictions: {
            $Type: 'Capabilities.InsertRestrictionsType',
            Insertable,
        },
        UpdateRestrictions: {
            $Type: 'Capabilities.UpdateRestrictionsType',
            Updatable,
        },
        DeleteRestrictions: {
            $Type: 'Capabilities.DeleteRestrictionsType',
            Deletable,
        },
    })          as projection on bg.PDF order by createdAt asc;

    entity GMS_XL_USER @(Capabilities: {
        InsertRestrictions: {
            $Type: 'Capabilities.InsertRestrictionsType',
            Insertable,
        },
        UpdateRestrictions: {
            $Type: 'Capabilities.UpdateRestrictionsType',
            Updatable,
        },
        DeleteRestrictions: {
            $Type: 'Capabilities.DeleteRestrictionsType',
            Deletable,
        },
    })          as projection on bg.GMS_XL_USER;

    entity GMS_XL_data @(Capabilities: {
        InsertRestrictions: {
            $Type: 'Capabilities.InsertRestrictionsType',
            Insertable,
        },
        UpdateRestrictions: {
            $Type: 'Capabilities.UpdateRestrictionsType',
            Updatable,
        },
        DeleteRestrictions: {
            $Type: 'Capabilities.DeleteRestrictionsType',
            Deletable,
        },
    })          as projection on bg.GMS_XL_data order by line_no asc;

}

annotate GMSHeaderServices.GMS_HEADER with @(UI: {
    SelectionFields: [Magms],
    LineItem       : [
        {
            $Type: 'UI.DataField',
            Value: Magms,
        },
        {
            $Type: 'UI.DataField',
            Value: htms,
        },
        {
            $Type: 'UI.DataField',
            Value: hscg,
        },
        {
            $Type: 'UI.DataField',
            Value: ptms,
        },
    ],
    Identification : [
        {
            $Type: 'UI.DataField',
            Value: Magms,
        },
        {
            $Type: 'UI.DataField',
            Value: htms,
        },
        {
            $Type: 'UI.DataField',
            Value: hscg,
        },
        {
            $Type: 'UI.DataField',
            Value: ptms,
        },
        {
            $Type: 'UI.DataField',
            Value: note,
        },
        {
            $Type             : 'UI.DataFieldForAction',
            Action            : 'GMSHeaderServices.addReview',
            Label             : 'Pick Date',
            InvocationGrouping: #Isolated,
            Criticality       : #Positive
        },
        {
            $Type             : 'UI.DataFieldForAction',
            Action            : 'GMSHeaderServices.uploadData',
            Label             : 'Upload Data',
            InvocationGrouping: #Isolated,
            Criticality       : #Positive
        }
    ],
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Department',
        TypeNamePlural: 'Departments',
        Title         : {
            $Type: 'UI.DataField',
            Value: Magms,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: htms,
        },
    },
    Facets         : [
        // {
        //     $Type : 'UI.ReferenceFacet',
        //     Target: '@UI.FieldGroup#Default',
        //     ID    : 'Default',
        //     Label : 'General',
        // },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.Identification',
            ID    : 'GMSHeader',
            Label : 'GMS Header',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'TLINE/@UI.LineItem',
            ID    : 'Timeline',
            Label : 'Timeline',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'PDF/@UI.LineItem',
            ID    : 'Attachment',
            Label : 'Attachment',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'GMS_XL_USER/@UI.Identification',
            ID    : 'UploadItem',
            Label : 'Upload item',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'GMS_XL_data/@UI.LineItem',
            ID    : 'ItemsDetail',
            Label : 'Items Detail',
        },
    ],
// FieldGroup #Default: {
//     $Type: 'UI.FieldGroupType',
//     Data : [
//         {
//             $Type: 'UI.DataField',
//             Value: Magms,
//         },
//         {
//             $Type: 'UI.DataField',
//             Value: htms,
//         }
//     ]
// },
}) {
    Magms @title: 'Mã gói mua sắm';
    htms  @title: 'Hình thức mua sắm';
    hscg  @title: 'HT Mở hồ sơ chào giá';
    ptms  @title: 'Phương thức mua sắm';
    note  @title: 'Ghi chú';
}

annotate GMSHeaderServices.TLINE with @(UI: {
    CreateHidden   : true,
    DeleteHidden   : true,
    SelectionFields: [manhomcv],
    LineItem       : [
        {
            $Type            : 'UI.DataField',
            Value            : GMS_HEADER_Magms,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : manhomcv,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : tennhomcv,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : begda,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : endda,
            ![@UI.Importance]: #High,
        }
    ],

    Identification : [
        {
            $Type            : 'UI.DataField',
            Value            : GMS_HEADER_Magms,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : manhomcv,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : tennhomcv,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : begda,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : endda,
            ![@UI.Importance]: #High,
        },
    ],
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Timeline',
        TypeNamePlural: 'Timelines',
    // Title         : {
    //     $Type: 'UI.DataField',
    //     Value: NAME,
    // },
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: ID,
    // },
    },
    Facets         : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.Identification',
        ID    : 'Employee',
        Label : 'Employee',
    }, ],


}) {
    GMS_HEADER @title: 'Mã gói mua sắm';
    manhomcv   @title: 'Mã nhóm công việc';
    tennhomcv  @title: 'Tên nhóm công việc';
    begda      @(title: 'Start Date',

    // Common: {
    //     ValueListWithFixedValues,
    //     ValueList: {
    //         $Type         : 'Common.ValueListType',
    //         CollectionPath: 'Department',
    //         Label         : 'Departments',
    //         Parameters    : [
    //             {
    //                 $Type            : 'Common.ValueListParameterOut',
    //                 LocalDataProperty: DEPARTMENT_ID,
    //                 ValueListProperty: 'ID',
    //             },
    //             {
    //                 $Type            : 'Common.ValueListParameterDisplayOnly',
    //                 ValueListProperty: 'NAME',
    //             },
    //         ]
    //     },
    // }
    );
    endda      @title: 'End Date';
}

annotate GMSHeaderServices.PDF with @(UI: {
    SelectionFields: [file_id],
    LineItem       : [
        {
            $Type            : 'UI.DataField',
            Value            : file_id,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : end_user,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : GMS_HEADER_Magms,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : attachment,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : filename,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : modifiedAt,
            ![@UI.Importance]: #High,
        },
    ],

    Identification : [
        {
            $Type: 'UI.DataField',
            Value: file_id,
        },
        {
            $Type: 'UI.DataField',
            Value: end_user,
        },
        {
            $Type: 'UI.DataField',
            Value: attachment,
        },
        {
            $Type: 'UI.DataField',
            Value: mimetype,
        },
    ],
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
    // Title         : {
    //     $Type: 'UI.DataField',
    //     Value: NAME,
    // },
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: ID,
    // },
    },
// Facets         : [{
//     $Type : 'UI.ReferenceFacet',
//     Target: '@UI.Identification',
//     ID    : 'Employee',
//     Label : 'Employee',
// }, ],


}) {
    GMS_HEADER @title: 'Mã gói mua sắm';
    file_id    @title: 'File ID';
    end_user   @title: 'User Name';
    attachment @(title: 'Select Pdf File to Upload',
    );
    filename   @title: 'File name';
    modifiedAt @title: 'Changed On';
}

annotate GMSHeaderServices.GMS_XL_USER with @(UI: {
    SelectionFields: [file_id],
    LineItem       : [
        {
            $Type            : 'UI.DataField',
            Value            : file_id,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : end_user,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : GMS_HEADER_Magms,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : attachment,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : filename,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : modifiedAt,
            ![@UI.Importance]: #High,
        },
    ],

    Identification : [
        {
            $Type: 'UI.DataField',
            Value: file_id,
        },
        {
            $Type: 'UI.DataField',
            Value: end_user,
        },
        {
            $Type: 'UI.DataField',
            Value: attachment,
        },
        {
            $Type: 'UI.DataField',
            Value: mimetype,
        },
    ],
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
    // Title         : {
    //     $Type: 'UI.DataField',
    //     Value: NAME,
    // },
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: ID,
    // },
    },
// Facets         : [{
//     $Type : 'UI.ReferenceFacet',
//     Target: '@UI.Identification',
//     ID    : 'Employee',
//     Label : 'Employee',
// }, ],


}) {
    GMS_HEADER @title: 'Mã gói mua sắm';
    file_id    @title: 'File ID';
    end_user   @title: 'User Name';
    attachment @(title: 'Select Pdf File to Upload',
    );
    filename   @title: 'File name';
    modifiedAt @title: 'Changed On';
}

annotate GMSHeaderServices.GMS_XL_data with @(UI: {
    SelectionFields                        : [file_id],
    // PresentationVariant #Eval_by_Country: {
    //     // GroupBy       : [Country],
    //     SortOrder     : [{
    //         Property  : line_no,
    //         Descending: false
    //     }, ],
    //     Visualizations: ['@UI.LineItem']
    // },
    LineItem                               : [
        {
            $Type            : 'UI.DataField',
            Value            : line_no,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : line_id,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : file_id,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : end_user,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : GMS_HEADER_Magms,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : product_name,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : product_group,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : quantity,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : unit,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : price,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : total_price,
            ![@UI.Importance]: #High,
        },
        {
            $Type            : 'UI.DataField',
            Value            : currency,
            ![@UI.Importance]: #High,
        },
    ],

    // Identification : [
    //     {
    //         $Type: 'UI.DataField',
    //         Value: file_id,
    //     },
    //     {
    //         $Type: 'UI.DataField',
    //         Value: end_user,
    //     },
    //     {
    //         $Type: 'UI.DataField',
    //         Value: attachment,
    //     },
    //     {
    //         $Type: 'UI.DataField',
    //         Value: mimetype,
    //     },
    // ],
    HeaderInfo                             : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
    // Title         : {
    //     $Type: 'UI.DataField',
    //     Value: NAME,
    // },
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: ID,
    // },
    },
// Facets         : [{
//     $Type : 'UI.ReferenceFacet',
//     Target: '@UI.Identification',
//     ID    : 'Employee',
//     Label : 'Employee',
// }, ],


}) {
    GMS_HEADER @title: 'Mã gói mua sắm';
    file_id    @title: 'File ID';
    end_user   @title: 'User Name';
    line_no @title: 'Line Number';
    line_id @title: 'Line ID';
    product_name @title: 'Product Name';
    product_group    @title: 'Product Group';
    quantity   @title: 'Quantity';
    unit @title: 'Unit';
    price @title: 'Price';
    total_price   @title: 'Total Price';
    currency @title: 'Currency';
}
