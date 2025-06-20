using EmployeeServices as service from '../../srv/employee_service';

// annotate service.Employees with @(
//     UI.FieldGroup #GeneratedGroup : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'NAME',
//                 Value : NAME,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'EMAIL_ID',
//                 Value : EMAIL_ID,
//             },
//         ],
//     },
//     UI.Facets : [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID : 'GeneratedFacet1',
//             Label : 'General Information',
//             Target : '@UI.FieldGroup#GeneratedGroup',
//         },
//     ],
//     UI.LineItem : [
//         {
//             $Type : 'UI.DataField',
//             Label : 'NAME',
//             Value : NAME,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'EMAIL_ID',
//             Value : EMAIL_ID,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'EMAIL_ID',
//             Value : DEPARTMENT_ID,
//         },
//     ],
// );

// annotate service.Employees with {
//     DEPARTMENT 

//     @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         CollectionPath : 'Department',
//         Label : 'Currency',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : DEPARTMENT_ID,
//                 ValueListProperty : 'ID',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'NAME',
//             },
//         ],
//     }
// };

