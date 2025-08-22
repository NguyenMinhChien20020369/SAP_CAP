using btp.j as bj from '../db/data-model';

service EmployeeServices @(impl: 'srv/emp_service.js') {

    entity Employees @(Capabilities: {
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
    }) as
         // select from
             projection on bj.EMPLOYEE_REGISTRY;

    // annotate Employees with @odata.draft.enabled;


    // @readonly
    entity Department @(Capabilities: {
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
    }) as
         // select from
             projection on bj.DEPARTMENT
       {
        ID,
        NAME,
        Employees : redirected to Employees
       }
    ;

    annotate Department with @odata.draft.enabled;

}

annotate EmployeeServices.Employees with @(UI: {
    SelectionFields: [
        NAME,
        EMAIL_ID
    ],
    LineItem       : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: EMAIL_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: Department_ID,
        },
    ],

    Identification : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: EMAIL_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: Department_ID,
        },
    ],
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
        Title         : {
            $Type: 'UI.DataField',
            Value: NAME,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: ID,
        },
    },
    Facets         : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.Identification',
        ID    : 'Employee',
        Label : 'Employee',
    }, ],


}) {
    ID         @title: 'ID';
    NAME       @title: 'Name';
    EMAIL_ID   @title: 'Email ID';
    Department @(title: 'Department ID',

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
}

annotate EmployeeServices.Department with @(UI: {
    SelectionFields    : [
        ID,
        NAME
    ],
    LineItem           : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: NAME,
        },
    ],
    // LineItem #Child    : [
    //     {
    //         // $Type: 'UI.DataField',
    //         Value: Employees.ID
    //     },
    //     {
    //         // $Type: 'UI.DataField',
    //         Value: Employees.NAME
    //     },
    //     {
    //         // $Type: 'UI.DataField',
    //         Value: Employees.EMAIL_ID
    //     },
    //     {
    //         // $Type: 'UI.DataField',
    //         Value: Employees.Department_ID
    //     },
    // ],
    HeaderInfo         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Department',
        TypeNamePlural: 'Departments',
        Title         : {
            $Type: 'UI.DataField',
            Value: NAME,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: ID,
        },
    },
    Facets             : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Default',
            ID    : 'Default',
            Label : 'General',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Admin',
            ID    : 'AdminData',
            Label : 'Administrative Data',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'Employees/@UI.LineItem',
            ID    : 'Employees',
            Label : 'Employees',
        },
    ],
    FieldGroup #Default: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Value: NAME,
            },
        ]
    },
    FieldGroup #Admin  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: createdAt,
            },
            {
                $Type: 'UI.DataField',
                Value: createdBy,
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedAt,
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedBy,
            },
        ]
    },
}) {
    ID   @title: 'ID';
    NAME @title: 'Name';
}
