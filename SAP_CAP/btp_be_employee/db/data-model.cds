namespace btp.j;

using { cuid, managed } from '@sap/cds/common';

entity EMPLOYEE_REGISTRY : cuid, managed {
    NAME : String(255);
    EMAIL_ID : String(255);
    DEPARTMENT : Association to one DEPARTMENT;
}

entity DEPARTMENT : cuid {
    NAME : String(255);

    Employees : Association to many EMPLOYEE_REGISTRY on Employees.DEPARTMENT = $self;
}