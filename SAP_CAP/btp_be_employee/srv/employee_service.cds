using btp.j as bj from '../db/data-model';

service EmployeeServices {

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
    })                as 
    // select from 
    projection on
    bj.EMPLOYEE_REGISTRY;

    annotate Employees with @odata.draft.enabled;


    // @readonly
    entity Department as 
    // select from
projection on
     bj.DEPARTMENT;

    annotate Department with @odata.draft.enabled;

}

annotate EmployeeServices.Employees with @(
    UI: {
    SelectionFields    : [
        DEPARTMENT_ID,
        NAME,
        EMAIL_ID
    ],
    LineItem           : [
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
            Value: DEPARTMENT_ID,
        },
    ],
    LineItem #Child          : [
        {
            $Type: 'UI.DataField',
            Value: DEPARTMENT.ID
        },
        {
            $Type: 'UI.DataField',
            Value: DEPARTMENT.NAME
        },
    ],
    HeaderInfo         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employees',
        TypeNamePlural: 'Employees',
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
            Target: '@UI.LineItem#Child',
            ID    : 'Department',
            Label : 'Department',
        },
    ],
    FieldGroup #Default: {
        $Type: 'UI.FieldGroupType',
        Data : [
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
                Value: DEPARTMENT_ID,
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
    NAME       @title: 'Name';
    EMAIL_ID   @title: 'Email ID';
    DEPARTMENT @(
        title : 'Department',
        Common: {
            ValueListWithFixedValues,
            ValueList: {
                $Type         : 'Common.ValueListType',
                CollectionPath: 'Department',
                Label         : 'Departments',
                Parameters    : [
                    {
                        $Type            : 'Common.ValueListParameterOut',
                        LocalDataProperty: DEPARTMENT_ID,
                        ValueListProperty: 'ID',
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'NAME',
                    },
                ]
            },
        }
    );
}