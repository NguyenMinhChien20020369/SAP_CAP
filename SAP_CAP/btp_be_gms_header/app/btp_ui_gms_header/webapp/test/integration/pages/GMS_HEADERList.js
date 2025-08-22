sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'btpuigmsheader',
            componentId: 'GMS_HEADERList',
            contextPath: '/GMS_HEADER'
        },
        CustomPageDefinitions
    );
});