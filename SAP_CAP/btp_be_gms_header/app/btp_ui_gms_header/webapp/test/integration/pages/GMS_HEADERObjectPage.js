sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'btpuigmsheader',
            componentId: 'GMS_HEADERObjectPage',
            contextPath: '/GMS_HEADER'
        },
        CustomPageDefinitions
    );
});