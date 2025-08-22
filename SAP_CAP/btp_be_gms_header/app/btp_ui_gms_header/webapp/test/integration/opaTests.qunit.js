sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'btpuigmsheader/test/integration/FirstJourney',
		'btpuigmsheader/test/integration/pages/GMS_HEADERList',
		'btpuigmsheader/test/integration/pages/GMS_HEADERObjectPage',
		'btpuigmsheader/test/integration/pages/GMS_XL_dataObjectPage'
    ],
    function(JourneyRunner, opaJourney, GMS_HEADERList, GMS_HEADERObjectPage, GMS_XL_dataObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('btpuigmsheader') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheGMS_HEADERList: GMS_HEADERList,
					onTheGMS_HEADERObjectPage: GMS_HEADERObjectPage,
					onTheGMS_XL_dataObjectPage: GMS_XL_dataObjectPage
                }
            },
            opaJourney.run
        );
    }
);