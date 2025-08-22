sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'btpuigmsheader',
            componentId: 'GMS_XL_dataObjectPage',
            contextPath: '/GMS_HEADER/GMS_XL_data'
        },
        CustomPageDefinitions
    );
});