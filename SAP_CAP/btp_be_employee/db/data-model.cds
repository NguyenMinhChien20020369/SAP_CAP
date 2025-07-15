namespace btp.j;

using {
    cuid,
    managed
} from '@sap/cds/common';

// entity DEPARTMENT : managed {
//     key ID: UUID;
//     NAME : String(255);
//     Employees : Composition of many EMPLOYEE_REGISTRY on Employees.Department = $self;
// }

// entity EMPLOYEE_REGISTRY {
//     key ID: UUID;
//     NAME : String(255);
//     EMAIL_ID : String(255);
//     Department_ID : String(255) @readonly;
//     Department : Association to DEPARTMENT on Department.ID = Department_ID;
// }

entity DEPARTMENT : managed {
    key ID        : UUID;
        NAME      : String(255);
        Employees : Composition of many EMPLOYEE_REGISTRY
                        on Employees.Department = $self;
}

entity EMPLOYEE_REGISTRY {
    key ID         : UUID;
        NAME       : String(255);
        EMAIL_ID   : String(255);
        Department : Association to DEPARTMENT @readonly @Core.Immutable;
}
