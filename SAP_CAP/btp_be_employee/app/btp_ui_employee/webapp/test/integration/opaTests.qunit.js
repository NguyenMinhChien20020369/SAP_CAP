sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'btpuiemployee/test/integration/FirstJourney',
		'btpuiemployee/test/integration/pages/DepartmentList',
		'btpuiemployee/test/integration/pages/DepartmentObjectPage',
		'btpuiemployee/test/integration/pages/EmployeesObjectPage'
    ],
    function(JourneyRunner, opaJourney, DepartmentList, DepartmentObjectPage, EmployeesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('btpuiemployee') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheDepartmentList: DepartmentList,
					onTheDepartmentObjectPage: DepartmentObjectPage,
					onTheEmployeesObjectPage: EmployeesObjectPage
                }
            },
            opaJourney.run
        );
    }
);