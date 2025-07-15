const cds = require('@sap/cds')

module.exports = cds.service.impl(srv => {
    srv.before('NEW', 'Employees.drafts', async (req) => {
    console.log('11111', req);
    req.data.Department_ID = req.params[0].ID;
  })
})